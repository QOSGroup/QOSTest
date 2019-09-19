#!/bin/bash

source ~/qos/test/metrics.sh

# Function exec revoke-validator
# - --validator $1 --owner $1
# Args:
# - $1 host
# - $2 tx
function exec_revoke_validator(){
  # prepare tx args
  validator=${validator_address[$(expr $RANDOM % ${#validator_address[@]})]}
  owner=${accounts[$(expr $RANDOM % ${#accounts[@]})]}

  # build tx args
  tx_args="--validator $validator --owner $owner"

  # build tx cmd and execute
  run_tx_cmd_and_update_metrics $1 "$ssh_qoscli tx $2 $tx_args --indent" "$ssh_qos_pwd"
}
