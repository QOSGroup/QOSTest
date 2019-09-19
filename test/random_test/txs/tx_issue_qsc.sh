#!/bin/bash

source ~/qos/test/metrics.sh

# Function exec issue-qsc
# - --qsc-name $1 --banker $2 --amount $3
# Args:
# - $1 host
# - $2 tx
function exec_issue_qsc(){
  # prepare tx args
  qsc_name=${ssh_qscs[$(expr $RANDOM % ${#ssh_qscs[@]})]}
  banker=${accounts[$(expr $RANDOM % ${#accounts[@]})]}
  amount=$(expr $RANDOM % 100 + 1)

  # build tx args
  tx_args="--qsc-name $qsc_name --banker $banker --amount $amount"

  # build tx cmd and execute
  run_tx_cmd_and_update_metrics $1 "$ssh_qoscli tx $2 $tx_args --indent" "$ssh_qos_pwd $ssh_qos_pwd"
}
