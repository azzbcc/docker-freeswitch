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
