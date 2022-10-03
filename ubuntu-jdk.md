## 安装方式：

### 一：使用ppa(源)方式安装：

1）：添加ppa源
```
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
```

2）：安装oracle-java-installer（jdk8版本）
```
sudo apt-get install oracle-java8-installer
```
注：安装器会提示是否同意条款，根据提示选择yes即可，若不想手动输入，则可以采用以下方式自动完成：
```
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
```

3）：设置默认的jdk，可以安装多个jdk版本
```
sudo update-java-alternatives -s java-8-oracle
```

4）：测试jdk是否安装成功
```
java -version
javac -version
```

### 二：使用安装包安装：JDK官网下载地址

1）：官方下载对应的.gz包，这里以jdk-8u333-linux-x64.tar.gz为例

2）：创建一个目录用于存放解压后的文件，并解压缩到该目录下
```
sudo mkdir /usr/lib/jvm
sudo tar -zxvf jdk-8u333-linux-x64.tar.gz -C /usr/lib/jvm
```

3）：修改环境变量
```
sudo vim ~/.bashrc
```

4）：文件末尾追加如下内容
```
#set oracle jdk environment
export JAVA_HOME=/usr/lib/jvm/jdk1.8.0_333  ## 这里要注意目录要换成自己解压的jdk 目录
export JRE_HOME=${JAVA_HOME}/jre  
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib  
export PATH=${JAVA_HOME}/bin:$PATH
```

5）：使环境变量生效
```
source ~/.bashrc
```

6）：设置默认jdk
```
sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk1.8.0_333/bin/java 300  
sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk1.8.0_333/bin/javac 300  
sudo update-alternatives --install /usr/bin/jar jar /usr/lib/jvm/jdk1.8.0_333/bin/jar 300   
sudo update-alternatives --install /usr/bin/javah javah /usr/lib/jvm/jdk1.8.0_333/bin/javah 300   
sudo update-alternatives --install /usr/bin/javap javap /usr/lib/jvm/jdk1.8.0_333/bin/javap 300 
```

7）：执行
```
sudo update-alternatives --config java
```

8）：测试是否安装成功
```
java -version
javac -version
