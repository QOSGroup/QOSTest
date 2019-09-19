#!/bin/bash

source ~/qos/test/metrics.sh

# Function exec add-guardian
# - --address $1 --creator $2 --description $3
# Args:
# - $1 host
# - $2 tx
function exec_add_guardian(){
  # prepare tx args
  address=${accounts[$(expr $RANDOM % ${#accounts[@]})]}
  creator=${accounts[$(expr $RANDOM % ${#accounts[@]})]}
  description="Guardian-$address-created-by-$creator"

  # build tx args
  tx_args="--address $address --creator $creator --description $description"

  # build tx cmd and execute
  run_tx_cmd_and_update_metrics $1 "$ssh_qoscli tx $2 $tx_args --indent" "$ssh_qos_pwd"
}
