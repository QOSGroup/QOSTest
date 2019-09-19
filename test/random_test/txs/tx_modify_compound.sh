#!/bin/bash

source ~/qos/test/metrics.sh

# Function exec modify-compound
# - --validator $1 --delegator $2
# - --validator $1 --delegator $2 --compound
# Args:
# - $1 host
# - $2 tx
function exec_modify_compound(){
  # prepare tx args
  validator=${validator_address[$(expr $RANDOM % ${#validator_address[@]})]}
  delegator=${delegator_account[$(expr $RANDOM % ${#delegator_account[@]})]}

  # build tx args
  type="type_"$(expr $RANDOM % 2)
  case $type in
    "type_0")
      tx_args="--validator $validator --delegator $delegator"
      ;;
    "type_1")
      tx_args="--validator $validator --delegator $delegator --compound"
      ;;
  esac

  # build tx cmd and execute
  run_tx_cmd_and_update_metrics $1 "$ssh_qoscli tx $2 $tx_args --indent" "$ssh_qos_pwd"
}
