#!/bin/bash
#Script del SSH & OpenVPN
read -p " user name removed : " User

if getent passwd $User > /dev/null 2>&1; then
        userdel $User
        echo -e "User $deleted:deleted Successfull"
else
        echo -e "Ainz: Kguza $User Not Found."
fi
