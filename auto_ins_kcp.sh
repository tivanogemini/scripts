#! /bin/bash

curl -L https://github.com/xtaci/kcptun/releases/download/v20240919/kcptun-linux-amd64-20240919.tar.gz -0 kcp.tar.gz
ssPort=$(jq -r '.server_port' /var/snap/shadowsocks-libev/common/etc/shadowsocks-libev/config.json)

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
        "nodelay": 1,
        "interval": 20,
        "resend": 2,
        "nc": 1,
        "sockbuf": 16777217,
        "smuxbuf": 16777217,
        "streambuf":4194304,
        "keepalive": 10,
        "pprof":false,
        "quiet":false,
        "tcp":false
}
EOF

echo "use configs below to enable kcp on Android:"

kcpconf=""
