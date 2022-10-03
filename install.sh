
#!/bin/bash
#
# Original script by fornesia, rzengineer and fawzya
# Mod by LIFESTYLE-VPN wullop onuamit
# ==================================================

# go to root
cd

# Install Command
apt-get -y install ufw
apt-get -y install sudo

# set repo
wget -O /etc/apt/sources.list "https://raw.githubusercontent.com/dinfucker/SCRIPT-VPN/master/sources.list.debian8"
wget "https://raw.githubusercontent.com/dinfucker/SCRIPT-VPN/master/dotdeb.gpg"
wget "https://raw.githubusercontent.com/dinfucker/SCRIPT-VPN/master/jcameron-key.asc"
cat dotdeb.gpg | apt-key add -;rm dotdeb.gpg
cat jcameron-key.asc | apt-key add -;rm jcameron-key.asc

# update
apt-get update

# install webserver
apt-get -y install nginx

# install essential package
apt-get -y install nano iptables dnsutils openvpn screen whois ngrep unzip unrar

# install neofetch
echo "deb http://dl.bintray.com/dawidd6/neofetch jessie main" | sudo tee -a /etc/apt/sources.list
curl -L "https://bintray.com/user/downloadSubjectPublicKey?username=bintray" -o Release-neofetch.key && sudo apt-key add Release-neofetch.key && rm Release-neofetch.key
apt-get update
apt-get install neofetch

echo "clear" >> .bashrc
echo 'echo -e " ================================="' >> .bashrc
echo 'echo -e " Wallcom to server Debian7-8"' >> .bashrc
echo 'echo -e " Script mod by LIFESTYLE-VPN wullop onuamit"' >> .bashrc
echo 'echo -e " ---"' >> .bashrc
echo 'echo -e " prin { menu } Show menu items"' >> .bashrc
echo 'echo -e " ---"' >> .bashrc
echo 'echo -e ""' >> .bashrc

# install webserver
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/dinfucker/SCRIPT-VPN/master/nginx.conf"
mkdir -p /home/vps/public_html


wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/dinfucker/SCRIPT-VPN/master/vps.conf"
service nginx restart

# install openvpn
wget -O /etc/openvpn/openvpn.tar "https://raw.githubusercontent.com/dinfucker/SCRIPT-VPN/master/openvpn-debian.tar"
cd /etc/openvpn/
tar xf openvpn.tar
wget -O /etc/openvpn/1194.conf "https://raw.githubusercontent.com/dinfucker/SCRIPT-VPN/master/1194.conf"
service openvpn restart
sysctl -w net.ipv4.ip_forward=1
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
iptables -t nat -I POSTROUTING -s 192.168.100.0/24 -o eth0 -j MASQUERADE
iptables-save > /etc/iptables_yg_baru_dibikin.conf
wget -O /etc/network/if-up.d/iptables "https://raw.githubusercontent.com/dinfucker/SCRIPT-VPN/master/iptables"
chmod +x /etc/network/if-up.d/iptables
service openvpn restart

# konfigurasi openvpn
cd /etc/openvpn/
wget -O /etc/openvpn/True-Dtac.ovpn "https://raw.githubusercontent.com/dinfucker/SCRIPT-VPN/master/client-1194.conf"
MYIP=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | grep -v '192.168'`;
sed -i s/xxxxxxxxx/$MYIP/g /etc/openvpn/True-Dtac.ovpn;
cp True-Dtac.ovpn /home/vps/public_html/

# install badvpn
cd
wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/dinfucker/SCRIPT-VPN/master/badvpn-udpgw"
if [ "$OS" == "x86_64" ]; then
  wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/dinfucker/SCRIPT-VPN/master/badvpn-udpgw64"
fi
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300' /etc/rc.local
chmod +x /usr/bin/badvpn-udpgw
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300

# setting port ssh
cd
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 143' /etc/ssh/sshd_config
service ssh restart

# install dropbear
apt-get -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=443/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 443 -p 80"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
service ssh restart
service dropbear restart

# Install Squid
apt-get -y install squid3
cp /etc/squid3/squid.conf /etc/squid3/squid.conf.orig
wget -O /etc/squid3/squid.conf "https://raw.githubusercontent.com/dinfucker/SCRIPT-VPN/master/squid3.conf" 
MYIP=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | grep -v '192.168'`;
sed -i s/xxxxxxxxx/$MYIP/g /etc/squid3/squid.conf;
service squid3 restart

# install webmin
cd
wget -O webmin-current.deb "https://raw.githubusercontent.com/dinfucker/SCRIPT-VPN/master/webmin-current.deb"
dpkg -i --force-all webmin-current.deb
wget http://www.webmin.com/jcameron-key.asc
apt-key add jcameron-key.asc
apt-get update
apt-get install -y webmin
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
apt-get -y --force-yes -f install libxml-parser-perl
service webmin restart
service vnstat restart

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


echo "0 0 * * * root /sbin/reboot" > /etc/cron.d/reboot

# ssh 
ln -fs /usr/share/zoneinfo/Asia/Bangkok /etc/localtime
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
service ssh restart

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


# finishing
cd
chown -R www-data:www-data /home/vps/public_html
service nginx start
service openvpn restart
service cron restart
service ssh restart
service dropbear restart
service squid3 restart
service webmin restart
rm -rf ~/.bash_history && history -c
echo "unset HISTFILE" >> /etc/profile

# info
clear
echo " =============
 LIFESTYLE-VPN
 =============
 Service 
 ---------------------------------------------
 OpenSSH  : 22, 143 
 Dropbear : 80, 443 
 Squid3   : 8080, 3128 (limit to IP SSH) 
 ===========Detail OpenVPN Account ===========
 Download App
 http://$MYIP:81
 *********************************************
 Config OpenVPN (TCP 1194)
 Download File
 http://$MYIP:81/True-Dtac.ovpn
 =============================================
 badvpn   : badvpn-udpgw port 7300 
 nginx    : 81 
 Webmin   : http://$MYIP:10000/ 
 Timezone : Asia/Thailand (GMT +7) 
 IPv6     : [off] 
 =============================================
 credit.  : Dev By LIFESTYLE-VPN
 Facebook : https://www.facebook.com/jamejaturaporn.suriya.5
 website  : https://www.lifestyle-vpn.com
 ============================================="
echo " VPS AUTO REBOOT 00.00"
echo " prin { menu } show list on menu "
cd
echo "Auto Scrip Setup By LIFESTYLE-VPN" > admin
