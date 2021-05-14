# README
~~一个交作业用的Ubuntu环境下搭建Shadowsocks3.0的辣鸡脚本~~
参考[Ubuntu-16-04下Shadowsocks服务器端安装及优化](https://www.polarxiong.com/archives/Ubuntu-16-04%E4%B8%8BShadowsocks%E6%9C%8D%E5%8A%A1%E5%99%A8%E7%AB%AF%E5%AE%89%E8%A3%85%E5%8F%8A%E4%BC%98%E5%8C%96.html)中的教程
适用于Ubuntu18.04以上的版本（其他版本没做过测试）
~~一次性脚本~~ **开启过的优化不要重复开启**  
操作选项：  
```
  1. 第一次安装          //可以使用
  2. 更改配置文件        //可以使用
  3. 启动Shadowsocks    //可以使用
  4. 停止Shadowsocks    //可以使用
  5. 优化和启动项设置    //慎用
  6. 退出该脚本
```

可开启的优化：
```
    1. 开机启动项设置             //开启or关闭开机自动启动
    2. 开启BBR加速(只需要开一次)  //多开可能会出问题
    3. 吞吐量优化                //多开可能会出问题
    4. TCP Fast Open设置        //需要开启吞吐量优化
```
