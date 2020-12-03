> 本文档已更新于 [【前端橘子君】](http://xiaoysosheng.top/#/engineering/npm私服) [【Github】](https://github.com/xiaoyaosheng-yu/library/blob/master/engineering/npm私服.md)

`verdaccio` 是一个 Node.js创建的轻量级私有npm仓库，具有易安装、易操作、较稳定的特点，应用范围广。

> [中文地址](https://verdaccio.org/zh-CN/)

本文介绍的是在`window`环境下的安装，`linux`环境大同小异。

### 安装node

傻瓜式教程，不细说，详情参考：[node安装](https://www.runoob.com/nodejs/nodejs-install-setup.html)

注意：官方要求`node > v8.x`，`npm >= 6.x` | `yarn >= 2.x` | `pnpm >= 4.x`。

### 安装verdaccio
```bash
npm install -g verdaccio
```

### 启动verdaccio
```bash
verdaccio
```
运行结果如下：
```bash
 C:\11253>verdaccio

 warn --- config file  - C:\Users\11253\AppData\Roaming\verdaccio\config.yaml
 warn --- Verdaccio started
 warn --- Plugin successfully loaded: verdaccio-htpasswd
 warn --- Plugin successfully loaded: verdaccio-audit
 warn --- http address - http://localhost:4873/ - verdaccio/4.9.1
```

这里指明了两个东西`配置文件`以及本地运行`端口`。

此时打开`http://localhost:4873/`就可以看到初始界面了，第一次进去列表肯定是空的，也不能登录，所以我们上传一个包。

### 上传包

1、准备好包后添加用户
```bash
npm adduser --registry http://localhost:4873
```

这里的地址就是刚刚运行时的`address`，此时要求输入`Username`，`Password`和`邮箱`。

这就是npm私服的账号密码。

2、上传
```bash
npm publish --registry http://localhost:4873
```

上传命令和npm一致，这里不细说。此时刷新私服界面就可以看到刚刚发布的包了，登录的账号密码就是刚刚输入的`Username`和`Password`。

### 守护进程pm2

`pm2`是`node`的一个进程守护工具，可以保证`node应用`进程长时间存在，而不会因用户退出而终止。

1、安装pm2
```bash
npm install -g pm2
```

2、启动
```bash
pm2 start verdaccio
```

### 使用

1、更改源
- 使用nrm
- 全局修改
- 临时使用

```bash
# 1、使用nrm
npm install -g nrm # 安装
nrm add localhost http://localhost:4873/ # 添加源，其中localhost是指别名，可以自由修改
nrm ls # 查看列表
nrm use localhost # 使用其中的一个源
npm install node-sass # 安装依赖

# 2、全局修改
npm config set registry http://localhost:4873/
npm install node-sass

# 3、临时使用
npm install node-sass --registry http://localhost:4873/
```

到此为止，npm私服的基本使用已经可以了。

### 配置文件说明
```bash
# 所有相对地址是相对于config.yaml文件的地址而言的
# 本地仓库的目录，即存放包的文件夹
storage: ./storage
# 插件目录的位置。对Docker/Kubernetes 基础上的配置非常有用。
plugins: ./plugins

# verdaccio启用的web应用相关配置，更多web-ui配置参考https://verdaccio.org/docs/zh-CN/webui
web:
  # web页title
  title: Verdaccio	
  # 注释掉以禁用gravatar支持
  # gravatar: false
  # 包的排序，正序/倒序 (asc|desc)
  # sort_packages: asc
  # 深色模式
  # darkMode: true

# 权限认证相关
auth:
  # 用户密码管理
  htpasswd:
    file: ./htpasswd	# 用户密码存放位置
    
    # 允许注册用户的最大值，默认1000，如果设置为-1不允许通过adduser添加用户，但是可以手动向htpasswd中添加用户
    # max_users: 1000

# 上游链路，缓存中找不到用户下载包时向上游链路请求资源
uplinks:
  npmjs:
    # 这里最好修改位淘宝镜像
    url: https://registry.npm.taobao.org/

# 包权限配置，@*/*scope包和**普通包的配置
packages:
  # 1. $all 所有用户
  # 2. $authenticated 表示只有通过验证的人(已注册)可以执行对应操作，注意，任何人都可以去注册账户。
  # 3. 或者也可以指定对应于之前我们配置的用户表 htpasswd 中的一个或多个用户，用空格分开即可
  # 4. $anonymous 表示只有匿名者可以进行对应操作（通常无用）
  
  # scoped包
  '@*/*':
    access: $all				# 访问权限，
    publish: $authenticated		# 发布权限
    unpublish: $authenticated	# 取消发布权限
    proxy: npmjs				# 如果请求的包不在服务器中，向配置的上游npmjs请求包

  # 普通包
  '**':
    access: $all
    publish: $authenticated
    unpublish: $authenticated
    proxy: npmjs

# 服务器相关配置
server:
  keepAliveTimeout: 60		# 超时时间

# 中间件配置
middlewares:
  # npm 审核认证
  audit:
    enabled: true

# 输出日志配置
logs:
  # type: stdout --- 控制台输出; file --- 输出到文件
  # path: 如果输出到文件类型，需要制定输出路径
  # format: 输出格式 [pretty, pretty-timestamped]
  # level: 日志级别	[fatal, error, warn, http, info, debug, trace]
  
  - { type: stdout, format: pretty, level: http }
  # - {type: file, path: verdaccio.log, level: info}
```

-------

更多相关文档，请见：

线上地址 [【前端橘子君】](http://xiaoysosheng.top)

GitHub仓库[【前端橘子君】](https://github.com/xiaoyaosheng-yu/library)