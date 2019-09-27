#!/bin/bash

source ~/qos/testnet/exec.sh
source ~/qos/test/utils.sh

# Array of guardian address
declare -a guardian_address

# Map of guardian description to its address
declare -A guardian_description

# Map of guardian type to its address
declare -A guardian_type

# Map of guardian creator to its address
declare -A guardian_creator

# 清空旧数据
function clear_guardians(){
  unset guardian_address
  
  for key in ${!guardian_description[@]}
  do
    unset guardian_description[$key]
  done
  
  for key in ${!guardian_type[@]}
  do
    unset guardian_type[$key]
  done
  
  for key in ${!guardian_creator[@]}
  do
    unset guardian_creator[$key]
  done
}

# 打印特权用户信息列表
# $1 output file
function print_guardians(){
  if [ "$enable_print_guardians" == "true" ];then
    printf "\n==== 特权用户信息列表 ====\n\n" | tee -a $1
    if [ ${#guardian_address[@]} == 0 ];then
      printf "Empty\n"
    else
      printf "| Index | Guardian Type    | Guardian Address         | Guardian Creator         | Guardian Description                             |\n" | tee -a $1
      printf "| ----: | :--------------: | :----------------------: | :----------------------: | -----------------------------------------------: |\n" | tee -a $1
      index=0
      for address in ${guardian_address[@]}
      do
        type="${guardian_type[$address]}"
        creator="${guardian_creator[$address]}"
        description="${guardian_description[$address]}"
        # cut tail to fit table
        if [ "${#type}" -gt "16" ];then
          type=${type:0-16}
        fi
        if [ "${#address}" -gt "24" ];then
          address=${address:0-24}
        fi
        if [ "${#creator}" -gt "24" ];then
          creator=${creator:0-24}
        elif [ "${#creator}" == "0" ];then
          creator="None"
        fi
        if [ "${#description}" -gt "48" ];then
          description=${description:0-48}
        fi
        # print
        printf "| %5s | %16s | %24s | %24s | %48s |\n" $index "$type" "$address" "$creator" "$description" | tee -a $1
        let index++
      done
    fi
  fi
}

# Update metrics
function update_guardian(){
  # clear old array
  clear_guardians

  # update guardians
  cmd_output="$(run_local_qoscli 'query guardians')"
  #echo "cmd_output=$cmd_output"
  raw_list="$(echo "$cmd_output"| grep -Po "(({.*})(,*))*" | sed 's/},{/}#@#{/g' | awk -F '#@#' '{for(i=1;i<=NF;i++){print $i}}')"
  #echo "raw_list=$raw_list"
  
  # for all lines in raw list
  line_index=0
  guardian_index=0
  total=$(echo "$raw_list" | awk 'END{print NR}')
  #echo "total=$total"
  while [ $line_index -lt $total ]
  do
    let line_index++
    raw_line=$(echo "$raw_list" | awk "NR==$line_index{print}")
    #echo "raw_line[$line_index]=$raw_line"
    
    # parse properties
    description="$(echo "$raw_line" | grep -Po '"description":".*?"' | awk -F ':' '{print $2}' | tr -d '\"')"
    type="$(echo "$raw_line" | grep -Po '"guardian_type":[0-9]*' | awk -F ':' '{print $2}')"
    address="$(echo "$raw_line" | grep -Po '"address":".*?"' | awk -F ':' '{print $2}' | tr -d '\"')"
    creator="$(echo "$raw_line" | grep -Po '"creator":".*?"' | awk -F ':' '{print $2}' | tr -d '\"')"
    
    guardian_address[$guardian_index]="$address"
    guardian_description[$address]="$description"
    guardian_creator[$address]="$creator"
    if [ "$type" == "1" ];then
      guardian_type[$address]="Genesis-Guardian"
    elif [ "$type" == "2" ];then
      guardian_type[$address]="Simple-Guardian"
    else
      guardian_type[$address]="$type"
    fi
    let guardian_index++
  done
  
  # print
  if [ "$1" == "print-on" ];then
    print_guardians
  fi
}

