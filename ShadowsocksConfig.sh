#!/bin/bash
#适用于ubuntu20.04版本
#创建systemd文件
Systemd()
{
                sudo touch /etc/systemd/system/shadowsocks-server.service
                sudo echo "[Unit]" > /etc/systemd/system/shadowsocks-server.service
                sudo echo "Description=Shadowsocks Server" >> /etc/systemd/system/shadowsocks-server.service
                sudo echo "After=network.target" >> /etc/systemd/system/shadowsocks-server.service
                sudo echo "" >> /etc/systemd/system/shadowsocks-server.service
                sudo echo "[Service]" >> /etc/systemd/system/shadowsocks-server.service
                sudo echo "ExecStart=/usr/local/bin/ssserver -c /etc/shadowsocks/config.json" >> /etc/systemd/system/shadowsocks-server.service
                sudo echo "Restart=on-abort\\" >> /etc/systemd/system/shadowsocks-server.service
                sudo echo "" >> /etc/systemd/system/shadowsocks-server.service
                sudo echo "[Install]" >> /etc/systemd/system/shadowsocks-server.service
                sudo echo "WantedBy=multi-user.target" >> /etc/systemd/system/shadowsocks-server.service
}
#开启BBR加速（只需要一次）
BBR_ON()
{
    modprobe tcp_bbr
    echo "tcp_bbr" >> /etc/modules-load.d/modules.conf
    echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
    sysctl -p
}
#吞吐量优化
Capacity_ON()
{
    sudo touch /etc/sysctl.d/local.conf
    sudo echo "# max open files" >/etc/sysctl.d/local.conf
    sudo echo "fs.file-max = 51200"  >>/etc/sysctl.d/local.conf
    sudo echo "# max read buffer"    >>/etc/sysctl.d/local.conf
    sudo echo "net.core.rmem_max = 67108864" >>/etc/sysctl.d/local.conf
    sudo echo "# max write buffer"   >>/etc/sysctl.d/local.conf
    sudo echo "net.core.wmem_max = 67108864"   >>/etc/sysctl.d/local.conf
    sudo echo "# default read buffer"   >>/etc/sysctl.d/local.conf
    sudo echo "net.core.rmem_default = 65536"   >>/etc/sysctl.d/local.conf
    sudo echo "# default write buffer"   >>/etc/sysctl.d/local.conf
    sudo echo "net.core.wmem_default = 65536"   >>/etc/sysctl.d/local.conf
    sudo echo "# max processor input queue"   >>/etc/sysctl.d/local.conf
    sudo echo "net.core.netdev_max_backlog = 4096"   >>/etc/sysctl.d/local.conf
    sudo echo "# max backlog"   >>/etc/sysctl.d/local.conf
    sudo echo "net.core.somaxconn = 4096"   >>/etc/sysctl.d/local.conf

    sudo echo "# resist SYN flood attacks"   >>/etc/sysctl.d/local.conf
    sudo echo "net.ipv4.tcp_syncookies = 1"   >>/etc/sysctl.d/local.conf
    sudo echo "# reuse timewait sockets when safe"   >>/etc/sysctl.d/local.conf
    sudo echo "net.ipv4.tcp_tw_reuse = 1"
    sudo echo "# turn off fast timewait sockets recycling"   >>/etc/sysctl.d/local.conf
    sudo echo "net.ipv4.tcp_tw_recycle = 0"   >>/etc/sysctl.d/local.conf
    sudo echo "# short FIN timeout"   >>/etc/sysctl.d/local.conf
    sudo echo "net.ipv4.tcp_fin_timeout = 30"   >>/etc/sysctl.d/local.conf
    sudo echo "# short keepalive time"   >>/etc/sysctl.d/local.conf
    sudo echo "net.ipv4.tcp_keepalive_time = 1200"   >>/etc/sysctl.d/local.conf
    sudo echo "# outbound port range"   >>/etc/sysctl.d/local.conf
    sudo echo "net.ipv4.ip_local_port_range = 10000 65000"   >>/etc/sysctl.d/local.conf
    sudo echo "# max SYN backlog"   >>/etc/sysctl.d/local.conf
    sudo echo "net.ipv4.tcp_max_syn_backlog = 4096"   >>/etc/sysctl.d/local.conf
    sudo echo "# max timewait sockets held by system simultaneously"   >>/etc/sysctl.d/local.conf
    sudo echo "net.ipv4.tcp_max_tw_buckets = 5000"   >>/etc/sysctl.d/local.conf
    sudo echo "# turn on TCP Fast Open on both client and server side"   >>/etc/sysctl.d/local.conf
    sudo echo "net.ipv4.tcp_fastopen = 3"   >>/etc/sysctl.d/local.conf
    sudo echo "# TCP receive buffer"   >>/etc/sysctl.d/local.conf
    sudo echo "net.ipv4.tcp_rmem = 4096 87380 67108864"   >>/etc/sysctl.d/local.conf
    sudo echo "# TCP write buffer"   >>/etc/sysctl.d/local.conf
    sudo echo "net.ipv4.tcp_wmem = 4096 65536 67108864"   >>/etc/sysctl.d/local.conf
    sudo echo "# turn on path MTU discovery"   >>/etc/sysctl.d/local.conf
    sudo echo "net.ipv4.tcp_mtu_probing = 1"   >>/etc/sysctl.d/local.conf

    sudo echo "net.ipv4.tcp_congestion_control = bbr"   >>/etc/sysctl.d/local.conf

    sysctl --system

    sudo sed -i "6iExecStartPre=/bin/sh -c 'ulimit -n 51200'" /etc/systemd/system/shadowsocks-server.service
    sudo systemctl daemon-reload
    sudo systemctl restart shadowsocks-server
}
#优化配置(写的还不是很完善)
Optimize()
{
    echo "选择需要的操作："
    echo "1.开机启动项设置"
    echo "2.开启BBR加速(只需要开一次)"
    echo "3.吞吐量优化"
    echo "4.TCP Fast Open设置"
    read -r input
        case $input in
            [1])
            
                    while true
                    do
                        read -r -p "开启/关闭开机启动项[开启:1/关闭:2]" input
                        case $input in
                            [1])
                                sudo systemctl enable shadowsocks-server
                                if [ $? -eq 0 ]
                                then
                                    echo "已开启Shadowsocks开机启动项"
                                else
                                    echo "执行失败"
                                fi
                                break
                                ;;

                            [2])
                                sudo systemctl disable shadowsocks-server
                                if [ $? -eq 0 ]
                                then
                                    echo "已关闭开机启动项"
                                else
                                    echo "执行失败"
                                fi
                                break
                                ;;

                            *)
                                echo "不合法的输入!"
                                ;;
                        esac
                    done
                ;;

            [2])
                BBR_ON
                echo "已开启BBR加速"
                ;;

            [3])
                Capacity_ON
                echo "已开启吞吐量优化"
                ;;

                
            [4])
                sudo sed 's/\"fast_open\":false/\"fast_open\":true/' /etc/shadowsocks/config.json
                echo "已开启TCP Fast Open"
                ;;
                
            *)
                echo "不合法的输入!"
                ;;
        esac
}

