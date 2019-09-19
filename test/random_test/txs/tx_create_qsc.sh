#!/bin/bash

source ~/qos/test/metrics.sh

# Function exec create-qsc
# - --creator $1 --qsc.crt $2
# Args:
# - $1 host
# - $2 tx
function exec_create_qsc(){
  # prepare tx args
  creator=${accounts[$(expr $RANDOM % ${#accounts[@]})]}
  crt=$ssh_qsc_crt

  # build tx args
  tx_args="--creator $creator --qsc.crt $crt"

  # build tx cmd and execute
  run_tx_cmd_and_update_metrics $1 "$ssh_qoscli tx $2 $tx_args --indent" "$ssh_qos_pwd"
}
