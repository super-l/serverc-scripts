## 官网下载地址

https://downloads.apache.org/zookeeper/

```
wget https://downloads.apache.org/zookeeper/zookeeper-3.5.10/apache-zookeeper-3.5.10-bin.tar.gz
tar -zxvf apache-zookeeper-3.5.10-bin.tar.gz -C /usr/local
```

从目前的最新版本3.5.5开始，带有bin名称的包才是我们想要的下载可以直接使用的里面有编译后的二进制的包，而之前的普通的tar.gz的包里面是只是源码的包无法直接使用。
如 apache-zookeeper-3.6.3-bin.tar.gz 是安装包。apache-zookeeper-3.6.3.tar.gz 是源码。

## 建立文件夹、改名

进入conf目录，有一个zoo_sample.cfg文件，将其重命名为zoo.cfg

cd /usr/local/apache-zookeeper-3.5.10-bin/conf
mv zoo_sample.cfg zoo.cfg
vi /usr/local/apache-zookeeper-3.5.10-bin/conf/zoo.cfg

编辑该配置文件，在最后添加

```
dataDir=/usr/local/apache-zookeeper-3.5.10/data
dataDirLog=/usr/local/apache-zookeeper-3.5.10/log

注释 #dataDir=/tmp/zookeeper
```

## 后台启动
```
cd /usr/local/apache-zookeeper-3.5.10/
./zkServer.sh start

增加启动日志：

nohup ./zkServer.sh start >> /logs/zookeeper.file 2>&1 &
```

## 前台启动
```
cd /usr/local/apache-zookeeper-3.5.10/
zkServer.sh start-foreground   
```
若要查看日志可用前台启动


