#!/bin/bash
#a strange script to install v2ray-mu
clear
mu_uri='null'
mu_key='null'
node_id=$1
echo '-------------------------------'
echo '|  Configuring Easy-V2ray-Mu  |'
echo '-------------------------------'
if [ ! $node_id ];
then 
	echo 'Please enter your Node ID:'
	read node_id
fi
echo '-------------------------------'
echo '|        Your Configure       |'
echo '-------------------------------'
echo 'Your Node ID:'
echo $node_id
echo 'Is it OK?(y/n)'
isok=n
read isok
if [ $isok != 'y' -a $isok != 'Y' ];
then 
	echo 'Quit Install'
	exit
fi
echo '-------------------------------'
echo '|        Installing...        |'
echo '-------------------------------'
yum install unzip -y
yum install crontabs -y
chkconfig --level 35 crond on
service crond start
clear
echo -e "\033[33m ____            _  __     __\n|  _ \ _ __ ___ (_) \ \   / /\n| |_) | '__/ _ \| |  \ \ / / \n|  __/| | | (_) | |   \ V /  \n|_|   |_|  \___// |    \_/ \033[5mInstaling...\033[0m\033[33m  \n              |__/          for Mu_api\n\033[0m"
echo 'Getting Latest Version...'
v2Version=`wget -q -O - https://api.github.com/repos/v2ray/v2ray-core/releases/latest | grep '"tag_name":'| awk '{printf $2}'`
ctlVersion=`wget -q -O - https://api.github.com/repos/x-ssr/v2muforxssr/releases/latest | grep '"tag_name":'| awk '{printf $2}'`
ctlVersion=${ctlVersion%\"*}
ctlVersion=${ctlVersion#\"*}
v2Version=${v2Version%\"*}
v2Version=${v2Version#\"*}
shellsVersion=`wget -q -O - https://raw.githubusercontent.com/x-ssr/v2muforxssr/dev/version.txt | grep 'ver:'| awk '{printf $2}'`
echo -e "\033[33m Shells Version:\033[32m $shellsVersion\033[0m"
echo -e "\033[33m V2ray Version :\033[32m $v2Version\033[0m"
echo -e "\033[33m Muctl Version :\033[32m $ctlVersion\033[0m"
sleep 1
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
wget -O v2ray-linux-64.zip https://github.com/v2ray/v2ray-core/releases/download/$v2Version/v2ray-linux-64.zip
unzip v2ray-linux-64.zip
rm -rf v2ray-linux-64.zip
mv v2ray-$v2Version-linux-64 v2ray-mu
cd v2ray-mu
mkdir log
touch log/error.log
touch log/access.log
touch log/v2ray-mu.log
wget https://raw.githubusercontent.com/x-ssr/v2muforxssr/dev/cfg.json
wget https://github.com/x-ssr/v2muforxssr/releases/download/$ctlVersion/v2muforxssr
wget https://raw.githubusercontent.com/x-ssr/v2muforxssr/dev/mu.conf
sed -i "s;##mu_uri##;$mu_uri;g" mu.conf
sed -i "s;##mu_key##;$mu_key;g" mu.conf
sed -i "s;##node_id##;$node_id;g" mu.conf
sed -i "s;##ShVersion##;$shellsVersion;g" mu.conf
sed -i "s;##V2Version##;$v2Version;g" mu.conf
sed -i "s;##CtlVersion##;$ctlVersion;g" mu.conf
wget https://raw.githubusercontent.com/x-ssr/v2muforxssr/dev/run.sh
wget https://raw.githubusercontent.com/x-ssr/v2muforxssr/dev/stop.sh
wget https://raw.githubusercontent.com/x-ssr/v2muforxssr/dev/cleanLogs.sh
wget https://raw.githubusercontent.com/x-ssr/v2muforxssr/dev/catLogs.sh
wget https://raw.githubusercontent.com/x-ssr/v2muforxssr/dev/status.sh
wget https://raw.githubusercontent.com/x-ssr/v2muforxssr/dev/update.sh
chmod +x *
thisPath=$(readlink -f .)
isCronRunsh=`grep "&& ./run.sh" /var/spool/cron/root|awk '{printf $7}'`
isCronStatsh=`grep "&& ./status.sh" /var/spool/cron/root|awk '{printf $7}'`
if [ "$isCronRunsh" != "$thisPath" ]; then
    echo "30 4 * * * cd $(readlink -f .) && ./run.sh">> /var/spool/cron/root
fi
if [ "$isCronRunsh" != "$thisPath" ]; then
    echo "*/3 * * * * cd $(readlink -f .) && ./status.sh">> /var/spool/cron/root
fi
echo '--------------------------------'
echo -e '|       \033[33mInstall finshed\033[0m        |'
echo -e '|\033[32mplease run this command to run\033[0m|'
echo -e '-----------\033[33m V  V  V \033[0m------------'
echo -e "\033[32mcd $(readlink -f .) && ./run.sh\033[0m"

