#!/bin/bash

#--------------------------------------------
# oracle11g auto install
# author:    superl
# blog:      www.superl.org   github:https://github.com/super-l
# system:    oracle 11g R2 for ubuntu 14.04
#--------------------------------------------

#判断jdk是否安装
checkJdk()
{
    java -version
    if [ $? = 0 ];then
    JAVA_VERSION=`java -version 2>&1 |awk 'NR==1{ gsub(/"/,""); print $3 }'`    
    echo -e "\n\e[1;36mJDK is installed!"$JAVA_VERSION
    else
    echo -e "\n\e[1;36mJDK is not installed!\e[0m"
    installJDK
    fi
}


#安装图形界面
installDeskop()
{
    echo -e "\n\e[1;36mStart  -->>install deskop\e[0m"
    sudo apt-get -y install xubuntu-desktop
}


#安装jdk8
installJDK()
{
    echo -e "\n\e[1;36mStart  -->>install jdk8\e[0m"
    sudo apt-get install software-properties-common
    sudo add-apt-repository ppa:openjdk-r/ppa
    sudo apt-get update
    sudo apt-get -y install openjdk-8-jdk
    cd /etc/apt/sources.list.d
    rm -rf iopenjdk-r-ppa-trusty.list
    apt update
    cd ~
}

#更新jdk环境变量
updateEnvironment()
{
    echo -e "\n\e[1;36mStart  -->>update environment variables\e[0m"
    sed -i '$a export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64' /etc/profile
    sed -i '$a export JRE_HOME=${JAVA_HOME}/jre' /etc/profile
    sed -i '$a export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib' /etc/profile
    sed -i '$a export PATH=${JAVA_HOME}/bin:$PATH' /etc/profile
    
    source /etc/profile

    java -version
}

#自动安装依赖包
installPackage()
{
    echo -e "\n\e[1;36mStart -->>automatic install 1of2 dependency package\e[0m"
    apt-get  -y install automake autotools-dev binutils bzip2 elfutils expat gawk gcc gcc-multilib g++-multilib ksh less lib32z1 libaio1 libaio-dev libc6-dev libc6-dev-i386 libc6-i386 libelf-dev libltdl-dev libmotif4 libodbcinstq4-1 libodbcinstq4-1:i386 libpth-dev libpthread-stubs0-dev libstdc++5 lsb-cxx make openssh-server pdksh rlwrap rpm sysstat unixodbc unixodbc-dev unzip x11-utils zlibc

    echo -e "\n\e[1;36mStart -->>automatic install 2of2 dependency package\e[0m"

    cd /etc/apt/sources.list.d
    echo "deb http://old-releases.ubuntu.com/ubuntu/ raring main restricted universe multiverse" > ia32-libs-raring.list
    apt update

    apt-get -y install ia32-libs lesstif2 lesstif2-dev libpthread-stubs0

    rm -rf ia32-libs-raring.list
    apt update
}

#添加用户组合用户并设置用户内核限制
addUserGroup()
{
    echo -e "\n\e[1;36mStart -->>add user group\e[0m"

    sudo groupadd oinstall
    sudo groupadd dba

    USER_COUNT=`cat /etc/passwd | grep '^oracle:' -c`
    USER_NAME='oracle'
    USER_PASS='oraclepass'
    if [ $USER_COUNT -ne 1 ]
    then
        sudo useradd -g oinstall -g dba -m $USER_NAME
        #如果上一个命令正常运行，则输出成功，否则提示失败并以非正常状态退出程序
        # $?表示上一个命令的执行状态，-eq表示等于，[ 也是一个命令
        if [ $? -eq 0 ]; then
           echo -e "\n\e[1;36muser ${USER_NAME} is created successfully!!!"
        else
           echo -e "\n\e[1;36muser ${USER_NAME} is created failly!!!"
           exit 1
        fi

        echo $USER_PASS | sudo passwd $USER_NAME --stdin  &>/dev/null
        if [ $? -eq 0 ];then
           echo "${USER_NAME}'s password is set successfully"
        else
           echo "${USER_NAME}'s password is set failly!!!"
        fi
    else
        echo -e '\n\e[1;33muser exits\e[0m'
    fi

    echo -e "\n\e[1;36moracle's password is 'oracle?pass'\e[0m"

    echo -e "\n\e[1;36mStart  -->>update limits.conf\e[0m"
    sed -i '$a oracle soft nproc 2047' /etc/security/limits.conf
    sed -i '$a oracle hard nproc 16384' /etc/security/limits.conf
    sed -i '$a oracle soft nofile 1024' /etc/security/limits.conf
    sed -i '$a oracle hard nofile 65536' /etc/security/limits.conf
    sed -i '$a oracle soft stack 10240' /etc/security/limits.conf
}

