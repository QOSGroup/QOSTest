#!/bin/bash

source ~/qos/testnet/exec.sh
source ~/qos/test/utils.sh

# Array of Avaliable Txs
declare -a avaliable_txs

# 打印可用交易列表
# $1 output file
function print_avaliable_txs(){
  if [ "$enable_print_avaliable_txs" == "true" ];then
    printf "\n==== 可用交易列表 ====\n\n" | tee -a $1
    print_array "$(echo ${avaliable_txs[@]})" | tee -a $1
  fi
}

# 更新可用交易列表
# $1 print-on/off
# $2 output file
function update_avaliable_txs(){
  # clear old array
  unset accounts

  # update avaliable txs
  cmd_output="$(run_local_qoscli 'tx -h' | tr -d '\r')"
  #echo "cmd_output=$cmd_output"
  start_line=$(echo "$cmd_output" | grep -no "^Available Commands:" | grep -o "[0-9]*")
  #echo "start_line=$start_line"
  end_line=$(echo "$cmd_output" | grep -no "^Flags:" | grep -o "[0-9]*")
  #echo "end_line=$end_line"
  head_num=$[$end_line - 1]
  #echo "head_num=$head_num"
  tail_num=$[$end_line - $start_line - 1]
  #echo "tail_num=$tail_num"
  sorted_txs="$(echo "$cmd_output" | head -n $head_num | tail -n $tail_num | awk '{if($1!=""){print $1}}' | sort -u)"
  #echo "sorted_txs=$sorted_txs"
  avaliable_txs=($sorted_txs)
    
  # print
  if [ "$1" == "print-on" ];then
    print_avaliable_txs $2
  fi
}

