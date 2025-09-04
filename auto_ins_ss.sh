#! /bin/bash

echo "start to install ss-server"

snap install shadowsocks-libev --edge 

port=$(shuf -i 10000-65536 -n 1)
passwd=$(openssl rand -base64 16)
public_ip=$(curl -s http://checkip.amazonaws.com)
ipinfo_data=$(curl -s http://ipinfo.io/$public_ip/json)
country=$(jq -r '.country' <<< "$ipinfo_data")
isp=$(jq -r '.org' <<< "$ipinfo_data")

cat<<EOF>/var/snap/shadowsocks-libev/common/etc/shadowsocks-libev/config.json
{
	"server":["::0","0.0.0.0"],
	"server_port":$port,
	"password":"$passwd",
	"method":"chacha20-ietf-poly1305",
	"mode":"tcp_and_udp",
	"fast_open":false
}
EOF

systemctl enable snap.shadowsocks-libev.ss-server-daemon.service
systemctl start snap.shadowsocks-libev.ss-server-daemon.service

echo "service has been started."
echo -e "Your IP Address:	$public_ip"
echo -e "Your service port:	$port"
echo -e "Your passwd:		$passwd"
tmp=$(echo -n "chacha20-ietf-poly1305:${passwd}@${IPv4}:${port}" | base64 -w0)
sslink="ss://${tmp}#${isp}_${country}"
echo -e "Your ss link:	$sslink"

