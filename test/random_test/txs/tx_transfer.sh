#!/bin/bash

source ~/qos/test/metrics.sh

function build_trans_items(){
  trans_account_count="$(expr $RANDOM % 2 + 1)"
  trans_items=""
  if [ $trans_account_count == "1" ]; then
    trans_account=${accounts[$(expr $RANDOM % ${#accounts[@]})]}
    coins="$1QOS"
    trans_items="$trans_account,$coins"
  elif [ $trans_account_count == "2" ]; then
    trans_account_a=${accounts[$(expr $RANDOM % ${#accounts[@]})]}
    trans_account_b=${accounts[$(expr $RANDOM % ${#accounts[@]})]}
    amount_a="$(expr $RANDOM % $1 + 1)"
    amount_b="$(expr $1 - $amount_a)"
    coins_a=$amount_a"QOS"
    coins_b=$amount_b"QOS"
    trans_items="$trans_account_a,$coins_a;$trans_account_b,$coins_b"
  fi
  echo "$trans_items"
}

# Function exec transfer
# - --senders $1 --receivers $2
# Args:
# - $1 host
# - $2 tx
function exec_transfer(){
  # prepare tx args
  amount_senders=$(expr $RANDOM % 100 + 1)
  senders="$(build_trans_items $amount_senders)"
  amount_receivers=$(expr $amount_senders + $RANDOM % 2)
  receivers="$(build_trans_items $amount_receivers)"

  # build tx args
  tx_args="--senders \"$senders\" --receivers \"$receivers\""

  # build tx cmd and execute
  run_tx_cmd_and_update_metrics $1 "$ssh_qoscli tx $2 $tx_args --indent" "$ssh_qos_pwd $ssh_qos_pwd"
}
