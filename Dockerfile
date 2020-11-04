# 安装node版本
FROM node:12.13.0

# 创建容器内的项目存放目录
RUN mkdir -p /home/docsify

# 将Dockerfile当前目录下所有文件拷贝至容器内项目目录并安装项目依赖
COPY . /home/docsify

WORKDIR /home/docsify

# 安装依赖
RUN npm install

# 容器对外暴露的端口号，要和node项目配置的端口号一致
EXPOSE 3000

# 容器启动时执行的命令
CMD [ "npm", "start" ]