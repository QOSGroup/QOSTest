#!/bin/bash

source ~/qos/test/metrics.sh

# Function exec active-validator
# - --validator $1 --owner $2
# - --validator $1 --owner $2 --tokens $2
# Args:
# - $1 host
# - $2 tx
function exec_active_validator(){
  # prepare tx args
  validator=${validator_address[$(expr $RANDOM % ${#validator_address[@]})]}
  validator2=${validator_address[$(expr $RANDOM % ${#validator_address[@]})]}
  owner=${validator_owner[$validator2]}
  tokens=$(expr $RANDOM % 10000 + 1)

  # build tx args
  tx_args="--validator $validator --owner $owner --tokens $tokens"

  # build tx cmd and execute
  run_tx_cmd_and_update_metrics $1 "$ssh_qoscli tx $2 $tx_args --indent" "$ssh_qos_pwd"
}
