#!/bin/bash

source ~/qos/test/metrics.sh

# Function exec submit-proposal
# - --proposal-type Text --proposer $1 --deposit $2 --title $3 --description $4
# Function exec submit-proposal
# - --proposal-type TaxUsage --proposer $1 --deposit $2 --title $3 --description $4
# - --proposal-type TaxUsage --proposer $1 --deposit $2 --title $3 --description $4 --dest-address $5
# - --proposal-type TaxUsage --proposer $1 --deposit $2 --title $3 --description $4 --percent $6
# - --proposal-type TaxUsage --proposer $1 --deposit $2 --title $3 --description $4 --dest-address $5 --percent $6
# Function exec submit-proposal
# - --proposal-type ParameterChange --proposer $1 --deposit $2 --title $3 --description $4
# - --proposal-type ParameterChange --proposer $1 --deposit $2 --title $3 --description $4 --params $5
# Args:
# - $1 host
# - $2 tx
function exec_submit_proposal(){
  # prepare tx args
  proposer=${accounts[$(expr $RANDOM % ${#accounts[@]})]}
  deposit=$(expr $RANDOM % 100 + 1)
  title="Proposal-title-by-$proposer"
  description="Proposal-description-by-$proposer"
  dest_address=${accounts[$(expr $RANDOM % ${#accounts[@]})]}
  percent="0.$(expr $RANDOM % 100 + 1)"
  params="gov:min_deposit:$(expr $RANDOM % 100 + 1)"

  # build tx args
  type="type_"$(expr $RANDOM % 8)
  case $type in
    "type_0")
      tx_args="--proposal-type Text --proposer $proposer --deposit $deposit --title $title --description $description"
      ;;
    "type_1")
      tx_args="--proposal-type TaxUsage --proposer $proposer --deposit $deposit --title $title --description $description"
      ;;
    "type_2")
      tx_args="--proposal-type TaxUsage --proposer $proposer --deposit $deposit --title $title --description $description --dest-address $dest_address"
      ;;
    "type_3")
      tx_args="--proposal-type TaxUsage --proposer $proposer --deposit $deposit --title $title --description $description --percent $percent"
      ;;
    "type_4")
      tx_args="--proposal-type TaxUsage --proposer $proposer --deposit $deposit --title $title --description $description --dest-address $dest_address --percent $percent"
      ;;
    "type_5")
      tx_args="--proposal-type ParameterChange --proposer $proposer --deposit $deposit --title $title --description $description"
      ;;
    "type_6")
      tx_args="--proposal-type ParameterChange --proposer $proposer --deposit $deposit --title $title --description $description --params $params"
      ;;
  esac

  # build tx cmd and execute
  run_tx_cmd_and_update_metrics $1 "$ssh_qoscli tx $2 $tx_args --indent" "$ssh_qos_pwd"
}
