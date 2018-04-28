#!/bin/bash
# Script unlock dropbear, webmin, squid3, openvpn, openssh
# Dev by kguza
echo -e "Please in put name user for unlock or unbanned user"

read -p "Username : " Login

usermod -U $Login
echo -e ""
echo -e "====Detail SSH Account===="
echo -e "Username: $Login :Has Unlocked You can login"
clear
menu