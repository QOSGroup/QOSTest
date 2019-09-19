#!/bin/bash

#source ~/qos/test/env.sh
source ~/qos/test/metrics.sh
source ~/qos/test/random_test/txs/tx_active_validator.sh
source ~/qos/test/random_test/txs/tx_add_guardian.sh
source ~/qos/test/random_test/txs/tx_cancel_approve.sh
source ~/qos/test/random_test/txs/tx_create_approve.sh
source ~/qos/test/random_test/txs/tx_create_qsc.sh
source ~/qos/test/random_test/txs/tx_create_validator.sh
source ~/qos/test/random_test/txs/tx_decrease_approve.sh
source ~/qos/test/random_test/txs/tx_delegate.sh
source ~/qos/test/random_test/txs/tx_delete_guardian.sh
source ~/qos/test/random_test/txs/tx_deposit.sh
source ~/qos/test/random_test/txs/tx_halt_network.sh
source ~/qos/test/random_test/txs/tx_increase_approve.sh
source ~/qos/test/random_test/txs/tx_init_qcp.sh
source ~/qos/test/random_test/txs/tx_invariant_check.sh
source ~/qos/test/random_test/txs/tx_issue_qsc.sh
source ~/qos/test/random_test/txs/tx_modify_compound.sh
source ~/qos/test/random_test/txs/tx_modify_validator.sh
source ~/qos/test/random_test/txs/tx_redelegate.sh
source ~/qos/test/random_test/txs/tx_revoke_validator.sh
source ~/qos/test/random_test/txs/tx_submit_proposal.sh
source ~/qos/test/random_test/txs/tx_transfer.sh
source ~/qos/test/random_test/txs/tx_unbond.sh
source ~/qos/test/random_test/txs/tx_use_approve.sh
source ~/qos/test/random_test/txs/tx_vote.sh

# Function exec_rand_tx
# - get random tx from txs by index.
# - execute tx
# Args:
# - $1=host
# - $2=tx
function exec_rand_tx(){
  case $2 in
    "active-validator")
      exec_active_validator $1 $2
      ;;
    "add-guardian")
      exec_add_guardian $1 $2
      ;;
    "cancel-approve")
      exec_cancel_approve $1 $2
      ;;
    "create-approve")
      exec_create_approve $1 $2
      ;;
    "create-qsc")
      exec_create_qsc $1 $2
      ;;
    "create-validator")
      exec_create_validator $1 $2
      ;;
    "decrease-approve")
      exec_decrease_approve $1 $2
      ;;
    "delegate")
      exec_delegate $1 $2
      ;;
    "delete-guardian")
      exec_delete_guardian $1 $2
      ;;
    "deposit")
      exec_deposit $1 $2
      ;;
    "halt-network")
      exec_halt_network $1 $2
      ;;
    "increase-approve")
      exec_increase_approve $1 $2
      ;;
    "init-qcp")
      exec_init_qcp $1 $2
      ;;
    "invariant-check")
      exec_invariant_check $1 $2
      ;;
    "issue-qsc")
      exec_issue_qsc $1 $2
      ;;
    "modify-compound")
      exec_modify_compound $1 $2
      ;;
    "modify-validator")
      exec_modify_validator $1 $2
      ;;
    "redelegate")
      exec_redelegate $1 $2
      ;;
    "revoke-validator")
      exec_revoke_validator $1 $2
      ;;
    "submit-proposal")
      exec_submit_proposal $1 $2
      ;;
    "transfer")
      exec_transfer $1 $2
      ;;
    "unbond")
      exec_unbond $1 $2
      ;;
    "use-approve")
      exec_use_approve $1 $2
      ;;
    "vote")
      exec_vote $1 $2
      ;;
  esac
}


function random_test(){
  printf "\n================ Begin Random Test ================\n"
  # ensure output folder exist
  dir_name=$(printf "%s_test_%s" "$(date '+%Y%m%d_%H%M%S')" $1)
  dir=~/qos/test/random_test/output/$dir_name
  mkdir -p $dir
  printf "\n== Output Folder: $dir \n"

  # begin test
  round_target=$1
  round_index=1  
  width=${#round_target}
  while [[ $round_index -le $round_target ]]
  do
    # get random tx
    tx_index=$(expr $RANDOM % ${#avaliable_txs[@]})
    tx=${avaliable_txs[$tx_index]}
    #tx="active-validator"
    #tx="transfer"
    
    # get random host
    host_index=$(expr $RANDOM % ${#ssh_hosts[@]})
    host=${ssh_hosts[$host_index]}
  
    # generate file name
    file_name=$(printf "[%0${#2}d_of_%0${#2}d]%s.txt" $round_index $round_target $tx)
    output=$dir/$file_name

    # execute tx on host
    hint=$(printf "%s [ %0${#2}d/%0${#2}d ][ Host: %s ] Execute TX: %s \n" "$(date '+%Y-%m-%d %H:%M:%S')" $round_index $round_target $host $tx)
    echo "$hint"
    echo "$hint" >> $output
    exec_rand_tx $host $tx >> $output

    # next loop
    let round_index++
  done
}
