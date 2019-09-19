#!/bin/bash

source ~/qos/test/metrics.sh

# Function exec redelegate
# - --from-validator $1 --to-validator $2 --delegator $3
# - --from-validator $1 --to-validator $2 --delegator $3 --tokens $4
# - --from-validator $1 --to-validator $2 --delegator $3 --all
# - --from-validator $1 --to-validator $2 --delegator $3 --compound
# - --from-validator $1 --to-validator $2 --delegator $3 --tokens $4 --all
# - --from-validator $1 --to-validator $2 --delegator $3 --tokens $4 --compound
# - --from-validator $1 --to-validator $2 --delegator $3 --all --compound
# - --from-validator $1 --to-validator $2 --delegator $3 --tokens $4 --all --compound
# Args:
# - $1 host
# - $2 tx
function exec_redelegate(){
  # prepare tx args
  from_validator=${validator_address[$(expr $RANDOM % ${#validator_address[@]})]}
  to_validator=${validator_address[$(expr $RANDOM % ${#validator_address[@]})]}
  delegator=${delegator_account[$(expr $RANDOM % ${#delegator_account[@]})]}
  tokens=$(expr $RANDOM % 10000 + 1)

  # build tx args
  type="type_"$(expr $RANDOM % 8)
  case $type in
    "type_0")
      tx_args="--from-validator $from_validator --to-validator $to_validator --delegator $delegator"
      ;;
    "type_1")
      tx_args="--from-validator $from_validator --to-validator $to_validator --delegator $delegator --tokens $tokens"
      ;;
    "type_2")
      tx_args="--from-validator $from_validator --to-validator $to_validator --delegator $delegator --all"
      ;;
    "type_3")
      tx_args="--from-validator $from_validator --to-validator $to_validator --delegator $delegator --compound"
      ;;
    "type_4")
      tx_args="--from-validator $from_validator --to-validator $to_validator --delegator $delegator --tokens $tokens --all"
      ;;
    "type_5")
      tx_args="--from-validator $from_validator --to-validator $to_validator --delegator $delegator --tokens $tokens --compound"
      ;;
    "type_6")
      tx_args="--from-validator $from_validator --to-validator $to_validator --delegator $delegator --all --compound"
      ;;
    "type_7")
      tx_args="--from-validator $from_validator --to-validator $to_validator --delegator $delegator --tokens $tokens --all --compound"
      ;;
  esac

  # build tx cmd and execute
  run_tx_cmd_and_update_metrics $1 "$ssh_qoscli tx $2 $tx_args --indent" "$ssh_qos_pwd"
}
