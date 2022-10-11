# ubuntu安装redis

## 安装
```
apt-get install redis-server
```

## 修改配置
```
vim /etc/redis/redis.conf
```

将其中的两项修改。
```
找到bind 127.0.0.1 ::1，把这行前面加个#注释掉
再查找protected-mode yes 把yes修改为no
同时将requirepass foobared取消注释，改为自己的密码
```

重启服务: systemctl restart redis-server.service

## 防火墙

给6379端口添加防火例外。
