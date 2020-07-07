#!/bin/bash
set -e

if [ "$1" = 'freeswitch' ]; then
    # 创建目录
    mkdir --parents /var/{lib,log,run}/freeswitch

    # 目录用户组
    chown --recursive freeswitch:freeswitch /var/{lib,log,run}/freeswitch

    # 使用freeswitch用户执行
    exec "$@" -u freeswitch -g freeswitch -nonat -c
fi

exec "$@"
