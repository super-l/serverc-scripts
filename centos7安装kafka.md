# 下载地址

```
官方地址：https://kafka.apache.org/downloads.html
其他地址1：http://mirrors.aliyun.com/apache/kafka/
其他地址1：https://mirror.bit.edu.cn/apache/kafka/
```

我们可以选择Binary包，不需要下载源码即可直接使用。

```
wget http://mirrors.aliyun.com/apache/kafka/3.2.3/kafka_2.12-3.2.3.tgz
tar -zxvf kafka_2.12-3.2.3.tgz -C /usr/local
```

## 修改配置文件

vi config/server.properties

listeners改为本机的ip，取消注释

zookeeper改为指定的，不使用自带的zk,zookeeper.connect = zk的ip:port

num.partitions后面增加2行

#发送到不存在topic不自动创建
auto.create.topics.enable=false
#允许永久删除topic
delete.topic.enable=true

后台启动
nohup ./bin/kafka-server-start.sh ./config/server.properties & 
4、发送消息

创建一个topic,名字为my_topic

sh bin/kafka-topics.sh --create --zookeeper 192.168.146.10:2181 --replication-factor 1 --partitions 1 --topic my_topic
查看已经创建的topic

sh bin/kafka-topics.sh -list -zookeeper 192.168.146.10:2181
启动Producer

sh bin/kafka-console-consumer.sh --bootstrap-server 192.168.146.10:9092 --topic my_topic--from-beginning
启动Consumer

sh bin/kafka-console-consumer.sh --bootstrap-server 192.168.146.10:9092 --topic my_topic--from-beginning
都重新再打开一个窗口，在解压目录下去执行这些命令，在Producer端发送消息，按enter键，Consumer就可以接受到消息了
