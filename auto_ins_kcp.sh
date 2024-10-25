#! /bin/bash

curl -L https://github.com/xtaci/kcptun/releases/download/v20240919/kcptun-linux-amd64-20240919.tar.gz -o kcp.tar.gz
ssPort=$(jq -r '.server_port' /var/snap/shadowsocks-libev/common/etc/shadowsocks-libev/config.json)
ipaddr=$(curl -s http://checkip.amazonaws.com)

tar -zxvf kcp.tar.gz

mv server_linux_amd64 /usr/local/bin/kcp

mkdir -p /usr/local/etc/kcpser

cat<<EOF>/usr/local/etc/kcpser/config.json
{
        "listen": ":33666-34690", 
        "target": "127.0.0.1:$ssPort", 
        "key": "pubgpubg", 
        "crypt": "twofish",
        "mode": "fast3",
        "mtu": 1400,
        "sndwnd": 2048,
        "rcvwnd": 2048,
        "datashard": 10,
        "parityshard": 0,
        "dscp": 0,
        "nocomp": true,
        "acknodelay": false,
        "sockbuf": 16777217,
        "keepalive": 10,
        "quiet":false,
        "tcp":false
}
EOF

cat<<EOF>/usr/local/etc/kcpser/cilconf.config
{
        "listen": ":$(shuf -i 33666-34690 -n 1)", 
        "target": "$ipaddr:$ssPort", 
        "key": "pubgpubg", 
        "crypt": "twofish",
        "mode": "fast3",
        "mtu": 1400,
        "sndwnd": 2048,
        "rcvwnd": 2048,
        "datashard": 10,
        "parityshard": 0,
        "dscp": 0,
        "nocomp": true,
        "acknodelay": false,
        "sockbuf": 16777217,
        "keepalive": 10,
        "quiet":false,
        "tcp":false
}

EOF

cat<<EOF>/etc/supervisor/conf.d/game.conf
[program:kcptun]
command=/usr/local/bin/kcptun -c /usr/local/etc/kcpser/config.json
autostart=true
autorestart=true
redirect_stderr=false

EOF

supervisorctl update
supervisorctl restart all

echo "kcptun has been set on ur device"

echo "cilent config are as belows:"
cat /usr/local/etc/kcpser/cilconf.config
echo '''usage are as belows:
    1. copy it to ur clipboard
    2. create a jsonfile and paste it to jsonfile
    3. save and import it to ur kcp gui
    4. or use cmd cilent-amd64.exe -c jsonfile path
'''

kcpconf="key=pubgpubg;mtu=1400;rcvwnd=2048;sndwnd=2048;datashard=10;parityshard=0;mode=fast3;sockbuf=16777217;dscp=0;crypt=twofish;nocomp"
echo "android kcp can use parameters below:"
echo $kcpconf

exit
