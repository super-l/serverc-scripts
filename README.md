# 项目简介
linux服务器常用脚本集中营。分享了笔者自己编写的各种常用环境安装脚本，亲测无误的~

### ubuntu14.04系统 oracle前置安装脚本
ubuntu14-oracle11g.sh

注意：考虑到部分服务器安装后没有创建swap分区，脚本里面也实现了自动创建功能。
脚本里面注释掉了自动增加swap分区功能，有需要的自己取消注释即可开启。最好是根据自己的磁盘分区情况调整位置

### centos7系统 apache+php环境一键快速安装
apache_php.sh

用法：apache_php.sh 80 test test.superl.org

