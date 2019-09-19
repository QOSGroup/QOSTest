#!/bin/bash

source ~/qos/testnet/exec.sh
source ~/qos/test/utils.sh
source ~/qos/test/metrics/validators.sh

# Array of delegator's account addresses
declare -a delegator_account

# Array of delegation key(Style: delegator_on_validator)
declare -a delegation_key

# Map of delegation income info to delegation key
declare -A first_delegate_height_map
declare -A bond_token_map
declare -A is_compound_map
declare -A previous_validator_period_map
declare -A last_income_calHeight_map
declare -A last_income_calFees_map
declare -A earns_starting_height_map
declare -A historical_rewards_map

# 清空旧数据
function clear_delegations(){
  unset delegator_account
  unset delegation_key
  
  for key in ${!first_delegate_height_map[@]}
  do
    unset first_delegate_height_map[$key]
  done
  
  for key in ${!bond_token_map[@]}
  do
    unset bond_token_map[$key]
  done
  
  for key in ${!is_compound_map[@]}
  do
    unset is_compound_map[$key]
  done
  
  for key in ${!previous_validator_period_map[@]}
  do
    unset previous_validator_period_map[$key]
  done
  
  for key in ${!last_income_calHeight_map[@]}
  do
    unset last_income_calHeight_map[$key]
  done
  
  for key in ${!last_income_calFees_map[@]}
  do
    unset last_income_calFees_map[$key]
  done
  
  for key in ${!earns_starting_height_map[@]}
  do
    unset earns_starting_height_map[$key]
  done
  
  for key in ${!historical_rewards_map[@]}
  do
    unset historical_rewards_map[$key]
  done
}

# 打印委托人账户地址列表
# $1 output file
function print_delegator_account(){
  printf "\n==== 委托人账户地址列表 ====\n\n" | tee -a $1
  print_array "$(echo ${delegator_account[@]})" | tee -a $1
}

# 打印委托主键列表
# $1 output file
function print_delegation_key(){
  printf "\n==== 委托主键列表 ====\n\n" | tee -a $1
  print_array "$(echo ${delegation_key[@]})" | tee -a $1
}

