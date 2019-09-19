#!/bin/bash

source ~/qos/test/metrics.sh

# Function exec halt-network
# - --address $1 --description $2
# Args:
# - $1 host
# - $2 tx
function exec_halt_network(){
  # prepare tx args
  address=${accounts[$(expr $RANDOM % ${#accounts[@]})]}
  description="Halt-network-by-$address"

  # build tx args
  tx_args="--address $address --description $description"

  # build tx cmd and execute
  run_tx_cmd_and_update_metrics $1 "$ssh_qoscli tx $2 $tx_args --indent" "$ssh_qos_pwd"
}
