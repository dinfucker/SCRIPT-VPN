#!/bin/bash
#script by jiraphat yuenying for ubuntu 16

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

#install openvpn

apt-get purge openvpn easy-rsa -y;
apt-get purge squid -y;
apt-get update
MYIP=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";

apt-get update
apt-get install bc -y
apt-get -y install openvpn easy-rsa;
apt-get -y install python;

wget -O /etc/openvpn/openvpn.tar "https://raw.githubusercontent.com/jiraphaty/auto-script-vpn/master/openvpn.tar"
wget -O /etc/openvpn/default.tar "https://raw.githubusercontent.com/jiraphaty/auto-script-vpn/master/default.tar"
cd /etc/openvpn/
tar xf openvpn.tar
tar xf default.tar
cp sysctl.conf /etc/
cp before.rules /etc/ufw/
cp ufw /etc/default/
rm sysctl.conf
rm before.rules
rm ufw
systemctl restart openvpn

#install squid3

apt-get -y install squid;
cp /etc/squid/squid.conf /etc/squid/squid.conf.bak
wget -O /etc/squid/squid.conf "https://raw.githubusercontent.com/jiraphaty/auto-script-vpn/master/squid.conf"
sed -i $MYIP2 /etc/squid/squid.conf;
systemctl restart squid

#config client
cd /etc/openvpn/
wget -O /etc/openvpn/client.ovpn "https://raw.githubusercontent.com/jiraphaty/auto-script-vpn/master/client.ovpn"
sed -i $MYIP2 /etc/openvpn/client.ovpn;
cp client.ovpn /root/

ufw allow ssh
ufw allow 1194/tcp
ufw allow 8080/tcp
ufw allow 3128/tcp
ufw allow 80/tcp
yes | sudo ufw enable

# download script
cd /usr/bin
wget -O menu "https://raw.githubusercontent.com/dinfucker/SCRIPT-VPN/master/MENU/menu.sh"
wget -O 1 "https://raw.githubusercontent.com/dinfucker/SCRIPT-VPN/master/MENU/adduser.sh"
wget -O 2 "https://raw.githubusercontent.com/dinfucker/SCRIPT-VPN/master/MENU/testuser.sh"
wget -O 3 "https://raw.githubusercontent.com/dinfucker/SCRIPT-VPN/master/MENU/rename.sh"
wget -O 4 "https://raw.githubusercontent.com/dinfucker/SCRIPT-VPN/master/MENU/repass.sh"
wget -O 5 "https://raw.githubusercontent.com/dinfucker/SCRIPT-VPN/master/MENU/delet.sh"
wget -O 6 "https://raw.githubusercontent.com/dinfucker/SCRIPT-VPN/master/MENU/deletuserxp.sh"
wget -O 7 "https://raw.githubusercontent.com/dinfucker/SCRIPT-VPN/master/MENU/viewuser.sh"
wget -O 8 "https://raw.githubusercontent.com/dinfucker/SCRIPT-VPN/master/MENU/restart.sh"
wget -O 9 "https://raw.githubusercontent.com/dinfucker/SCRIPT-VPN/master/MENU/speedtest.py"
wget -O 10 "https://raw.githubusercontent.com/dinfucker/SCRIPT-VPN/master/MENU/online.sh"
wget -O 11 "https://raw.githubusercontent.com/dinfucker/SCRIPT-VPN/master/MENU/viewlogin.sh"
wget -O 12 "https://raw.githubusercontent.com/dinfucker/SCRIPT-VPN/master/MENU/aboutsystem.sh"
wget -O 13 "https://raw.githubusercontent.com/dinfucker/SCRIPT-VPN/master/MENU/lock.sh"
wget -O 14 "https://raw.githubusercontent.com/dinfucker/SCRIPT-VPN/master/MENU/unlock.sh"
wget -O 15 "https://raw.githubusercontent.com/dinfucker/SCRIPT-VPN/master/MENU/logscrip.sh"
wget -O 16 "https://raw.githubusercontent.com/dinfucker/SCRIPT-VPN/master/MENU/aboutscrip.sh"
wget -O 17 "https://raw.githubusercontent.com/dinfucker/SCRIPT-VPN/master/MENU/httpcredit.sh"
wget -O 18 "https://raw.githubusercontent.com/dinfucker/SCRIPT-VPN/master/MENU/TimeReboot.sh"
wget -O 19 "https://raw.githubusercontent.com/dinfucker/SCRIPT-VPN/master/MENU/backup.sh"
wget -O 20 "https://raw.githubusercontent.com/dinfucker/SCRIPT-VPN/master/MENU/ChangPassRoot.sh"
echo "0 0 * * * root /usr/bin/reboot" > /etc/cron.d/reboot
#echo "* * * * * service dropbear restart" > /etc/cron.d/dropbear
chmod +x menu
chmod +x 1
chmod +x 2
chmod +x 3
chmod +x 4
chmod +x 5
chmod +x 6
chmod +x 7
chmod +x 8
chmod +x 9
chmod +x 10
chmod +x 11
chmod +x 12
chmod +x 13
chmod +x 14
chmod +x 15
chmod +x 16
chmod +x 17
chmod +x 18
chmod +x 19
chmod +x 20
clear

printf '###############################\n'
printf '# Script by Jiraphat Yuenying #\n'
printf '#                             #\n'

printf '#                             #\n'
printf '#    พิมพ์ menu เพื่อใช้คำสั่งต่างๆ   #\n'
printf '###############################\n\n'
echo -e "ดาวน์โหลดไฟล์  : /root/client.ovpn\n\n"
printf '\n\nเพิ่ม user โดยใช้คำสั่ง useradd'
printf '\n\nตั้งรหัสโดย ใช้คำสั่ง passwd'
printf '\n\nคุณจำเป็นต้องรีสตาร์ทระบบหนึ่งรอบ (y/n):'
read a
if [ $a == 'y' ]
then
reboot
else
exit
fi
