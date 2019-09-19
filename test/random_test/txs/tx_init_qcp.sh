#!/bin/bash

source ~/qos/test/metrics.sh

# Function exec init-qcp
# - --creator $1 --qcp.crt $2
# Args:
# - $1 host
# - $2 tx
function exec_init_qcp(){
  # prepare tx args
  creator=${accounts[$(expr $RANDOM % ${#accounts[@]})]}
  crt=$ssh_qcp_crt

  # build tx args
  tx_args="--creator $creator --qcp.crt $crt"

  # build tx cmd and execute
  run_tx_cmd_and_update_metrics $1 "$ssh_qoscli tx $2 $tx_args --indent" "$ssh_qos_pwd $ssh_qos_pwd"
}
