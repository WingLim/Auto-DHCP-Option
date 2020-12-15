# Auto-DHCP-Option

A script to auto set Main Router's dhcp_option.

## Introduction

Our network topology:

![Main&Side Router](images/Main&Side%20Router.png)

`3` means Gateway's IP and `6` means DNS Server's IP.

But there is an problem: **If our Side Router down, we can't connect to Internet.**

So, this script will check Side Router status, if it is down, remove `dhcp_option`.

If Side Router is down, we can manually reconnect devices to Main Router, and use Internet normally.

## Usage

### Install

Run below command in **Main Router**.

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
