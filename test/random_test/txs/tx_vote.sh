#!/bin/bash

source ~/qos/test/metrics.sh

# Function exec vote `Yes`,`Abstain`,`No`,`NoWithVeto`
# - --proposal-id $1 --voter $2 --option Yes
# - --proposal-id $1 --voter $2 --option Abstain
# - --proposal-id $1 --voter $2 --option No
# - --proposal-id $1 --voter $2 --option NoWithVeto
# Args:
# - $1 host
# - $2 tx
function exec_vote(){
  # prepare tx args
  proposal_id=$(expr $RANDOM % $latest_proposal_id + 1)
  voter=${accounts[$(expr $RANDOM % ${#accounts[@]})]}

  # build tx args
  type="type_"$(expr $RANDOM % 4)
  case $type in
    "type_0")
      tx_args="--proposal-id $proposal_id --voter $voter --option Yes"
      ;;
    "type_1")
      tx_args="--proposal-id $proposal_id --voter $voter --option Abstain"
      ;;
    "type_2")
      tx_args="--proposal-id $proposal_id --voter $voter --option No"
      ;;
    "type_3")
      tx_args="--proposal-id $proposal_id --voter $voter --option NoWithVeto"
      ;;
  esac

  # build tx cmd and execute
  run_tx_cmd_and_update_metrics $1 "$ssh_qoscli tx $2 $tx_args --indent" "$ssh_qos_pwd"
}
