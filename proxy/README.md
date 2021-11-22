# 比赛用服务器Socks代理

用docker在本地启动一个能访问测试服务器的socks代理

## 使用方法

1. 把举办方提供的`certs.zip`解压至`certs`文件夹中.
1. `mv config.ovpn ovpn.conf`
1. `docker compose -p obcomp-proxy up -d`, socks代理会在127.0.0.1:12038上监听.