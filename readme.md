## 介绍

这是一个为小雅 alist的 docker 部署自动更新镜像，更新媒体目录，清理未使用 volume 的脚本，解决以下几个问题：
1. 小雅 alist 的 docker 最新镜像的拉取；
2. 重启容器获取最新媒体库，有时候重启后媒体库（目录）为空的问题；
3. 每日更新清理未使用的 volume 问题（改为挂载，重启时清理目录）；

完整代码仓库：[https://github.com/hsu1943/xiaoya-update](https://github.com/hsu1943/xiaoya-update)，代码仓库保持更新，以代码仓库为准。

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

## 备注

如果多次重启依然不更新目录；

检查一下是否可以访问：https://raw.githubusercontent.com/xiaoyaliu00/data/main

如果不能访问，那么就是下载更新文件的网络受阻；

**解决办法：**

1. 在小雅文件目录下，也就是放token的目录下新建`download_url.txt`文件；
2. 在文件中添加一行`https://xxxxxx/https://raw.githubusercontent.com/xiaoyaliu00/data/main`
3. 前面的`https://xxxxxx`部分查看在你的网络条件下，从下面找一个可以访问的，替换即可：

    > https://git.jasonml.xyz
    >
    > https://cdn.wygg.shop
    > 
    > https://gh.ddlc.top
    >
    > https://git.886.be
    >
    > https://gh.idayer.com
    >
    > https://slink.ltd

## 执行日志

```shell
2024-06-20 05:15:01 - 开始更新xiaoya容器
xiaoya
xiaoya
2024-06-20 05:15:12 - 清空alist临时目录
latest: Pulling from xiaoyaliu/alist
3c854c8cbf46: Already exists
fe0e33dc13e5: Pulling fs layer
9a4f75e4df14: Pulling fs layer
eff5472b69d4: Pulling fs layer
3e6af5d4096a: Pulling fs layer
45c12b75a75a: Pulling fs layer
5e5f386b502e: Pulling fs layer
1fb12090cd60: Pulling fs layer
4f4fb700ef54: Pulling fs layer
45c12b75a75a: Waiting
5e5f386b502e: Waiting
1fb12090cd60: Waiting
4f4fb700ef54: Waiting
3e6af5d4096a: Waiting
9a4f75e4df14: Download complete
3e6af5d4096a: Verifying Checksum
3e6af5d4096a: Download complete
fe0e33dc13e5: Verifying Checksum
fe0e33dc13e5: Download complete
fe0e33dc13e5: Pull complete
9a4f75e4df14: Pull complete
45c12b75a75a: Download complete
eff5472b69d4: Download complete
eff5472b69d4: Pull complete
3e6af5d4096a: Pull complete
45c12b75a75a: Pull complete
5e5f386b502e: Verifying Checksum
5e5f386b502e: Download complete
5e5f386b502e: Pull complete
1fb12090cd60: Download complete
1fb12090cd60: Pull complete
4f4fb700ef54: Verifying Checksum
4f4fb700ef54: Download complete
4f4fb700ef54: Pull complete
Digest: sha256:532cc40d7c3f223ddfca93fd956edd7d1fc53b4a09e8ad2519694a3232c6cc27
Status: Downloaded newer image for xiaoyaliu/alist:latest
docker.io/xiaoyaliu/alist:latest
2024-06-20 05:15:22 - 容器启动中...
a000307c07c17db70fcde9fa1f187b4f5faaed40ae480e93732db548db9e969b
2024-06-20 05:15:22 - 容器已启动，等待 120 秒...
2024-06-20 05:17:22 - 媒体目录更新检查
2024-06-20 05:17:22 - 关键字 'success load storage' 存在，媒体目录已更新
2024-06-20 05:17:22 - 清理未使用的镜像
```
