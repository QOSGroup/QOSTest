#!/bin/bash

source ~/qos/test/metrics.sh

# Function exec increase-approve
# - --from $1 --to $2 --coins $3
# Args:
# - $1 host
# - $2 tx
function exec_increase_approve(){
  # prepare tx args
  from=${accounts[$(expr $RANDOM % ${#accounts[@]})]}
  to=${accounts[$(expr $RANDOM % ${#accounts[@]})]}
  coins="$(expr $RANDOM % 100 + 1)QOS"

  # build tx args
  tx_args="--from $from --to $to --coins $coins"

  # build tx cmd and execute
  run_tx_cmd_and_update_metrics $1 "$ssh_qoscli tx $2 $tx_args --indent" "$ssh_qos_pwd"
}
