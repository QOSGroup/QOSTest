#!/bin/bash

source ~/qos/test/metrics.sh

# Function exec delete-guardian
# - --address $1 --deleted-by $2
# Args:
# - $1 host
# - $2 tx
function exec_delete_guardian(){
  # prepare tx args
  address=${accounts[$(expr $RANDOM % ${#accounts[@]})]}
  deleted_by=${accounts[$(expr $RANDOM % ${#accounts[@]})]}

  # build tx args
  tx_args="--address $address --deleted-by $deleted_by"

  # build tx cmd and execute
  run_tx_cmd_and_update_metrics $1 "$ssh_qoscli tx $2 $tx_args --indent" "$ssh_qos_pwd"
}
