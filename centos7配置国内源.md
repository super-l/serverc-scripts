1）、备份，将 CentOS-Base.repo 为CentOS-Base.repo.backup
```
cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
```

2）、下载新的 http://mirrors.aliyun.com/repo/Centos-7.repo,并命名为CentOS-Base.repo
```
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
或者
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
```

3）、清除缓存
```
yum clean all     # 清除系统所有的yum缓存
yum makecache     # 生成yum缓存
```

```
查看所有的yum源：
yum repolist all

查看可用的yum源：
yum repolist enabled
```
