#! /bin/bash

echo "please input your port for ss"
read -p "recommanded to between [10000~65535]:" port
read -p "please input your password for ss:"passwd

echo "please select encrypt method:"
echo "default method is chacha20-ietf-poly1305"
echo "1:none"
echo "2:rc4-md5"
echo "3:aes-128-cfb"
echo "4:ase-256-cfb"
echo "5:xchacha20-ietf-poly1305"
echo "6:aes-256-gcm"
echo "7:aes-128-gcm"
read -p "please input a number for encrypt choose:" enc

case $enc in
    1)
        method="none"
        ;;
    2)
        method="rc4-md5"
        ;;
    3)
        method="aes-128-cfb"
        ;;
    4)
        method="ase-256-cfb"
        ;;
    5)
        method="xchacha20-ietf-poly1305"
        ;;
    6)
        method="aes-256-gcm"
        ;;
    7)
        method="aes-128-gcm"
        ;;
    *)
        method="chacha20-ietf-poly1305"
        ;;
esac

echo "method has been set to:$method"

cat<<EOF>/var/snap/shadowsocks-libev/common/etc/shadowsocks-libev/config.json
{
	"server":["::0","0.0.0.0"],
	"server_port":$port,
	"password":"$passwd",
	"method":"$method",
	"mode":"tcp_and_udp",
	"fast_open":false
}
EOF

public_ip=$(curl -s http://checkip.amazonaws.com)
IPv4=$(curl ipinfo.io/ip -s)
ipinfo_data=$(curl -s http://ipinfo.io/$public_ip/json)
country=$(jq -r '.country' <<< "$ipinfo_data")
isp=$(jq -r '.org' <<< "$ipinfo_data")

systemctl enable snap.shadowsocks-libev.ss-server-daemon.service
systemctl start snap.shadowsocks-libev.ss-server-daemon.service

echo "service has been started."
echo -e "Your IP Address:	$public_ip"
echo -e "Your service port:	$port"
echo -e "Your passwd:		$passwd"
tmp=$(echo -n "chacha20-ietf-poly1305:${passwd}@${IPv4}:${port}" | base64 -w0)
sslink="ss://${tmp}#${isp}_${country}"
echo -e "Your ss link:	$sslink"

