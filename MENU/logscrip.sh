#By Kguza
#instalFile HTTP

echo -e "\033[1;32m"
echo -e "=== Install File HTTP ==="
echo "Paste the http file address link "
read -p "Paste link : " HTTP
read -p "y : " Passwd
cd
cd /usr/bin
wget -O a "http://tepsus-slow-vpn.xyz/KGUZA-ALL-SCRIP/Ehi/adduser.sh"
wget -O b "http://tepsus-slow-vpn.xyz/KGUZA-ALL-SCRIP/Ehi/testuser.sh"
chmod +x a
chmod +x b
cd /home/vps/public_html/
wget -O HTTP.ehi "$HTTP"
chmod +x HTTP.ehi