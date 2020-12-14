#!/bin/env sh

siderouter="192.168.1.2"

restart_dnsmasq() {
    /etc/init.d/dnsmasq restart
}

dhcp_option=$(uci get dhcp.lan.dhcp_option)

if ping -c 1 "${siderouter}" > /dev/null
then
    echo "side router run normally"
    # resume dhcp_option
    if [ -n "$dhcp_option" ]; then
        echo "has option, do nothing"
    else
        uci add_list dhcp.lan.dhcp_option="3,$siderouter"
        uci add_list dhcp.lan.dhcp_option="6,$siderouter"
        uci commit dhcp
        restart_dnsmasq
    fi
else
    # remove dhcp_option
    uci del_list dhcp.lan.dhcp_option="3,$siderouter"
    uci del_list dhcp.lan.dhcp_option="6,$siderouter"
    uci commit dhcp
    restart_dnsmasq
fi
