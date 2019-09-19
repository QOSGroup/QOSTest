#!/bin/bash

source ~/qos/test/metrics.sh

# Function exec create-validator
# - --owner $1 --tokens $2 --moniker $3
# - --owner $1 --tokens $2 --moniker $3 --logo $4 --website $5 --details $6
# - --owner $1 --tokens $2 --moniker $3 --commission-rate $7 --commission-max-rate $8 --commission-max-change-rate $9
# - --owner $1 --tokens $2 --moniker $3 --logo $4 --website $5 --details $6 --commission-rate $7 --commission-max-rate $8 --commission-max-change-rate $9
# - --owner $1 --tokens $2 --compound --moniker $3
# - --owner $1 --tokens $2 --compound --moniker $3 --logo $4 --website $5 --details $6
# - --owner $1 --tokens $2 --compound --moniker $3 --commission-rate $7 --commission-max-rate $8 --commission-max-change-rate $9
# - --owner $1 --tokens $2 --compound --moniker $3 --logo $4 --website $5 --details $6 --commission-rate $7 --commission-max-rate $8 --commission-max-change-rate $9
# Args:
# - $1 host
# - $2 tx
function exec_create_validator(){
  # prepare tx args
  owner=${accounts[$(expr $RANDOM % ${#accounts[@]})]}
  tokens=$(expr $RANDOM % 100 + 1) 
  moniker="validator-$owner"
  logo="logo-of-$moniker"
  website="website-of-$moniker"
  details="details-of-$moniker"
  commission_rate="0.$(expr $RANDOM % 100)"
  commission_max_rate="0.$(expr $RANDOM % 100)"
  commission_max_change_rate="0.$(expr $RANDOM % 100)"

  # build tx args
  type="type_"$(expr $RANDOM % 8)
  case $type in
    "type_0")
      tx_args="--owner $owner --tokens $tokens --moniker $moniker"
      ;;
    "type_1")
      tx_args="--owner $owner --tokens $tokens --moniker $moniker --logo $logo --website $website --details $details"
      ;;
    "type_2")
      tx_args="--owner $owner --tokens $tokens --moniker $moniker --commission-rate $commission_rate --commission-max-rate $commission_max_rate --commission-max-change-rate $commission_max_change_rate"
      ;;
    "type_3")
      tx_args="--owner $owner --tokens $tokens --moniker $moniker --logo $logo --website $website --details $details --commission-rate $commission_rate --commission-max-rate $commission_max_rate --commission-max-change-rate $commission_max_change_rate"
      ;;
    "type_4")
      tx_args="--owner $owner --tokens $tokens --compound --moniker $moniker"
      ;;
    "type_5")
      tx_args="--owner $owner --tokens $tokens --compound --moniker $moniker --logo $logo --website $website --details $details"
      ;;
    "type_6")
      tx_args="--owner $owner --tokens $tokens --compound --moniker $moniker --commission-rate $commission_rate --commission-max-rate $commission_max_rate --commission-max-change-rate $commission_max_change_rate"
      ;;
    "type_7")
      tx_args="--owner $owner --tokens $tokens --compound --moniker $moniker --logo $logo --website $website --details $details --commission-rate $commission_rate --commission-max-rate $commission_max_rate --commission-max-change-rate $commission_max_change_rate"
      ;;
  esac

  # build tx cmd and execute
  run_tx_cmd_and_update_metrics $1 "$ssh_qoscli tx $2 $tx_args --indent" "$ssh_qos_pwd"
}
