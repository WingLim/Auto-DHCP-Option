#!/bin/env sh

action=$1
siderouter_ip=$2

case $action in
    "init")
        if [ -z "$siderouter_ip" ]; then
            echo "Missing argument: siderouter ip"
            exit
        fi
        mkdir -p /root/siderouter_manager
        cat > /root/siderouter_manager/check_status.sh <<EOF
#!/bin/env sh

siderouter="$siderouter_ip"

restart_dnsmasq() {
    /etc/init.d/dnsmasq restart
}

dhcp_option=$(uci get dhcp.lan.dhcp_option)

if ping -c 1 "\${siderouter}" > /dev/null
then
    echo "side router run normally"
    # resume dhcp_option
    if [ -n "\$dhcp_option" ]; then
        echo "has option, do nothing"
    else
        uci add_list dhcp.lan.dhcp_option="3,\$siderouter"
        uci add_list dhcp.lan.dhcp_option="6,\$siderouter"
        uci commit dhcp
        restart_dnsmasq
    fi
else
    # remove dhcp_option
    uci del_list dhcp.lan.dhcp_option="3,\$siderouter"
    uci del_list dhcp.lan.dhcp_option="6,\$siderouter"
    uci commit dhcp
    restart_dnsmasq
fi
EOF
        echo "* */10 * * * /root/siderouter_manager/check_status.sh" >> /etc/crontabs/root
    ;;
    "remove")
        sed -i "/\* \*\/10 \* \* \* \/root\/siderouter_manager\/check_status.sh/d" /etc/crontabs/root
        rm -r /root/siderouter_manager
        /etc/init.d/dnsmasq reload
    ;;
    *)
        echo "Please use 'init' or 'remove' action."
    ;;
esac