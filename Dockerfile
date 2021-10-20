FROM registry.cn-beijing.aliyuncs.com/azzbcc/freeswitch-build:latest as builder

# 安装音乐文件
RUN \
    mkdir -p /usr/share/freeswitch && \
    make moh-install

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
COPY --from=builder /usr/bin/freeswitch /usr/bin/fs_* /usr/bin/tone2wav /usr/bin/
COPY --from=builder /usr/lib64/libfreeswitch.so* /usr/lib64/
COPY --from=builder /usr/lib64/libsofia-sip-ua.so* /usr/lib64/
COPY --from=builder /usr/lib64/libspandsp.so* /usr/lib64/

# 安装软件依赖
RUN \
    # 安装依赖
    dnf install -y speex speexdsp libedit libtiff && \
    # 清理缓存
    dnf clean all

# 安装常用模块
COPY --from=builder /usr/lib64/freeswitch/mod/mod*.so /usr/lib64/freeswitch/mod/

# 安装常用模块依赖
RUN \
    # 安装依赖
    dnf install -y mariadb-connector-c opus libsndfile && \
    # 清理缓存
    dnf clean all

# local_stream 文件
COPY --from=builder /usr/share/freeswitch /usr/share/freeswitch

# 添加默认配置
ADD etc /etc/freeswitch

# 添加entrypoint.sh
ADD docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["freeswitch"]
