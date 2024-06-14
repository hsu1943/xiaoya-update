#!/bin/bash
set -e

current_path="$(cd "$(dirname "$0")" && pwd)"
#echo "脚本所在目录是：$current_path"

source "$current_path/config.txt"

# 停止并删除容器
stop_rm_container() {
    local container_name=$1
    local alist_dir=$2
    if docker ps -a | grep -q "$container_name"; then
        docker stop "$container_name" 2>/dev/null
        docker rm "$container_name" 2>/dev/null
        echo "$(date +"%Y-%m-%d %H:%M:%S") - 清空alist临时目录"
        rm -rf "${alist_dir}"/*
    fi
}

# 运行容器
run_container() {
    local container_name=$1
    local xiaoya_dir=$2
    local alist_dir=$3
    echo "$(date +"%Y-%m-%d %H:%M:%S") - 容器启动中..."
    docker run -d -p 5678:80 -v "$xiaoya_dir:/data" -v "$alist_dir:/opt/alist/data" --restart=always --name="$container_name" xiaoyaliu/alist:latest
}

# 检查容器启动情况
check_container() {
    local container_name=$1
    local keyword=$2
    local wait_time=$3
    echo "$(date +"%Y-%m-%d %H:%M:%S") - 容器已启动，等待 $wait_time 秒..."
    sleep "$wait_time"
    while true; do
        echo "$(date +"%Y-%m-%d %H:%M:%S") - 媒体目录更新检查"
        logs=$(docker logs --tail 10000 "$container_name")
        if echo "$logs" | grep -qF "$keyword"; then
            echo "$(date +"%Y-%m-%d %H:%M:%S") - 关键字 '$keyword' 存在，媒体目录已更新"
            break
        fi
        echo "$(date +"%Y-%m-%d %H:%M:%S") - 关键字 '$keyword' 不存在，重启容器并等待 $wait_time 秒..."
        docker restart "$container_name"
        sleep "$wait_time"
    done
}

# 更新并启动容器
update_and_run_container() {
    local container_name=$1
    local xiaoya_dir=$2
    local alist_dir=$3
    local keyword=$4
    local wait_time=$5
    stop_rm_container "$container_name" "$alist_dir"
    docker pull xiaoyaliu/alist:latest
    run_container "$container_name" "$xiaoya_dir" "$alist_dir"
    check_container "$container_name" "$keyword" "$wait_time"
}

echo "$(date +"%Y-%m-%d %H:%M:%S") - 开始更新xiaoya容器"

# 更新并启动容器
update_and_run_container "$container_name" "$xiaoya_dir" "$alist_dir" "$keyword" "$wait_time"

echo "$(date +"%Y-%m-%d %H:%M:%S") - 清理未使用的镜像"
docker images | grep 'xiaoyaliu/alist' | grep -v 'latest' | awk '{print $3}' | xargs -r docker rmi > /dev/null 2>&1

exit 0
