#!/bin/bash

echo "bash script for Game Accelerator develop"
echo "based on miss lala's blog"


#1. root auth

if [[ $(id -u) -eq 0 ]]; then
	echo "root auth pass, exec script"
else
	echo "root check fail,re-run with root"
	exit
fi

cntr=0

if [[ -f cntr.txt ]]; then
	cntr=$(cat cntr.txt)
	echo $cntr
else
	apt update -y && apt upgrade -y
	apt -y install curl supervisor
	echo 1 > cntr.txt
	chmod 777 cntr.txt
fi


mkdir gatools 
chmod -R 777 gatools/ 
cd gatools
systemctl enable --now supervisor

echo $(pwd)

curl -L https://github.com/wangyu-/udp2raw/releases/download/20230206.0/udp2raw_binaries.tar.gz -o udp2raw_binaries.tar.gz
curl -L https://github.com/wangyu-/UDPspeeder/releases/download/20230206.0/speederv2_binaries.tar.gz -o speederv2_binaries.tar.gz 
curl -L https://github.com/xtaci/kcptun/releases/download/v20230214/kcptun-linux-amd64-20230214.tar.gz -o kcptun-linux-amd64-20230214.tar.gz

tar -zxvf $(pwd)/udp2raw_binaries.tar.gz
tar -zxvf $(pwd)/kcptun-linux-amd64-20230214.tar.gz
tar -zxvf $(pwd)/speederv2_binaries.tar.gz

mv $(pwd)/server_linux_amd64 usr/local/bin/kcptun
mv $(pwd)/speederv2_amd64 usr/local/bin/speeder
mv $(pwd)/udp2raw_amd64 usr/local/bin/udp2raw

mkdir -p /usr/local/etc/kcpser

cat<<EOF>/usr/local/etc/kcpser/config.json

EOF

cat<<EOF>/etc/supervisor/conf.d/game.conf
[program:kcptun]
command=/usr/local/bin/kcptun -c /usr/local/etc/kcpser/config.json
autostart=true
autorestart=true
redirect_stderr=false

[program:speederv2]
command=/usr/local/bin/speeder -s -l 0.0.0.0:14001 -r 127.0.0.1:47741 -f 2:4 -k "pubgpubg"
autostart=true
autorestart=true
redirect_stderr=false
EOF
