#!/bin/bash

source ~/qos/test/metrics.sh

# Function exec invariant-check
# - --sender $1
# Args:
# - $1 host
# - $2 tx
function exec_invariant_check(){
  # prepare tx args
  sender=${accounts[$(expr $RANDOM % ${#accounts[@]})]}

  # build tx args
  tx_args="--sender $sender"

  # build tx cmd and execute
  run_tx_cmd_and_update_metrics $1 "$ssh_qoscli tx $2 $tx_args --indent" "$ssh_qos_pwd"
}
