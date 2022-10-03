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

## 修改kafka相关配置

vi config/server.properties
```
listeners改为本机的ip，取消注释

zookeeper改为指定的，不使用自带的zk,zookeeper.connect = zk的ip:port
zookeeper.connect = localhost:2181
zookeeper.session.timeout.ms=6000
zookeeper.connection.timeout.ms =6000
zookeeper.sync.time.ms =2000


num.partitions后面增加2行

#发送到不存在topic不自动创建
auto.create.topics.enable=false

#允许永久删除topic
delete.topic.enable=true

# 每一个broker在集群中的唯一表示，要求是正数。当该服务器的IP地址发生改变时，broker.id没有变化，则不会影响consumers的消息情况
broker.id=0     

#broker处理消息的最大线程数，一般情况下数量为cpu核数
num.network.threads=2    

#broker处理磁盘IO的线程数，数值为cpu核数2倍
num.io.threads=8           

#socket的发送缓冲区，socket的调优参数SO_SNDBUFF
socket.send.buffer.bytes=1048576         

#socket的接受缓冲区，socket的调优参数SO_RCVBUFF
socket.receive.buffer.bytes=1048576         

#socket请求的最大数值，防止serverOOM，message.max.bytes必然要小于socket.request.max.bytes，会被topic创建时的指定参数覆盖
socket.request.max.bytes=104857600         

#kafka数据的存放地址，多个地址的话用逗号分割,多个目录分布在不同磁盘上可以提高读写性                                                                能
log.dirs=/usr/local/kafka/kafka-logs             

#每个topic的分区个数，若是在topic创建时候没有指定的话会被topic创建时的指定参数覆盖
num.partitions=2                                         

log.retention.hours=168

log.segment.bytes=536870912               

#topic每个分区的最大文件大小，一个topic的大小限制 = 分区数*log.retention.bytes。-1没有大小 限log.retention.bytes和log.retention.minutes任意一个达到要求，都会执行删除，会被topic创建时的指定参数覆盖

#文件大小检查的周期时间，是否处罚 log.cleanup.policy中设置的策略
log.retention.check.interval.ms=60000     

#是否开启日志清理
log.cleaner.enable=false                        

#
zookeeper.connect=localhost:2181
zookeeper.connection.timeout.ms=1000000  #ZooKeeper的最大超时时间，就是心跳的间隔，若是没有反映，那么认为已经死了，不易过        大
```

## 后台启动

nohup ./bin/kafka-server-start.sh ./config/server.properties & 

## 发送消息

创建一个topic,名字为my_topic

sh bin/kafka-topics.sh --create --zookeeper 192.168.146.10:2181 --replication-factor 1 --partitions 1 --topic my_topic
查看已经创建的topic

sh bin/kafka-topics.sh -list -zookeeper 192.168.146.10:2181
启动Producer

sh bin/kafka-console-consumer.sh --bootstrap-server 192.168.146.10:9092 --topic my_topic--from-beginning
启动Consumer

sh bin/kafka-console-consumer.sh --bootstrap-server 192.168.146.10:9092 --topic my_topic--from-beginning
都重新再打开一个窗口，在解压目录下去执行这些命令，在Producer端发送消息，按enter键，Consumer就可以接受到消息了
