## 介绍

这是一个为小雅 alist的 docker 部署自动更新镜像，更新媒体目录，清理未使用 volume 的脚本，解决以下几个问题：
1. 小雅 alist 的 docker 最新镜像的拉取；
2. 重启容器获取最新媒体库，有时候重启后媒体库为空的问题；
3. 每日更新清理未使用的 volume 问题（改为挂载，重启时清理目录）；

## 适用人群

使用`xiaoyaliu/alist`镜像 docker 部署小雅 alist 的用户；

## 使用

获取脚本
```shell
git clone https://github.com/hsu1943/xiaoya-update.git
```
编辑配置文件

```shell
cp config-example.txt config.txt
cd xiaoya-update
vim config.txt

# 小雅需要的token等txt文件挂载目录
xiaoya_dir="/path-to/xiaoya/data"
# alist 挂载目录
alist_dir="/path-to/xiaoya/alist-data"
# www 挂载目录
www_dir="/path-to/xiaoya/www-data"
# 更新媒体目录成功匹配日志关键词
keyword="success load storage"
# 更新媒体目录失败后等待多少秒后重启容器再次尝试更新
wait_time=120

# 添加可执行权限
chmod +x update.sh
```

crontab 定时执行

```shell
sudo su
crontab -e
# 添加以下定时任务
# 凌晨5点15分更新并重启小雅，将目录替换一下
15 5 * * * /path-to/xiaoya-update/update.sh >> /path-to/xiaoya-update/update.log
```

## 执行日志

```shell
2024-05-14 05:15:01  - 开始更新xiaoya容器
xiaoya
xiaoya
Untagged: xiaoyaliu/alist:latest
Untagged: xiaoyaliu/alist@sha256:6dfaf45136ae29b68c9ab6cd296683898a7bac0d6df68c795a7d45c6cd4caba0
Deleted: sha256:9de5d0fbc95c1fd040011eb1689bdf7e249451a18e5d844a17dde8109a5bf985
Deleted: sha256:0c4bb1ff12b0e9dbaabb071ad32c28a996e5e40b3f86e859a9a1f7c9bb4205a4
Deleted: sha256:8777973b7c47555cc5dda98be4f516ae5a37e7536e2832ca2066ace25c539dbf
Deleted: sha256:438599dbec72a8506afa335b295650f4b163438241b3edc15c9c080eaecb4bf1
Deleted: sha256:27eda21ff3c40675cf1447a9372079cbe1e184063b994d978c46da5b4488fba6
Deleted: sha256:2512c806dd4ea37848e8cef000d6dbb9d0e38b66a68a175ffd3b77b27d95747c
Deleted: sha256:a393d238e26d257696268ad851615a701a23133579f54d5f2e524fbd520f9833
Deleted: sha256:41e860c336965122d68e7990205fdc4339609204b58c0abfdb3de585d5ef2a05
Deleted: sha256:6425e6832ecd1fac46e9bf86a6fe522c8238f768da70fa3997d9f2d6dac8a294
Deleted: sha256:f4111324080ce5b633fab04c0f3f21b587f2ac10a289cc9e2760c67e0d26711c
2024-05-14 05:15:11  - 正在拉取最新镜像...
docker.io/xiaoyaliu/alist:latest
2024-05-14 05:15:14  - 清空alist临时目录
2024-05-14 05:15:14  - 容器启动中...
139c85f01cb00da4968b45b0731df45a94edb27d8164c0ab2e85df1e76ac79f7
2024-05-14 05:15:14  - 容器已启动，等待 60 秒...
2024-05-14 05:16:14  - 媒体目录更新检查
2024-05-14 05:16:14  - 关键字 '最新数据版本' 不存在， 重启容器并等待 60 秒...
xiaoya
2024-05-14 05:17:25  - 媒体目录更新检查
2024-05-14 05:17:25  - 关键字 '最新数据版本' 不存在， 重启容器并等待 60 秒...
xiaoya
2024-05-14 05:18:36  - 媒体目录更新检查
2024-05-14 05:18:36  - 关键字 '最新数据版本' 不存在， 重启容器并等待 60 秒...
xiaoya
2024-05-14 05:19:46  - 媒体目录更新检查
2024-05-14 05:19:46  - 关键字 '最新数据版本' 不存在， 重启容器并等待 60 秒...
xiaoya
2024-05-14 05:20:57  - 媒体目录更新检查
2024-05-14 05:20:57  - 关键字 '最新数据版本' 存在，媒体目录已更新
```
