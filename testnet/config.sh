#!/bin/bash

local_host=$(ifconfig -a |grep inet |grep -v inet6 |grep -v 127 |head -n 1 |awk '{print $2}')
uploader=~/qos/expect/upload.expect

# metrics display control
enable_print_key_account_map="false"
enable_print_accounts="false"
enable_print_account_balance="true"

enable_print_avaliable_txs="false"

enable_print_delegator_account="false"
enable_print_delegation_key="false"
enable_print_delegation_info="false"
enable_print_delegation_last_income="false"
enable_print_delegation_current_income="false"

enable_print_guardians="false"

enable_print_validator_address="false"
enable_print_validator_brief="false"
enable_print_validator_description="false"
enable_print_validator_commission="false"
enable_print_validator_status="false"

enable_print_variables="true"

# local or remote ssh config
local=1

# local ssh config
ssh_hosts=(192.168.10.129 192.168.10.130)
ssh_pem="~/qos/test.pem"
ssh_usr="test"
ssh_pwd="12345678"
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