#更新系统内核参数
updateSysctl()
{
    echo -e "\n\e[1;36mStart -->>update kernel parameters\e[0m"

    i1=`/sbin/sysctl -a | grep fs.aio-max-nr | awk '{print $3}'`
    i2=`/sbin/sysctl -a | grep file-max | awk '{print $3}'`
    i3=`/sbin/sysctl -a | grep shm | awk '{ if ($1=="kernel.shmall") print $3}'`
    i4=`/sbin/sysctl -a | grep shm | awk '{ if ($1=="kernel.shmmax") print $3}'`
    i5=`/sbin/sysctl -a | grep shm | awk '{ if ($1=="kernel.shmmni") print $3}'`
    i6=`/sbin/sysctl -a | grep sem | awk '{ if ($1=="kernel.sem") printf "%s %s %s %s", $3,$4,$5,$6}'`
    i7=`/sbin/sysctl -a | grep ip_local_port_range | awk '{ if ($1=="net.ipv4.ip_local_port_range") printf "%s %s", $3,$4}'`
    i8=`/sbin/sysctl -a | grep rmem_default | awk '{ if ($1=="net.core.rmem_default") print $3}'`
    i9=`/sbin/sysctl -a | grep rmem_max | awk '{ if ($1=="net.core.rmem_max") print $3}'`
    i10=`/sbin/sysctl -a | grep wmem_default | awk '{ if ($1=="net.core.wmem_default") print $3}'`
    i11=`/sbin/sysctl -a | grep wmem_max | awk '{ if ($1=="net.core.wmem_max") print $3}'`

    sed -i '$a fs.aio-max-nr = '${i1} /etc/sysctl.conf
    sed -i '$a fs.file-max = '${i2} /etc/sysctl.conf
    sed -i '$a kernel.shmall = '${i3} /etc/sysctl.conf
    sed -i '$a kernel.shmmax = '${i4} /etc/sysctl.conf
    sed -i '$a kernel.shmmni = '${i5} /etc/sysctl.conf
    sed -i '$a kernel.sem = 250 32000 100 128' /etc/sysctl.conf
    sed -i '$a net.ipv4.ip_local_port_range = 32768    61000' /etc/sysctl.conf
    sed -i '$a net.core.rmem_default = '${i8} /etc/sysctl.conf
    sed -i '$a net.core.rmem_max = '${i9} /etc/sysctl.conf
    sed -i '$a net.core.wmem_default = '${i10} /etc/sysctl.conf
    sed -i '$a net.core.wmem_max = '${i11} /etc/sysctl.conf

    unset i1
    unset i2
    unset i3
    unset i4
    unset i5
    unset i6
    unset i7
    unset i8
    unset i9
    unset i10
    unset i11
    cd ~
    sysctl -p
}