#修改配置（还需要自己手动重启SS）
Change_Config()
{
    if [ ! -d "/etc/shadowsocks" ]
    then
    sudo mkdir /etc/shadowsocks
    fi
    sudo touch /etc/shadowsocks/config.json
    sudo echo -e "{ \"server\":\"0.0.0.0\",\n">/etc/shadowsocks/config.json
    sudo echo -e "\"local_address\":\"127.0.0.1\",\n">>/etc/shadowsocks/config.json
    sudo echo -e "\"port_password\":{\n">>/etc/shadowsocks/config.json
    echo "需要配置的端口数为:"
    #获取本机ip
    arg=$(ifconfig | grep 'inet'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $2}' )
    str="服务器ip：$arg\n"
    read num
    while (($num>0))
    do
        echo "输入端口号:"
        read port
        echo "输入密码:"
        read pw
        if [ $num == 1 ]
        then
            sudo echo -e "\"$port\":\"$pw\"\n},\n">>/etc/shadowsocks/config.json
        else
            sudo echo -e "\"$port\":\"$pw\",\n">>/etc/shadowsocks/config.json
        fi
        let "num--"
        str="$str端口号：$port 密码：$pw\n"
    done
    sudo echo -e "\"timeout\":300,\n">>/etc/shadowsocks/config.json
    echo "加密方式:"
    echo "1.chacha20（默认）"
    echo "2.rc4-md5"
    echo "3.aes-256-cfb"
    read method
    #或许改成数组会更好
    if [ $method == 3 ]
    then
        sudo echo -e "\"method\":\"aes-256-cfb\"\n">>/etc/shadowsocks/config.json
        str="$str加密方式：aes-256-cfb\n"
    elif  [ $method == 2 ]
    then
        sudo echo -e "\"method\":\"rc4-md5\"\n">>/etc/shadowsocks/config.json
        str="$str加密方式：rc4-md5\n"
    else
        sudo echo -e "\"method\":\"chacha20\"\n">>/etc/shadowsocks/config.json
        str="$str加密方式：chacha20\n"
    fi
    str="$str协议：origin\n混淆：plain\n"
    sudo echo -e "\"fast_open\":false\n}\n">>/etc/shadowsocks/config.json
    echo "配置完毕"
    echo "配置文件地址: /etc/shadowsocks/config.json"
    echo -e $str
}

