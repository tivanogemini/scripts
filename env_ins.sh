#! /bin/bash

echo "set up enviroment for app install"

apt-update -y
apt-upgrade -y
apt autoremove -y

echo "start to install neccessary tool from apt"

apt install jq -y
apt install snap -y

snap install core

apt install supvervisor -y

systemctl enable --now supervisor

echo "
    1. auto install ss without any parameter config
    2. manually install ss
    3. install kcptun, default bind to ss port
    4. install udp speeder
"

read -p "choose plan to install:" pj

case $pj in
    1)
        echo "start to install ss automatically"
        bash auto_ins_ss.sh
        ;;
    2)
        echo "start to install ss manually"
        bash manu_ins_ss.sh
        ;;
    3)
        echo "start to install kcp"
        bash auto_ins_kcp.sh
        ;;
    4)
        echo "start to install udpspeeder"
        bash auto_ins_usp.sh
        ;;
    *)
        echo "invalid input, check it"
        exit
        ;;
esac

exit
