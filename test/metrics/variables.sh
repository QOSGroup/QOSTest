#!/bin/bash

source ~/qos/testnet/exec.sh
source ~/qos/test/utils.sh

# Variable of latest block height
latest_block_height=0

# Variable of latest block time
latest_block_time="None"

# Variable of latest proposal's id
latest_proposal_id=0

# Variable of community fee
community_fee=0

# Variable of community fee changed from last block to current block
community_fee_change=0


# 更新状态变量情况: 最新块高度和出块时间, 社区费池, 以及提案ID
# $1 print-on/off
function update_variables(){
  # query data
  latest_status=$(run_local_qoscli "query status --indent" | tr -d "\r")
  latest_community_fee_pool=$(run_local_qoscli "query community-fee-pool" | tr -d "\r")
  latest_proposal=$(run_local_qoscli "query proposals --limit 1 --indent" | tr -d "\r")
  params=$(run_local_qoscli "query params --indent" | tr -d "\r")
  
  # parse variable
  latest_block_height=$(echo "$latest_status" | grep "latest_block_height" | grep -Po "[0-9]*")
  latest_block_time=$(echo "$latest_status" | grep "latest_block_time" | awk -F '":' '{print $2}'| awk -F '"' '{print $2}')
  latest_community_fee=$(echo "$latest_community_fee_pool" | sed 's/\"//g')
  if [ "$latest_proposal" != "ERROR: no matching proposals found" ];then
    latest_proposal_id=$(echo $latest_proposal | grep 'proposal_id' | awk '{print $2}' | grep -Po '[0-9]*')
  fi
  
  # do calculate
  community_fee_change=$(calc "$latest_community_fee - $community_fee")
  community_fee=$latest_community_fee
  
  # print
  if [ $1 == "print-on" ];then
    print_variables
  fi
}



# 打印状态变量情况: 最新块高度和出块时间, 社区费池, 以及提案ID
# $1 output_file
function print_variables(){
  if [ "$enable_print_variables" == "true" ];then
    printf "\n==== 最新块高度, 出块时间以及最新提案ID ====\n\n" | tee -a $1
    printf "| Latest Block Height  | Latest Block Time              | Latest Proposal ID   |\n" | tee -a $1
    printf "| -------------------: | :----------------------------: | -------------------: |\n" | tee -a $1
    printf "| %+20s | %+30s | %+20s |\n" $latest_block_height $latest_block_time $latest_proposal_id | tee -a $1

    printf "\n==== 社区费池状态 ====\n\n" | tee -a $1
    printf "| Community Fee        | Community Fee Change |\n" | tee -a $1
    printf "| -------------------: | -------------------: |\n" | tee -a $1
    printf "| %+20s | %+20s |\n" $community_fee $community_fee_change | tee -a $1
  fi
}