# 打印委托信息列表
# $1 output file
function print_delegation_info(){
  printf "\n==== 委托信息列表 ====\n\n" | tee -a $1
  if [ ${#delegation_key[@]} == 0 ];then
    printf "Empty\n"
  else
    printf "| Index | Validator                    | Delegator                    | First Delegate Height | Bond Token           | Is Compound |\n" | tee -a $1
    printf "| ----: | :--------------------------: | :--------------------------: | --------------------: | -------------------: | ----------: |\n" | tee -a $1
    index=0
    for key in ${delegation_key[@]}
    do
      val=$(echo $key | awk -F "_H_" '{print $1}')
      del=$(echo $key | awk -F "_H_" '{print $2}')
      printf "| %5s | ..%26s | ..%26s | %21s | %20s | %11s |\n" $index ${val:0-26} ${del:0-26} ${first_delegate_height_map[$key]} ${bond_token_map[$key]} ${is_compound_map[$key]} | tee -a $1
      let index++
    done
  fi
}

# 打印上期委托收益列表(已发放)
# $1 output file
function print_delegation_last_income(){
  printf "\n==== 上期委托收益列表(已发放) ====\n\n" | tee -a $1
  if [ ${#delegation_key[@]} == 0 ];then
    printf "Empty\n"
  else
    printf "| Index | Validator                | Delegator                | Validator Period     | Last Income Height   | Last Income Amount   |\n" | tee -a $1
    printf "| ----: | :----------------------: | :----------------------: | -------------------: | -------------------: | -------------------: |\n" | tee -a $1
    index=0
    for key in ${delegation_key[@]}
    do
      val=$(echo $key | awk -F "_H_" '{print $1}')
      del=$(echo $key | awk -F "_H_" '{print $2}')
      printf "| %5s | ..%22s | ..%22s | %20s | %20s | %20s |\n" $index ${val:0-22} ${del:0-22} ${previous_validator_period_map[$key]} ${last_income_calHeight_map[$key]} ${last_income_calFees_map[$key]} | tee -a $1
      let index++
    done
  fi
}

# 打印本期委托收益列表(待发放)
# $1 output file
function print_delegation_current_income(){
  printf "\n==== 本期委托收益列表(待发放) ====\n\n" | tee -a $1
  if [ ${#delegation_key[@]} == 0 ];then
    printf "Empty\n"
  else
    printf "| Index | Validator                           | Delegator                           | Earns Starting Height | Historical Rewards   |\n" | tee -a $1
    printf "| ----: | :---------------------------------: | :---------------------------------: | --------------------: | -------------------: |\n" | tee -a $1
    index=0
    for key in ${delegation_key[@]}
    do
      val=$(echo $key | awk -F "_H_" '{print $1}')
      del=$(echo $key | awk -F "_H_" '{print $2}')
      printf "| %5s | ..%33s | ..%33s | %21s | %20s |\n" $index ${val:0-33} ${del:0-33} ${earns_starting_height_map[$key]} ${historical_rewards_map[$key]} | tee -a $1
      let index++
    done
  fi
}

# 打印委托相关数据
# $1 output file
function print_delegations(){
  print_delegator_account
  print_delegation_key
  print_delegation_info
  print_delegation_last_income
  print_delegation_current_income
}

# 更新委托相关数据
# $1 print-on/off
# $2 output file
function update_delegations(){
  # clear old array and map
  clear_delegations
  
  # for all validators, query delegations on it
  delegation_total_index=0
  for validator in ${validator_address[@]}
  do
    # get command output
    cmd_output=$(run_local_qoscli "query delegations-to $validator --indent" | tr -d '\r')
    
    # parse delegators, amounts and compound of delegations to this validator
    delegators=($(echo "$cmd_output" | grep "delegator_address" | grep -Po "qosacc[0-9a-zA-Z]*"))
    amounts=($(echo "$cmd_output" | grep "delegate_amount" | grep -Po "[0-9]*"))
    compounds=($(echo "$cmd_output" | grep "is_compound" | grep -Po "false|true"))
    
    # fill in array delegator_account
    delegator_account=(${delegator_account[@]} ${delegators[@]})
    
    # for all delegations on this validator
    delegation_num=${#delegators[@]}
    delegation_index=0
    while [ $delegation_index -lt $delegation_num ]
    do
      # prepare delegator, amount, and compound
      delegator=${delegators[$delegation_index]}
      amount=${amounts[$delegation_index]}
      compound=${compounds[$delegation_index]}

      # query delegation income info
      income_info=$(run_local_qoscli "query delegator-income --validator $validator --delegator $delegator --indent")
      
      # parse info
      first_delegate_height=$(echo "$income_info" | grep "first_delegate_height" | grep -Po "[0-9]*")
      bond_token=$(echo "$income_info" | grep "bond_token" | grep -Po "[0-9]*")
      previous_validator_period=$(echo "$income_info" | grep "previous_validator_period" | grep -Po "[0-9]*")
      last_income_calHeight=$(echo "$income_info" | grep "last_income_calHeight" | grep -Po "[0-9]*")
      last_income_calFees=$(echo "$income_info" | grep "last_income_calFees" | grep -Po "[0-9]*")
      earns_starting_height=$(echo "$income_info" | grep "earns_starting_height" | grep -Po "[0-9]*")
      historical_rewards=$(echo "$income_info" | grep "historical_rewards" | grep -Po "[0-9]*")
      
      # generate delegation key
      key=$validator"_H_"$delegator
      delegation_key[$delegation_total_index]=$key
      
      # fill in maps
      first_delegate_height_map[$key]=$first_delegate_height
      bond_token_map[$key]=$bond_token
      is_compound_map[$key]=$compound
      previous_validator_period_map[$key]=$previous_validator_period
      last_income_calHeight_map[$key]=$last_income_calHeight
      last_income_calFees_map[$key]=$last_income_calFees
      earns_starting_height_map[$key]=$earns_starting_height
      historical_rewards_map[$key]=$historical_rewards
      
      # increase index
      let delegation_index++
      let delegation_total_index++
    done
  done
  
  # print
  if [ "$1" == "print-on" ];then
    print_delegations $2
  fi
}


