#! /bin/bash

echo "script for udp speeder install"

ssPort=$(jq -r '.server_port' /var/snap/shadowsocks-libev/common/etc/shadowsocks-libev/config.json)


curl -L https://github.com/wangyu-/UDPspeeder/releases/download/20230206.0/speederv2_binaries.tar.gz -o usp.tar.gz

tar -zxvf usp.tar.gz

arc=$(arch)

case $arc in
    x86_64)
        mv speederv2_amd64 /usr/local/bin/usp
        ;;
    *)
        echo "please check your architecture with cmd arch or uname -i"
        echo "copy speederv2 with postfix of arch res to /usr/local/bin"
        echo "rename it to usp without any prefix or postfix"
        exit
        ;;
esac

cat<<EOF>>/etc/supervisor/conf.d/game.conf
[program:kcptun]
command=/usr/local/bin/usp -s -l 0.0.0.0:14001 -r 127.0.0.1:$ssPort -f 1:400 -k "pubgpubg"
autostart=true
autorestart=true
redirect_stderr=false

EOF

supervisorctl update
supervisor restart all

echo "usp installed,check net for sure"
puse=$(lsof -i:14001)

if [[ ! -n $puse ]]; then
    echo "service start failed,check it"
else
    echo "service started"
fi

exit

