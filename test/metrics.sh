#!/bin/bash

source ~/qos/testnet/exec.sh
source ~/qos/test/utils.sh
source ~/qos/test/metrics/avaliable_txs.sh
source ~/qos/test/metrics/guardians.sh
source ~/qos/test/metrics/validators.sh
source ~/qos/test/metrics/delegations.sh
source ~/qos/test/metrics/account_balance.sh
source ~/qos/test/metrics/variables.sh

# 更新所有监控指标
# $1 print-on/off
# $2 output_file
function update_all_metrics(){
  update_avaliable_txs "$1" $2
  update_guardian "$1" $2
  update_validators "$1" $2
  update_delegations "$1" $2
  update_account_balance "$1" $2
  update_variables "$1" $2
}

# 打印所有监控指标
# $1 output_file
function print_all_metrics(){
  print_avaliable_txs $1
  print_guardians $1
  print_validators $1
  print_delegations $1
  print_account_balance $1
  print_variables $1
}

# 在监控下执行交易
# $1 host
# $2 tx_cmd
# $3 tx_cmd_input
# $4 output_file
function run_tx_cmd_and_update_metrics(){
  printf "\n== 交易之前 ==\n" | tee -a $4
  update_all_metrics "print-on" $4

  printf "\n== 执行交易 ==\n" | tee -a $4
  printf "\n$2 \n" | tee -a $4
  result="$(run_remote_cmd $1 "$2" "$3")"

  printf "\n== 原始交易结果 ==\n" | tee -a $4
  printf "\n%s\n" "$result" | tee -a $4
  
  printf "\n== 提取交易哈希 ==\n" | tee -a $4
  tx_hash="$(echo "$result" | grep -Po '"hash": "[0-9A-Z]*"' | grep -o '[0-9A-Z]*')"
  
  if [ -z "$tx_hash" ];then
    printf "\n错误: 未提取到交易哈希\n" | tee -a $4
    printf "\n== 交易失败 ==\n" | tee -a $4
  else
    printf "\n%s\n" "$tx_hash" | tee -a $4
    printf "\n== 查询链上交易记录 ==\n" | tee -a $4
    tx_record=$(run_local_qoscli "query tx $tx_hash --indent")
    printf "\n%s\n" "$tx_record" | tee -a $4
    
    tx_not_found=$(echo "$tx_record" | grep -o "ERROR: Tx: response error: RPC error -32603 - Internal error: Tx ([0-9A-Z]*) not found" | wc -l)
    if [ "$tx_not_found" != "0" ];then
      printf "\n错误: 未查询到链上交易记录\n" | tee -a $4
      printf "\n== 交易失败 ==\n" | tee -a $4
    else
      printf "\n== 交易成功 ==\n" | tee -a $4
      printf "\n== 交易生效过程 ==\n" | tee -a $4
      step=0
      latest_status=$(run_local_qoscli "query status")
      saved_block_height=$(echo $latest_status | grep -o '"latest_block_height":"[0-9]*"' | grep -o '[0-9]*')
      while [ $step != 1 ]
      do
        latest_status=$(run_local_qoscli "query status")
        latest_block_height=$(echo $latest_status | grep -o '"latest_block_height":"[0-9]*"' | grep -o '[0-9]*')
        if [ $latest_block_height != $saved_block_height ];then
          printf "\n到达新块: [%s] ==> [%s]\n" $saved_block_height $latest_block_height | tee -a $4
          saved_block_height=$latest_block_height
          let step++
          update_all_metrics "print-on" $4
        fi
        sleep 0.1s
      done
    fi
  fi
}
