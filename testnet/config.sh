#!/bin/bash

local_host=$(ifconfig -a |grep inet |grep -v inet6 |grep -v 127 |head -n 1 |awk '{print $2}')
uploader=~/qos/expect/upload.expect

local=1

# local ssh config
ssh_hosts=(127.0.0.1)
ssh_usr="wangzijie"
ssh_pwd="wf.cy.zs.wzj"
ssh_qoscli="~/qos/bin/qoscli"
ssh_qosd="~/qos/bin/qosd"
ssh_qos_pwd="12345678"
ssh_qcp_crt="~/qos/certs/qcp.crt"
ssh_qsc_crt="~/qos/certs/qsc.crt"
ssh_qscs=("star")

if [ $local == 0 ];then
  # remote ssh config
  ssh_hosts=(192.168.1.224 192.168.1.225 192.168.1.226 192.168.1.227)
  ssh_usr="vagrant"
  ssh_pwd="qianbao2019"
  ssh_qoscli="~/bin/qoscli"
  ssh_qosd="~/bin/qosd"
  ssh_qos_pwd="12345678"
  ssh_qcp_crt="~/bin/qcp.crt"
  ssh_qsc_crt="~/bin/qsc.crt"
  ssh_qscs=("qstar" "AOE")
fi

