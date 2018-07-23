#!/bin/bash
shellsVersion=`curl https://raw.githubusercontent.com/tonychanczm/easy-v2ray-mu/dev/version.txt -s`
v2Version=`wget -q -O - https://api.github.com/repos/v2ray/v2ray-core/releases/latest | grep '"tag_name":'| awk '{printf $2}'`
ctlVersion=`wget -q -O - https://api.github.com/repos/tonychanczm/easy-v2ray-mu/releases/latest | grep '"tag_name":'| awk '{printf $2}'`
ctlVersion=${ctlVersion%\"*}
ctlVersion=${ctlVersion#\"*}
v2Version=${v2Version%\"*}
v2Version=${v2Version#\"*}
source ./mu.conf
if [ "$shellsVersion" == "$ShVersion" ]; then
    echo 'Nothing to do, shells version is up to date'
else
    echo 'Updating shells...'
    wget -O run.sh https://raw.githubusercontent.com/tonychanczm/easy-v2ray-mu/dev/run.sh
    wget -O stop.sh https://raw.githubusercontent.com/tonychanczm/easy-v2ray-mu/dev/stop.sh
    wget -O cleanLogs.sh https://raw.githubusercontent.com/tonychanczm/easy-v2ray-mu/dev/cleanLogs.sh
    wget -O catLogs.sh https://raw.githubusercontent.com/tonychanczm/easy-v2ray-mu/dev/catLogs.sh
    wget -O status.sh https://raw.githubusercontent.com/tonychanczm/easy-v2ray-mu/dev/status.sh
    wget -O update.sh https://raw.githubusercontent.com/tonychanczm/easy-v2ray-mu/dev/update.sh
    chmod +x *
    sed -i "44c ShVersion='$shellsVersion'" mu.conf
    echo "Shells Updated to $shellsVersion"
fi
if [ "$v2Version" == "$V2Version" ]; then
    echo 'Nothing to do, v2ray version is up to date'
else
    echo 'Updating v2ray...'
    wget -O v2ray-linux-64.zip https://github.com/v2ray/v2ray-core/releases/download/$v2Version/v2ray-linux-64.zip
    unzip v2ray-linux-64.zip
    rm -rf v2ray-linux-64.zip
    \cp -r -f v2ray-$v2Version-linux-64/* ./
    rm -rf v2ray-$v2Version-linux-64
    chmod +x *
    sed -i "45c V2Version='$v2Version'" mu.conf
    echo "V2ray Updated to $v2Version"
fi
if [ "$ctlVersion" == "$CtlVersion" ]; then
    echo 'Nothing to do, v2mctl version is up to date'
else
    echo 'Updating v2mctl...'
    wget -O v2mctl https://github.com/tonychanczm/easy-v2ray-mu/releases/download/$ctlVersion/v2mctl
    chmod +x *
    sed -i "46c CtlVersion='$ctlVersion'" mu.conf
    echo "v2mctl Updated to $ctlVersion"
fi