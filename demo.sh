#!bin/bash

atimes=0

consGen(){
	port=$(shuf -i 10000-65536 -n 1)
	passwd=$(openssl rand -base64 16)
	IPv4=$(curl ipinfo.io/ip -s)
}

userCheck(){
	if [[ $(id -u) -eq 0 ]]; then
		echo "root autority check pass,continue"
	else
		echo "root autority check fail,exit"
		exit
	fi
}

envSet(){

	if [[ -f atimes.txt ]]; then
		atimes=$(cat atimes.txt)
	fi

	if [[ $atimes -eq 0 ]]; then
		apt update -y && apt upgrade -y
		apt install snap -y && apt install jq -y
		snap install core
		snap install shadowsocks-libev
		echo "apt updated,ss installed"
		atimes=$[atimes+1]
		echo $atimes > atimes.txt
	else
		echo "env has been setted once"

	fi
}

gatewaySet(){
	apt remove iptables* -y
	apt autoremove -y
	apt install ufw -y

	ufw allow ssh
	ufw allow $port

	ufw reload
}

IPinfoGet(){

	public_ip=$(curl -s http://checkip.amazonaws.com)
	ipinfo_data=$(curl -s http://ipinfo.io/$public_ip/json)
	country=$(jq -r '.country' <<< "$ipinfo_data")
	isp=$(jq -r '.org' <<< "$ipinfo_data")

	if [[ "$isp" == *"Google"* ]]; then
		isp="GCP"
	elif [[ "$isp" == *"Oracle"* ]]; then
		isp="Oracle"
	elif [[ "$isp" == *"Linode"* ]]; then
		isp="Linode"
	elif [[ "$isp" == *"DigitalOcean"* ]]; then
		isp="DigitalOcean"
	fi

}

confGen(){
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
}

servStart(){

	systemctl enable snap.shadowsocks-libev.ss-server-daemon.service
	systemctl start snap.shadowsocks-libev.ss-server-daemon.service

	echo "service has been started."
	echo -e "Your IP Address:	$public_ip"
	echo -e "Your service port:	$port"
	echo -e "Your passwd:		$passwd"
	tmp=$(echo -n "chacha20-ietf-poly1305:${passwd}@${IPv4}:${port}" | base64 -w0)
	sslink="ss://${tmp}#${isp}_${country}"
	echo -e "Your ss link:	$sslink"

}

main(){
	consGen
	userCheck
	envSet
	gatewaySet
	IPinfoGet
	confGen
	servStart
}