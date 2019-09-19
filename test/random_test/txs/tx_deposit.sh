#!/bin/bash

source ~/qos/test/metrics.sh

# Function exec deposit
# - --proposal-id $1 --depositor $2 --amount $3
# Args:
# - $1 host
# - $2 tx
function exec_deposit(){
  # prepare tx args
  proposal_id=$(expr $RANDOM % $latest_proposal_id + 1)
  depositor=${accounts[$(expr $RANDOM % ${#accounts[@]})]}
  amount=$(expr $RANDOM % 100 + 1)

  # build tx args
  tx_args="--proposal-id $proposal_id --depositor $depositor --amount $amount"

  # build tx cmd and execute
  run_tx_cmd_and_update_metrics $1 "$ssh_qoscli tx $2 $tx_args --indent" "$ssh_qos_pwd"
}
