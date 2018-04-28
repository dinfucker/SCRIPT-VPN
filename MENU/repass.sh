#!/bin/bash
read -p "old name: " namer
 if cat /etc/passwd |grep $namer: > /dev/null
 then
 echo " "
 else
 clear
 echo -e "\033[1;36muser $namer No name"
 exit
 fi
clear
echo -e "\033[1;36m[ Select menu \033[0m" 
echo -e "\033[1;36m1) change Password \033[0m" 
echo -e "\033[1;36m2) number of users\033[0m" 
echo -e "\033[1;36m3) Set new expiration date \033[0m" 
read -p "print: " option
if [ $option -eq 1 ]
then
read -p "Enter new passwd for $namer: " senha
(echo "$senha" ; echo "$senha" ) |passwd $namer > /dev/null 2>/dev/null
echo -e "\033[1;36mChange passwd successfully"
IP=`dig +short myip.opendns.com @resolver1.opendns.com`
echo -e "\033[1;36m***********************************"
echo -e "\033[1;36m********** Download File ********** "
echo -e "\033[1;36mhttp://$IP:81/$namer.ovpn"
echo -e "\033[1;36m***********************************"
echo -e "Line: Line http://plang-vpn.online/Line"
echo -e "Facebook : https://www.facebook.com/jamejaturaporn.suriya.5"
echo -e "website  : https://www.lifestyle-vpn.com"
echo -e "----------------------------------------------------------------"
echo -e "Back to menu LIFESTYLE-VPN"
echo -e "#===========================#
# L I F E S T Y L E - V P N #
#===========================#
machine-readable-output
allow-recursive-routing
ifconfig-nowarn
client
verb 4
dev tun
proto tcp
remote $IP:1194@www.truelife.com.line.naver.jp 1194 tcp-client
client
http-proxy $IP 8080
connect-retry 1
connect-timeout 120
resolv-retry infinite
route-method exe
nobind
ping 5
ping-restart 30
persist-key
persist-tun
persist-remote-ip
mute-replay-warnings
verb 2
sndbuf 393216
rcvbuf 393216
push "sndbuf 393216"
push "rcvbuf 393216"
cipher none
comp-lzo
script-security 3

<auth-user-pass>
$namer
$senha
</auth-user-pass>

<ca>
-----BEGIN CERTIFICATE-----
MIID4DCCA0mgAwIBAgIJAM3S4jaLTQBoMA0GCSqGSIb3DQEBBQUAMIGnMQswCQYD
VQQGEwJJRDERMA8GA1UECBMIV2VzdEphdmExDjAMBgNVBAcTBUJvZ29yMRQwEgYD
VQQKEwtKdWFsU1NILmNvbTEUMBIGA1UECxMLSnVhbFNTSC5jb20xFDASBgNVBAMT
C0p1YWxTU0guY29tMRQwEgYDVQQpEwtKdWFsU1NILmNvbTEdMBsGCSqGSIb3DQEJ
ARYObWVAanVhbHNzaC5jb20wHhcNMTMxMTA4MTQwODA3WhcNMjMxMTA2MTQwODA3
WjCBpzELMAkGA1UEBhMCSUQxETAPBgNVBAgTCFdlc3RKYXZhMQ4wDAYDVQQHEwVC
b2dvcjEUMBIGA1UEChMLSnVhbFNTSC5jb20xFDASBgNVBAsTC0p1YWxTU0guY29t
MRQwEgYDVQQDEwtKdWFsU1NILmNvbTEUMBIGA1UEKRMLSnVhbFNTSC5jb20xHTAb
BgkqhkiG9w0BCQEWDm1lQGp1YWxzc2guY29tMIGfMA0GCSqGSIb3DQEBAQUAA4GN
ADCBiQKBgQDO0s4v72Y+V1z3XpkQD8hVjYyJk1PzpaNGpubtVXf7b/2vhvYBfE3X
46NvpgQejsAI4rW7XWMZrAjFzQBPE0zDAt1O0ukvGRFvHr16jLuC3cZCn3oQJ0+v
HD7Z16sUhKqLWRTGAf1LDvNR3eVmzzRfBF8L3h+ZGaQFW9gsw1tSSwIDAQABo4IB
EDCCAQwwHQYDVR0OBBYEFA5gsoPi0yORhvAA38zCXOQhX4wYMIHcBgNVHSMEgdQw
gdGAFA5gsoPi0yORhvAA38zCXOQhX4wYoYGtpIGqMIGnMQswCQYDVQQGEwJJRDER
MA8GA1UECBMIV2VzdEphdmExDjAMBgNVBAcTBUJvZ29yMRQwEgYDVQQKEwtKdWFs
U1NILmNvbTEUMBIGA1UECxMLSnVhbFNTSC5jb20xFDASBgNVBAMTC0p1YWxTU0gu
Y29tMRQwEgYDVQQpEwtKdWFsU1NILmNvbTEdMBsGCSqGSIb3DQEJARYObWVAanVh
bHNzaC5jb22CCQDN0uI2i00AaDAMBgNVHRMEBTADAQH/MA0GCSqGSIb3DQEBBQUA
A4GBAL3ScsXaFFuBqkS8bDqDUkx2hYM2iAYx9ZEuz8DOgtenQiNcyety4YzWSE5b
1/4JSlrO0hoFAZpz6tZtB9XM5efx5zSEIn+w4+2bWUk34Ro2zM3JxwDUp1tTcpbT
T0G3VTuVrzgSMZV1unfbCHk6XR4VT3MmmoTl+97cmmMZgWV0
-----END CERTIFICATE-----
</ca>" > /home/vps/public_html/$namer-kguza.ovpn
exit
fi
if [ $option -eq 2 ]; then
read -p "number: " Maxmulti
echo -e "\033[1;36m Max Multiple $namer Login Successful"
exit
fi
if [ $option -eq 3 ]; then
echo -e "\033[1;36mQual a nova data : formato AAAA/MM/DD"
read -p ": " date
chage -E $date $namer 2> /dev/null
echo -e "\033[1;36mUsuario $namer Date: $date\033[0m"
exit
fi
