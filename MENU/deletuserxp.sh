#!/bin/bash
#By kguza
echo "
=============================================
 credit   : Dev By Kguza
 Facebook : http://plang-vpn.online/Facebook
 Line     : Line http://plang-vpn.online/Line
 ============================================="
echo -e "         \033[1;33mRemover Usuarios Expirados\033[0m"
datahoje=$(date +%s)
for user in $(cat /etc/passwd |grep -v "nobody" |awk -F : '$3 > 900 {print $1}')
do
dataexp=$(chage -l $user |grep "Account expires" |awk -F : '{print $2}')
if [[ $dataexp == ' never' ]]; then
id > /dev/null 2>/dev/null
else
dataexpn=$(date -d"$dataexp" '+%d/%m/%Y')
dataexpnum=$(date '+%s' -d"$dataexp")
fi
if [[ $dataexpnum < $datahoje ]]; then
printf "\033[1;31m"
printf '%-41s' $user
printf "\033[0m"
echo "Expired Deleted"
kill $(ps -u $user |awk '{print $1}') >/dev/null 2>/dev/null ; userdel $user
else
printf "\033[1;32m"
printf '%-41s' $user
printf "\033[0m"
echo $dataexpn
fi
done