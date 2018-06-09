#!/bin/bash
clear
if [[ $1 == "" ]]
then
echo " "
echo -e "\033[01;31m  

┅═हই✰•=======✮-[SERVER•❍•PREMIUM]-✮========•✰ইह═┅"
echo " "
echo " ╔•═•⊰✯⊱•═•⊰✯⊱•═•⊰✯⊱•═⊰✯⊱•═•⊰✯⊱═•╗"
echo " "
echo " ─═╬≫║✰ [-SETUP SCRIPT [ B [̲̅ Y [̲̅ BANK TK-] ✰║≪╬═─"
echo " "
echo " ╚••═•⊰✯⊱•═•⊰✯⊱•═•⊰✯⊱•═⊰✯⊱•═•⊰✯⊱═•╝"
echo " "
echo " ┅═हই✰•===✮-[Script OS Debian 32 & 64]-✮===•✰ইह═┅"
echo "====================================
  User backup And Restore ..? 
====================================
   {1} Backup
   {2} Restore"
   echo -e "\033[01;31m"
read -p "select : " opcao
else
opcao=$1
fi
case $opcao in
  1 | 01 )
tar cf /home/vps/public_html/user.tar /etc/passwd /etc/shadow /etc/gshadow /etc/group;;
 2 | 02 )
 cd /
 read -p "Put IP to restore  : " IP
wget -O user.tar "http://$IP:81/user.tar"
tar xf user.tar
rm user.tar;;
esac