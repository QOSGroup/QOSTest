#!/bin/bash

source ~/qos/test/metrics.sh

# Function exec modify-validator
# - --validator $0 --owner $1
# - --validator $0 --owner $1 --moniker $2 --logo $3 --website $4 --details $5
# - --validator $0 --owner $1 --commission-rate $6
# - --validator $0 --owner $1 --moniker $2 --logo $3 --website $4 --details $5 --commission-rate $6
# Args:
# - $1 host
# - $2 tx
function exec_modify_validator(){
  # prepare tx args
  validator=${validator_address[$(expr $RANDOM % ${#validator_address[@]})]}
  owner=${accounts[$(expr $RANDOM % ${#accounts[@]})]}
  moniker="validator-$owner"
  logo="logo-of-$moniker"
  website="website-of-$moniker"
  details="details-of-$moniker"
  commission_rate="0.$(expr $RANDOM % 100)"

  # build tx args
  type="type_"$(expr $RANDOM % 4)
  case $type in
    "type_0")
      tx_args="--validator $validator --owner $owner"
      ;;
    "type_1")
      tx_args="--validator $validator --owner $owner --moniker $moniker --logo $logo --website $website --details $details"
      ;;
    "type_2")
      tx_args="--validator $validator --owner $owner --commission-rate $commission_rate"
      ;;
    "type_3")
      tx_args="--validator $validator --owner $owner --moniker $moniker --logo $logo --website $website --details $details --commission-rate $commission_rate"
      ;;
  esac

  # build tx cmd and execute
  run_tx_cmd_and_update_metrics $1 "$ssh_qoscli tx $2 $tx_args --indent" "$ssh_qos_pwd"
}
