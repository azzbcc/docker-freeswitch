FROM centos:8
LABEL maintainer="Clarence <xjh.azzbcc@gmail.com>"

# 系统更新
RUN \
    dnf update -y &&\
    dnf clean all

ARG hostuid=1000
ARG hostgid=1000

# 创建用户
RUN \
    groupadd --gid $hostgid --force freeswitch && \
    useradd --gid $hostgid --uid $hostuid --no-create-home --no-log-init --shell /sbin/nologin freeswitch

# 添加可执行文件以及核心库
ADD bin /usr/bin
ADD lib /usr/lib64

# 安装软件依赖
RUN \
    # 安装依赖
    dnf install -y speex speexdsp libedit && \
    # 清理缓存
    dnf clean all

# 安装常用模块
ADD mod /usr/lib64/freeswitch/mod

# 安装常用模块依赖
RUN \
    # 安装依赖
    dnf install -y mariadb-connector-c opus libsndfile && \
    # 清理缓存
    dnf clean all

# local_stream 文件
ADD music /usr/share/freeswitch/sounds/music

# 添加默认配置
ADD etc /etc/freeswitch

CMD ["freeswitch"]