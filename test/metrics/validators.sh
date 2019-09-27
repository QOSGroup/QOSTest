#!/bin/bash

source ~/qos/testnet/exec.sh
source ~/qos/test/utils.sh

# 验证人节点地址
declare -a validator_address

function print_validator_address(){
  if [ "$enable_print_validator_address" == "true" ];then
    printf "\n==== 验证人地址列表 ====\n\n" | tee -a $1
    print_array "$(echo ${validator_address[@]})" | tee -a $1
  fi
}

# 验证人节点基础信息
declare -A validator_owner
declare -A validator_bond_tokens
declare -A validator_bond_height
declare -A validator_min_period

# 打印验证人节点基础信息
# $1 output file
function print_validator_brief(){
  if [ "$enable_print_validator_brief" == "true" ];then
    printf "\n==== 验证人节点基础信息 ====\n\n" | tee -a $1
    if [ ${#validator_address[@]} == 0 ];then
      printf "Empty\n"
    else
      printf "| Index | Validator Address        | Owner Address            | Bond Tokens          | Bond Height          | Min Period           |\n" | tee -a $1
      printf "| ----: | :----------------------: | :----------------------: | -------------------: | -------------------: | -------------------: |\n" | tee -a $1
      index=0
      for validator in ${validator_address[@]}
      do
        owner="${validator_owner[$validator]}"
        bondTokens="${validator_bond_tokens[$validator]}"
        bondHeight="${validator_bond_height[$validator]}"
        minPeriod="${validator_min_period[$validator]}"
        printf "| %5s | %24s | %24s | %20s | %20s | %20s |\n" $index "${validator:0-24}" "${owner:0-24}" "$bondTokens" "$bondHeight" "$minPeriod" | tee -a $1
        let index++
      done
    fi
  fi
}

# 验证人节点描述
declare -A validator_description_moniker
declare -A validator_description_logo
declare -A validator_description_website
declare -A validator_description_details

# 打印验证人节点描述信息
# $1 output file
function print_validator_description(){
  if [ "$enable_print_validator_description" == "true" ];then
    printf "\n==== 验证人节点描述信息 ====\n\n" | tee -a $1
    if [ ${#validator_address[@]} == 0 ];then
      printf "Empty\n"
    else
      printf "| Index | Validator Address        | Moniker               | Logo                  | Website               | Details               |\n" | tee -a $1
      printf "| ----: | :----------------------: | :-------------------: | --------------------: | --------------------: | --------------------: |\n" | tee -a $1
      index=0
      for validator in ${validator_address[@]}
      do
        moniker="${validator_description_moniker[$validator]}"
        logo="${validator_description_logo[$validator]}"
        website="${validator_description_website[$validator]}"
        details="${validator_description_details[$validator]}"
        # cut to fix
        if [ "${#validator}" -gt "24" ];then
          validator=${validator:0-24}
        fi
        if [ "${#moniker}" -gt "21" ];then
          moniker=${moniker:0-21}
        elif [ "${#moniker}" == "0" ];then
          moniker="None"
        fi
        if [ "${#logo}" -gt "21" ];then
          logo=${logo:0-21}
        elif [ "${#logo}" == "0" ];then
          logo="None"
        fi
        if [ "${#website}" -gt "21" ];then
          website=${website:0-21}
        elif [ "${#website}" == "0" ];then
          website="None"
        fi
        if [ "${#details}" -gt "21" ];then
          details=${details:0-21}
        elif [ "${#details}" == "0" ];then
          details="None"
        fi
        # print
        printf "| %5s | %24s | %21s | %21s | %21s | %21s |\n" $index "$validator" "$moniker" "$logo" "$website" "$details" | tee -a $1
        let index++
      done
    fi
  fi
}

# 验证人节点佣金比例
declare -A validator_commission_rate
declare -A validator_commission_max_rate
declare -A validator_commission_max_change_rate
declare -A validator_commission_update_time

# 打印验证人节点佣金比例信息
# $1 output file
function print_validator_commission(){
  if [ "$enable_print_validator_commission" == "true" ];then
    printf "\n==== 验证人节点佣金比例信息 ====\n\n" | tee -a $1
    if [ ${#validator_address[@]} == 0 ];then
      printf "Empty\n"
    else
      printf "| Index | Validator Address        | Update Time           | Rate                  | Max Rate              | Max Change Rate       |\n" | tee -a $1
      printf "| ----: | :----------------------: | :-------------------: | --------------------: | --------------------: | --------------------: |\n" | tee -a $1
      index=0
      for validator in ${validator_address[@]}
      do
        rate="${validator_commission_rate[$validator]}"
        max_rate="${validator_commission_max_rate[$validator]}"
        max_change_rate="${validator_commission_max_change_rate[$validator]}"
        update_time="${validator_commission_update_time[$validator]}"
        # cut to fix
        if [ "${#validator}" -gt "24" ];then
          validator=${validator:0-24}
        fi
        # print
        printf "| %5s | %24s | %21s | %21s | %21s | %21s |\n" $index "$validator" "$update_time" "$rate" "$max_rate" "$max_change_rate" | tee -a $1
        let index++
      done
    fi
  fi
}

# 验证人节点状态信息
declare -A validator_status
declare -A validator_inactive_height
declare -A validator_inactive_time
declare -A validator_inactive_description

# 打印验证人节点状态信息
# $1 output file
function print_validator_status(){
  if [ "$enable_print_validator_status" == "true" ];then
    printf "\n==== 验证人节点状态信息 ====\n\n" | tee -a $1
    if [ ${#validator_address[@]} == 0 ];then
      printf "Empty\n"
    else
      printf "| Index | Validator Address        | Status    | Inactive Height      | Inactive Time        | Inactive Description                |\n" | tee -a $1
      printf "| ----: | :----------------------: | :-------: | -------------------: | -------------------: | ----------------------------------: |\n" | tee -a $1
      index=0
      for validator in ${validator_address[@]}
      do
        status="${validator_status[$validator]}"
        inactive_height="${validator_inactive_height[$validator]}"
        inactive_time="${validator_inactive_time[$validator]}"
        inactive_desc="${validator_inactive_description[$validator]}"
        # cut to fix
        if [ "${#validator}" -gt "24" ];then
          validator=${validator:0-24}
        fi
        if [ "${#inactive_desc}" -gt "35" ];then
          inactive_desc=${inactive_desc:0-35}
        elif [ "${#inactive_desc}" == "0" ];then
          inactive_desc="None"
        fi
        # print
        printf "| %5s | %24s | %9s | %20s | %20s | %35s |\n" $index "$validator" "$status" "$inactive_height" "$inactive_time" "$inactive_desc" | tee -a $1
        let index++
      done
    fi
  fi
}

# 打印验证人节点信息
# $1 output file
function print_validators(){
  print_validator_address $1
  print_validator_brief $1
  print_validator_description $1
  print_validator_commission $1
  print_validator_status $1
}

# 清空旧数据
function clear_validators(){
  unset validator_address
  
  for key in ${!validator_owner[@]}
  do
    unset validator_owner[$key]
  done
  
  for key in ${!validator_status[@]}
  do
    unset validator_status[$key]
  done
  
  for key in ${!validator_min_period[@]}
  do
    unset validator_min_period[$key]
  done
  
  for key in ${!validator_bond_tokens[@]}
  do
    unset validator_bond_tokens[$key]
  done
  
  for key in ${!validator_bond_height[@]}
  do
    unset validator_bond_height[$key]
  done

  for key in ${!validator_description_moniker[@]}
  do
    unset validator_description_moniker[$key]
  done
  
  for key in ${!validator_description_logo[@]}
  do
    unset validator_description_logo[$key]
  done
  
  for key in ${!validator_description_website[@]}
  do
    unset validator_description_website[$key]
  done
  
  for key in ${!validator_description_details[@]}
  do
    unset validator_description_details[$key]
  done

  for key in ${!validator_commission_rate[@]}
  do
    unset validator_commission_rate[$key]
  done
  
  for key in ${!validator_commission_max_rate[@]}
  do
    unset validator_commission_max_rate[$key]
  done
  
  for key in ${!validator_commission_max_change_rate[@]}
  do
    unset validator_commission_max_change_rate[$key]
  done

  for key in ${!validator_commission_update_time[@]}
  do
    unset validator_commission_update_time[$key]
  done

  for key in ${!validator_inactive_description[@]}
  do
    unset validator_inactive_description[$key]
  done
  
  for key in ${!validator_inactive_time[@]}
  do
    unset validator_inactive_time[$key]
  done
  
  for key in ${!validator_inactive_height[@]}
  do
    unset validator_inactive_height[$key]
  done
}

# Update metrics
function update_validators(){
  # clear old data
  clear_validators
  
  # get command output
  cmd_output="$(run_local_qoscli 'query validators --indent' | tr -d '\r')"

  # parse array
  validator_address=($(echo "$cmd_output" | grep '"validator"' | grep -Po "qosval[0-9a-zA-Z]*"))
  ownerArr=($(echo "$cmd_output" | grep '"owner"' | grep -Po "qosacc[0-9a-zA-Z]*"))
  bondTokensArr=($(echo "$cmd_output" | grep '"bondTokens"' | grep -Po "[0-9]*"))
  monikerArr=($(echo "$cmd_output" | grep '"moniker"' | awk -F '":' '{print $2}' | awk -F '"' '{print $2}'))
  logoArr=($(echo "$cmd_output" | grep '"logo"' | awk -F '":' '{print $2}' | awk -F '"' '{print $2}'))
  websiteArr=($(echo "$cmd_output" | grep '"website"' | awk -F '":' '{print $2}' | awk -F '"' '{print $2}'))
  detailsArr=($(echo "$cmd_output" | grep '"details"' | awk -F '":' '{print $2}' | awk -F '"' '{print $2}'))
  rateArr=($(echo "$cmd_output" | grep '"rate"' | awk -F '":' '{print $2}' | awk -F '"' '{print $2}'))
  maxRateArr=($(echo "$cmd_output" | grep '"max_rate"' | awk -F '":' '{print $2}' | awk -F '"' '{print $2}'))
  maxChangeRateArr=($(echo "$cmd_output" | grep '"max_change_rate"' | awk -F '":' '{print $2}' | awk -F '"' '{print $2}'))
  updateTimeArr=($(echo "$cmd_output" | grep '"update_time"' | awk -F '":' '{print $2}' | awk -F '"' '{print $2}'))
  statusArr=($(echo "$cmd_output" | grep '"status"' | awk -F '":' '{print $2}' | awk -F '"' '{print $2}'))
  InactiveDescArr=($(echo "$cmd_output" | grep '"InactiveDesc"' | awk -F '":' '{print $2}' | awk -F '"' '{print $2}'))
  inactiveTimeArr=($(echo "$cmd_output" | grep '"inactiveTime"' | awk -F '":' '{print $2}' | awk -F '"' '{print $2}'))
  inactiveHeightArr=($(echo "$cmd_output" | grep '"inactiveHeight"' | awk -F '":' '{print $2}' | awk -F '"' '{print $2}'))
  minPeriodArr=($(echo "$cmd_output" | grep '"minPeriod"' | awk -F '":' '{print $2}' | awk -F '"' '{print $2}'))
  bondHeightArr=($(echo "$cmd_output" | grep '"bondHeight"' | awk -F '":' '{print $2}' | awk -F '"' '{print $2}'))
  
  # get validator num
  validator_num=${#validator_address[@]}

  # for all validators
  validator_index=0
  while [ $validator_index -lt $validator_num ]
  do
    address=${validator_address[$validator_index]}
    
    # 验证人节点基础信息
    validator_owner[$address]="${ownerArr[$validator_index]}"
    validator_bond_tokens[$address]="${bondTokensArr[$validator_index]}"
    validator_bond_height[$address]="${bondHeightArr[$validator_index]}"
    validator_min_period[$address]="${minPeriodArr[$validator_index]}"

    # 验证人节点描述
    validator_description_moniker[$address]="${monikerArr[$validator_index]}"
    validator_description_logo[$address]="${logoArr[$validator_index]}"
    validator_description_website[$address]="${websiteArr[$validator_index]}"
    validator_description_details[$address]="${detailsArr[$validator_index]}"

    # 验证人节点佣金比例
    validator_commission_rate[$address]="${rateArr[$validator_index]}"
    validator_commission_max_rate[$address]="${maxRateArr[$validator_index]}"
    validator_commission_max_change_rate[$address]="${maxChangeRateArr[$validator_index]}"
    validator_commission_update_time[$address]="${updateTimeArr[$validator_index]}"

    # 验证人节点状态信息
    validator_status[$address]="${statusArr[$validator_index]}"
    validator_inactive_height[$address]="${inactiveHeightArr[$validator_index]}"
    validator_inactive_time[$address]="${inactiveTimeArr[$validator_index]}"
    validator_inactive_description[$address]="${InactiveDescArr[$validator_index]}"

    let validator_index++
  done
  
  # print
  if [ "$1" == "print-on" ];then
    print_validators
  fi
}

