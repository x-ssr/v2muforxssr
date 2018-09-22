#!/bin/bash
update_pid=$(ps ux | grep "./update.sh" | grep -v grep | awk '{print $2}')
v2ray_pid=$(ps ux | grep "$(readlink -f v2ray)" | grep -v grep | awk '{print $2}')
v2muctl_pid=$(ps ux | grep "$(readlink -f v2muforxssr)" | grep -v grep | awk '{print $2}')
if [ $update_pid ]; then
    echo "`date`: Updating, skip status check." >> log/auto_restart.log
    exit
fi
source ./mu.conf
if [ ! $v2ray_pid ]
then
	./run.sh
	echo "`date`: Auto Restart/Start V2ray Service" >> log/auto_restart.log
	exit
fi
if [ ! $v2muctl_pid ]
then
	./run.sh
	echo "`date`: Auto Restart/Start V2muctl Service" >> log/auto_restart.log
	exit
fi
status=`curl $MU_URI\/nodes\/$NodeId\/status -s`
if [ "$status" == "Offline" ]
then
	./run.sh
	echo "`date`: Auto Restart/Start V2ray Service" >> log/auto_restart.log
	exit
fi
./update.sh
exit