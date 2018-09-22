#!/bin/bash
shellsVersion=`wget -q -O - https://raw.githubusercontent.com/x-ssr/v2muforxssr/dev/version.txt | grep 'ver:'| awk '{printf $2}'`
v2Version=`wget -q -O - https://api.github.com/repos/v2ray/v2ray-core/releases/latest | grep '"tag_name":'| awk '{printf $2}'`
ctlVersion=`wget -q -O - https://api.github.com/repos/x-ssr/v2muforxssr/releases/latest | grep '"tag_name":'| awk '{printf $2}'`
ctlVersion=${ctlVersion%\"*}
ctlVersion=${ctlVersion#\"*}
v2Version=${v2Version%\"*}
v2Version=${v2Version#\"*}
source ./mu.conf
if [ "$shellsVersion" != "" ]; then
    if [ "$shellsVersion" != "$ShVersion" ]; then
        echo "`date` : Updating shells..." >> log/update_log.log
        mkdir updatetmp
        cd updatetmp
        wget -O run.sh https://raw.githubusercontent.com/x-ssr/v2muforxssr/dev/run.sh
        wget -O stop.sh https://raw.githubusercontent.com/x-ssr/v2muforxssr/dev/stop.sh
        wget -O cleanLogs.sh https://raw.githubusercontent.com/x-ssr/v2muforxssr/dev/cleanLogs.sh
        wget -O catLogs.sh https://raw.githubusercontent.com/x-ssr/v2muforxssr/dev/catLogs.sh
        wget -O status.sh https://raw.githubusercontent.com/x-ssr/v2muforxssr/dev/status.sh
        wget -O update.sh https://raw.githubusercontent.com/x-ssr/v2muforxssr/dev/update.sh
        cd ..
        \cp -r -f updatetmp/* ./
        rm -rf updatetmp
        chmod +x *
        sed -i "44c ShVersion='$shellsVersion'" mu.conf
        echo "`date` : Shells Updated to $shellsVersion" >> log/update_log.log
    fi
fi
if [ "$v2Version" != "" ]; then
    if [ "$v2Version" != "$V2Version" ]; then
        echo "`date` : Updating v2ray..." >> log/update_log.log
        wget -O v2ray-linux-64.zip https://github.com/v2ray/v2ray-core/releases/download/$v2Version/v2ray-linux-64.zip
        unzip v2ray-linux-64.zip
        rm -rf v2ray-linux-64.zip
        \cp -r -f v2ray-$v2Version-linux-64/* ./
        rm -rf v2ray-$v2Version-linux-64
        chmod +x *
        sed -i "45c V2Version='$v2Version'" mu.conf
        echo "`date` : V2ray Updated to $v2Version" >> log/update_log.log
        ./run.sh
    fi
fi
if [ "$ctlVersion" != "" ]; then
    if [ "$ctlVersion" != "$CtlVersion" ]; then
        echo "`date` : Updating v2muforxssr..." >> log/update_log.log
        mkdir updatetmp
        cd updatetmp
        wget -O v2muforxssr https://github.com/x-ssr/v2muforxssr/releases/download/$ctlVersion/v2muforxssr
        cd ..
        \cp -r -f updatetmp/* ./
        rm -rf updatetmp
        chmod +x *
        sed -i "46c CtlVersion='$ctlVersion'" mu.conf
        echo "`date` : v2muforxssr Updated to $ctlVersion" >> log/update_log.log
        ./run.sh
    fi
fi
