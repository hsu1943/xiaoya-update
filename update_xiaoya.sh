#!/usr/bin/env bash
set -e

source config.txt

echo $(date +"%Y-%m-%d %H:%M:%S") " - 开始更新xiaoya容器"
if docker ps -a | grep -q "$container_name"; then
    docker stop "$container_name" 2>/dev/null
    docker rm "$container_name" 2>/dev/null
    docker rmi xiaoyaliu/alist:latest 2>/dev/null
fi

if docker ps -a | grep -q "xiaoyaliu/alist"; then
    docker rmi xiaoyaliu/alist:latest 2>/dev/null
fi

echo $(date +"%Y-%m-%d %H:%M:%S") " - 正在拉取最新镜像..."
docker pull -q xiaoyaliu/alist:latest 2>/dev/null

echo $(date +"%Y-%m-%d %H:%M:%S") " - 清空alist临时目录"
rm -rf "${alist_dir}"/*

echo $(date +"%Y-%m-%d %H:%M:%S") " - 容器启动中..."
docker run -d -p 5678:80 -v $xiaoya_dir:/data -v $alist_dir:/opt/alist/data --restart=always --name=$container_name xiaoyaliu/alist:latest

echo $(date +"%Y-%m-%d %H:%M:%S") " - 容器已启动，等待 $wait_time 秒..."

sleep "$wait_time"

while true; do
    echo $(date +"%Y-%m-%d %H:%M:%S") " - 媒体目录更新检查"

    logs=$(docker logs --tail 10000 "$container_name")

    if echo "$logs" | grep -qF "$keyword"; then
        echo $(date +"%Y-%m-%d %H:%M:%S") " - 关键字 '$keyword' 存在，媒体目录已更新"
        break
    fi

    echo $(date +"%Y-%m-%d %H:%M:%S") " - 关键字 '$keyword' 不存在， 重启容器并等待 $wait_time 秒..."

    docker restart "$container_name"

    sleep "$wait_time"
done