#创建需要的文件夹
makeNeedDir()
{
    mkdir /home/oracle/tools
    mkdir /home/oracle/tools/oracle11g
    chown -R oracle:dba /home/oracle/*
}

#更新oracle环境变量
updateOracleEnvironment()
{
    echo -e "\n\e[1;36mStart  -->>update orcale environment variables\e[0m"
    sed -i '$a export ORACLE_BASE=/home/oracle/tools/oracle11g' /etc/profile
    sed -i '$a export ORACLE_HOME=$ORACLE_BASE/product/11.2.0/dbhome_1' /etc/profile
    sed -i '$a export ORACLE_SID=orcl' /etc/profile
    sed -i '$a export ORACLE_UNQNAME=orcl' /etc/profile
    sed -i '$a export NLS_LANG=.AL32UTF8 ' /etc/profile
    sed -i '$a export PATH=${PATH}:${ORACLE_HOME}/bin/:$ORACLE_HOME/lib64;' /etc/profile
    source /etc/profile 
}

#欺骗oracle环境
oracleDeceit()
{
    echo -e "\n\e[1;36mStart  -->>deceit orcale!"
    sudo mkdir /usr/lib64
    sudo ln -s /etc /etc/rc.d
    sudo ln -s /lib/x86_64-linux-gnu/libgcc_s.so.1 /lib64/
    sudo ln -s /usr/bin/awk /bin/awk
    sudo ln -s /usr/bin/basename /bin/basename
    sudo ln -s /usr/bin/rpm /bin/rpm
    sudo ln -s /usr/lib/x86_64-linux-gnu/libc_nonshared.a /usr/lib64/
    sudo ln -s /usr/lib/x86_64-linux-gnu/libpthread_nonshared.a /usr/lib64/
    sudo ln -s /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /lib64/
    sudo ln -s /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /usr/lib64/
    echo 'Red Hat Linux release 5' > /etc/redhat-release
}


#解压准备安装oracle
unzipOracle()
{
    cd /home/oracle/tools/oracle11g
    #wget --limit-rate=600k -c http://www.woodfc.cn/sql/linux.x64_11gR2_database_1of2.zip
    #wget --limit-rate=600k -c http://www.woodfc.cn/sql/linux.x64_11gR2_database_2of2.zip

    unzip linux.x64_11gR2_database_1of2.zip
    unzip linux.x64_11gR2_database_2of2.zip

    cd /home/oracle/tools/oracle11g/database
    chmod 777 runInstaller
    #./runInstaller
}


#判断执行用户是否root
isroot()
{
    if [ $USER != "root" ];then
        echo -e "\n\e[1;31mthe user must be root,and now you user is $USER,please su to root. \e[0m"
        exit4
    else
        echo -e "\n\e[1;36mcheck root ... OK! \e[0m"
    fi
}

#设置swap分区
addSwap()
{
    mkdir /swapfile
    cd /swapfile
    dd if=/dev/zero of=swap bs=1024 count=1024000
    mkswap swap
    swapon swap
    sed -i '$a /swapfile/swap swap swap defaults 0 0' /etc/fstab
    echo -e "\n\e[1;36madd swap OK! \e[0m"
}

#关闭SELINUX
closeSelinux()
{
    cp /etc/selinux/config{,.ora_bak} && sed -i '/SELINUX/s/enforcing/disabled/;/SELINUX/s/permissive/disabled/'   /etc/selinux/config
    setenforce 0
    echo -e "\n\e[1;36mclose Selinux OK! \e[0m"
}




sudo apt-get update

# 设置swap分区
#addSwap

# 判断jdk是否安装，安装jdk8
checkJdk

# 更新环境变量
updateEnvironment

# 安装依赖
installPackage

# 创建用户和用户组
addUserGroup

# 创建oracle需要的文件夹
makeNeedDir

# 更新oracle环境变量
updateOracleEnvironment

#欺骗oracle环境
oracleDeceit

# 更新内核参数
updateSysctl

# 安装图形界面
installDeskop

# 解压准备安装啦
unzipOracle

#接下来需要进入图形界面运行./runInstaller去安装
