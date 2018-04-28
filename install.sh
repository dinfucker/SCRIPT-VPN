
#!/bin/bash
#
# Original script by fornesia, rzengineer and fawzya
# Mod by kguza wullop onuamit
# ==================================================

# go to root
cd

# Install Command
apt-get -y install ufw
apt-get -y install sudo

# set repo
wget -O /etc/apt/sources.list "http://tepsus-slow-vpn.xyz/auto/sources.list.debian8"
wget "http://tepsus-slow-vpn.xyz/auto/dotdeb.gpg"
wget "http://tepsus-slow-vpn.xyz/auto/jcameron-key.asc"
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
echo 'echo -e " Script mod by kguza wullop onuamit"' >> .bashrc
echo 'echo -e " ยซยซยซยซยซยซยซยซยซยซยซยซยซยซยซยซยซยปยปยปยปยปยปยปยปยปยปยปยปยปยปยปยป"' >> .bashrc
echo 'echo -e " prin { menu } Show menu items"' >> .bashrc
echo 'echo -e " ยซยซยซยซยซยซยซยซยซยซยซยซยซยซยซยปยปยปยปยปยปยปยปยปยปยปยปยปยป"' >> .bashrc
echo 'echo -e ""' >> .bashrc

# install webserver
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "http://tepsus-slow-vpn.xyz/auto/nginx.conf"
mkdir -p /home/vps/public_html


wget -O /etc/nginx/conf.d/vps.conf "http://tepsus-slow-vpn.xyz/auto/vps.conf"
service nginx restart

# install openvpn
wget -O /etc/openvpn/openvpn.tar "http://tepsus-slow-vpn.xyz/auto/openvpn-debian.tar"
cd /etc/openvpn/
tar xf openvpn.tar
wget -O /etc/openvpn/1194.conf "http://tepsus-slow-vpn.xyz/auto/1194.conf"
service openvpn restart
sysctl -w net.ipv4.ip_forward=1
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
iptables -t nat -I POSTROUTING -s 192.168.100.0/24 -o eth0 -j MASQUERADE
iptables-save > /etc/iptables_yg_baru_dibikin.conf
wget -O /etc/network/if-up.d/iptables "http://tepsus-slow-vpn.xyz/auto/iptables"
chmod +x /etc/network/if-up.d/iptables
service openvpn restart

# konfigurasi openvpn
cd /etc/openvpn/
wget -O /etc/openvpn/True-Dtac.ovpn "http://tepsus-slow-vpn.xyz/auto/client-1194.conf"
MYIP=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | grep -v '192.168'`;
sed -i s/xxxxxxxxx/$MYIP/g /etc/openvpn/True-Dtac.ovpn;
cp True-Dtac.ovpn /home/vps/public_html/

# install badvpn
cd
wget -O /usr/bin/badvpn-udpgw "http://tepsus-slow-vpn.xyz/auto/badvpn-udpgw"
if [ "$OS" == "x86_64" ]; then
  wget -O /usr/bin/badvpn-udpgw "http://tepsus-slow-vpn.xyz/auto/badvpn-udpgw64"
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
wget -O /etc/squid3/squid.conf "http://tepsus-slow-vpn.xyz/auto/squid3.conf" 
MYIP=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | grep -v '192.168'`;
sed -i s/xxxxxxxxx/$MYIP/g /etc/squid3/squid.conf;
service squid3 restart

# install webmin
cd
wget -O webmin-current.deb "http://tepsus-slow-vpn.xyz/auto/webmin-current.deb"
dpkg -i --force-all webmin-current.deb;
apt-get -y -f install;
rm /root/webmin-current.deb
service webmin restart

# download script
cd /usr/bin
wget -O menu "http://tepsus-slow-vpn.xyz/auto/menu.sh"
wget -O a "http://tepsus-slow-vpn.xyz/auto/adduser.sh"
wget -O b "http://tepsus-slow-vpn.xyz/auto/testuser.sh"
wget -O c "http://tepsus-slow-vpn.xyz/auto/rename.sh"
wget -O d "http://tepsus-slow-vpn.xyz/auto/repass.sh"
wget -O e "http://tepsus-slow-vpn.xyz/auto/delet.sh"
wget -O f "http://tepsus-slow-vpn.xyz/auto/deletuserxp.sh"
wget -O g "http://tepsus-slow-vpn.xyz/auto/viewuser.sh"
wget -O h "http://tepsus-slow-vpn.xyz/auto/restart.sh"
wget -O i "http://tepsus-slow-vpn.xyz/auto/speedtest.py"
wget -O j "http://tepsus-slow-vpn.xyz/auto/online.sh"
wget -O k "http://tepsus-slow-vpn.xyz/auto/viewlogin.sh"
wget -O l "http://tepsus-slow-vpn.xyz/auto/aboutsystem.sh"
wget -O m "http://tepsus-slow-vpn.xyz/auto/lock.sh"
wget -O n "http://tepsus-slow-vpn.xyz/auto/unlock.sh"
wget -O o "http://tepsus-slow-vpn.xyz/auto/logscrip.sh"
wget -O p "http://tepsus-slow-vpn.xyz/auto/aboutscrip.sh"
wget -O q "http://tepsus-slow-vpn.xyz/auto/httpcredit.sh"
wget -O r "http://tepsus-slow-vpn.xyz/auto/TimeReboot.sh"

echo "0 0 * * * root /sbin/reboot" > /etc/cron.d/reboot

# เธ•เธฑเนเธเธเนเธฒเน€เธเธ•เน€เธงเธฅเธฒ, เนเธฅเธเธญเธฅ ssh เธฃเธตเธชเธ•เธฒเธฃเนเธ— เธเธฃเธดเธเธฒเธฃ ssh 
ln -fs /usr/share/zoneinfo/Asia/Bangkok /etc/localtime
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
service ssh restart

chmod +x menu
chmod +x a
chmod +x b
chmod +x c
chmod +x d
chmod +x e
chmod +x f
chmod +x g
chmod +x h
chmod +x i
chmod +x j
chmod +x k
chmod +x l
chmod +x m
chmod +x n
chmod +x o
chmod +x p
chmod +x q
chmod +x r

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
 Kguza figther
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
 credit.  : Dev By Kguza
 Facebook : http://plang-vpn.online/Facebook
 Line     : Line http://plang-vpn.online/Line
 website:http://plang-vpn.online/Website
 ============================================="
echo " VPS AUTO REBOOT 00.00"
echo " ยซยซยซยซยซยซยซยซยซยซยซยซยซยซยซยปยปยปยปยปยปยปยปยปยปยปยปยปยปยปยป " 
echo " prin { menu } show list on menu "
echo " ยซยซยซยซยซยซยซยซยซยซยซยซยซยซยซยปยปยปยปยปยปยปยปยปยปยปยปยปยปยปยป "
cd
echo "Auto Scrip Setup By Kguza" > admin
