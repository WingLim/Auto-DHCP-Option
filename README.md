# Auto-DHCP-Option

A script to auto set Main Router's dhcp_option.

## Introduction

In our lan network, we have two router:

1. Main Router: Handle devices connect to Internet normally.

2. Side Router: Filter ads, get fastest dns record(by Smart DNS), go throw the GFW etc.

To make Side Router work, we need to set it as Gateway.

Fortunately, we don't need to set it manually. When devices send request to DHCP Server to get an IP, Main Router will return IP, Gateway and DNS Server.

We can set `dhcp_option` in Main Router's DHCP Server like this:

```config
3,192.168.1.2
6,192.168.1.2
```

`3` means Gateway's IP and `6` means DNS Server's IP.

But there is an problem: **If our Side Router down, we can't connect to Internet.**

So, I write this script to check if Side Router status, if it is down, remove `dhcp_option`, and manually reconnect devices to Main Router.

With that we can use Internet normally, and take some times to fix our Side Router.

## Usage

### Install

```shell
wget https://raw.githubusercontent.com/WingLim/dotfiles/Auto-DHCP-Option/ado_init.sh
sh ado_init.sh init your_side_router_ip
```

Script will creat a dir name `auto_dhcp_option` and generate `check_status.sh` in it.

Add a cron to execu `check_status.sh` every 10 mins.

### Remove

```shell
sh ado_init.sh remove
```

## License

MIT
