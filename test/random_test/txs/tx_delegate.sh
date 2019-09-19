#!/bin/bash

source ~/qos/test/metrics.sh

# Function exec delegate
# - --validator $1 --delegator $2 --tokens $3
# - --validator $1 --delegator $2 --tokens $3 --compound
# Args:
# - $1 host
# - $2 tx
function exec_delegate(){
  # prepare tx args
  validator=${validator_address[$(expr $RANDOM % ${#validator_address[@]})]}
  delegator=${delegator_account[$(expr $RANDOM % ${#delegator_account[@]})]}
  tokens=$(expr $RANDOM % 100 + 1)

  # build tx args
  type="type_"$(expr $RANDOM % 2)
  case $type in
    "type_0")
      tx_args="--validator $validator --delegator $delegator --tokens $tokens"
      ;;
    "type_1")
      tx_args="--validator $validator --delegator $delegator --tokens $tokens --compound"
      ;;
  esac

  # build tx cmd and execute
  run_tx_cmd_and_update_metrics $1 "$ssh_qoscli tx $2 $tx_args --indent" "$ssh_qos_pwd"
}
