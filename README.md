# 比赛工具

* `proxy/`: 比赛用服务器Socks代理
* `sync.sh`: 构建
* `build.sh`: 构建
* `benchmark.sh`: 基准测试
* `generate-patch.sh`: 生成当前分支的patch

## 准备

### 准备开发机

1. 启动[服务器VPN](./proxy/README.md)
1. 配置ssh, 参考配置文件如下. Host需与[`.env`](.env)中的设置一样.

   ``` sshconfig
   Host test-client.comp.oceanbase.com
       User root
       HostName 172.0.0.0
       ProxyCommand ncat --proxy-type socks5 --proxy 127.0.0.1:12038 %h %p
       ControlMaster auto
       ControlPath ~/.ssh/sockets/%r@%h-%p
       ControlPersist 60
   Host test-server.comp.oceanbase.com
       User root
       HostName 172.0.0.0
       ProxyCommand ncat --proxy-type socks5 --proxy 127.0.0.1:12038 %h %p
       ControlMaster auto
       ControlPath ~/.ssh/sockets/%r@%h-%p
       ControlPersist 60
   ```

### 准备服务器

1. 设置hosts, 需与[`.env`](.env)中的服务器的hostname设置一致.
1. 根据指南安装`obd-deploy`, 使用[`deploy.yml`](deploy.yaml)部署集群`ob-benchmark`.
   启动集群时可能需要修改sysctl和ulimit, 根据obd的日志修改即可.

### 准备测试机

1. 设置hosts, 需与[`.env`](.env)中的服务器的hostname设置一致.
1. 安装`obclient`和`sysbench`.