#安装
Setup_SS()
{
    sudo apt-get update
    sudo apt-get install python3
    sudo apt install python3-pip
    sudo apt install net-tools
    sudo pip3 install https://github.com/shadowsocks/shadowsocks/archive/master.zip
    if [ ! -d "/etc/shadowsocks"] 
    then
    sudo mkdir /etc/shadowsocks
    fi
    sudo touch /etc/shadowsocks/config.json
    Change_Config
    Systemd
    while true
    do
        read -r -p "是否需要开机启动项? [Y/n] " input
        case $input in
            [yY][eE][sS]|[yY])
                sudo systemctl enable shadowsocks-server
                break
                ;;

            [nN][oO]|[nN])
            break
                ;;

            *)
                echo "不合法的输入!"
                ;;
        esac
    done
    while true
    do
        read -r -p "是否需要开启BBR加速? [Y/n] " input
        case $input in
            [yY][eE][sS]|[yY])
                BBR_ON
                echo "已开启BBR加速"
                break
                ;;

            [nN][oO]|[nN])
                break
                ;;

            *)
                echo "不合法的输入!"
                ;;
        esac
    done
    while true
    do
        read -r -p "是否需要吞吐量优化? [Y/n] " input
        case $input in
            [yY][eE][sS]|[yY])
                Capacity_ON
                echo "已开启吞吐量优化"
                break
                ;;

            [nN][oO]|[nN])
            break
                ;;

            *)
                echo "不合法的输入!"
                ;;
        esac
    done
    while true
    do
        read -r -p "是否需要开启TCP Fast Open? [Y/n] " input
        case $input in
            [yY][eE][sS]|[yY])
                sudo sed 's/\"fast_open\":false/\"fast_open\":true/' /etc/shadowsocks/config.json
                echo "已开启TCP Fast Open"
                break
                ;;

            [nN][oO]|[nN])
            break
                ;;

            *)
                echo "不合法的输入!"
                ;;
        esac
    done
    echo "配置完成！"
}

while true
do
echo "选择需要的操作："
echo "1.第一次安装"
echo "2.更改配置文件"
echo "3.启动Shadowsocks"
echo "4.停止Shadowsocks"
echo "5.优化和启动项设置"
echo "6.退出该脚本"
read flag
if [ $flag == 1 ]
then
    echo "开始安装"
    Setup_SS
    echo "安装完毕"
elif [ $flag == 2 ]
then
    Change_Config
elif [ $flag == 3 ]
then
    sudo systemctl start shadowsocks-server
    if [ $? -eq 0 ]
    then
        echo "Shadowsocks已开始工作"
    else
        echo "执行失败"
    fi
elif [ $flag == 4 ]
then
    sudo systemctl stop shadowsocks-server
    if [ $? -eq 0 ]
    then
        echo "Shadowsocks已停止"
    else
        echo "执行失败"
    fi
elif [ $flag == 5 ]
then
    Optimize
else
    break
fi
done



