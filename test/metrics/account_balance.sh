#!/bin/bash

source ~/qos/testnet/exec.sh
source ~/qos/test/utils.sh
source ~/qos/test/metrics/guardians.sh
source ~/qos/test/metrics/validators.sh
source ~/qos/test/metrics/delegations.sh

# Map of keystore name to account address
declare -A key_account_map

# Array of all account address
declare -a accounts

# Map of account address to keystore name
declare -A account_key_map

# Map of account address to its qos balance
declare -A account_qos_map

# Map of account address to its qos balance change
declare -A account_qos_diff_map

# Map of account address to its QSC star balance
declare -A account_star_map

# Map of account address to its QSC star balance change
declare -A account_star_diff_map

# 打印本地密钥名称-账户地址映射表
# $1 output_file
function print_key_account_map(){
  printf "\n==== 本地密钥名称-账户地址映射表 ====\n\n" | tee -a $1
  if [ ${#key_account_map[@]} == 0 ];then
    printf "Empty\n"
  else
    printf "| Index | Account Address                               | Key Name                                                                 |\n" | tee -a $1
    printf "| ----: | :-------------------------------------------: | -----------------------------------------------------------------------: |\n" | tee -a $1
    index=0
    for key in $(echo "${!key_account_map[@]}" | tr ' ' '\n' | sort -u)
    do
      printf "| %5s | %45s | %-72s |\n" $index "${key_account_map[$key]}" $key | tee -a $1
      let index++
    done
  fi
}

# 打印用户账户地址列表
# $1 output file
function print_accounts(){
  printf "\n==== 用户账户地址列表 ====\n\n" | tee -a $1
  #print_array "$(echo ${accounts[@]})" | tee -a $1
  if [ ${#accounts[@]} == 0 ];then
    printf "Empty\n"
  else
    printf "| Index | Account Address                               | Key Name                                                                 |\n" | tee -a $1
    printf "| ----: | :-------------------------------------------: | -----------------------------------------------------------------------: |\n" | tee -a $1
    index=0
    for account in ${accounts[@]}
    do
      printf "| %5s | %45s | %-72s |\n" $index $account "${account_key_map[$account]}" | tee -a $1
      let index++
    done
  fi
}

# 打印用户账户余额情况: QOS
# $1 output file
function print_account_qos(){
  printf "\n==== 用户账户余额情况: QOS ====\n\n" | tee -a $1
  if [ ${#accounts[@]} == 0 ];then
    printf "Empty\n"
  else                   
    printf "| Index | Account Address                               | Key Name                   | Balance              | Balance Change       |\n" | tee -a $1
    printf "| ----: | :-------------------------------------------: | -------------------------: | -------------------: | -------------------: |\n" | tee -a $1
    index=0
    for account in ${accounts[@]}
    do
      printf "| %5s | %45s | %26s | %20s | %20s |\n" $index $account "${account_key_map[$account]}" "${account_qos_map[$account]}" "${account_qos_diff_map[$account]}" | tee -a $1
      let index++
    done
  fi
}

# 打印用户账户余额情况: QSC 'star'
# $1 output file
function print_account_star(){
  printf "\n==== 用户账户余额情况: QSC 'star' ====\n\n" | tee -a $1
  if [ ${#accounts[@]} == 0 ];then
    printf "Empty\n"
  else
    printf "| Index | Account Address                               | Key Name                   | Balance              | Balance Change       |\n" | tee -a $1
    printf "| ----: | :-------------------------------------------: | -------------------------: | -------------------: | -------------------: |\n" | tee -a $1
    index=0
    for account in ${accounts[@]}
    do
      printf "| %5s | %45s | %26s | %20s | %20s |\n" $index $account "${account_key_map[$account]}" "${account_star_map[$account]}" "${account_star_diff_map[$account]}" | tee -a $1
      let index++
    done
  fi
}

# 打印用户账户余额情况
# $1 output file
function print_account_balance(){
  print_account_qos $1
  print_account_star $1
}


# 更新用户账户地址-本地密钥名称映射表
# $1 print-on/off
# $2 output file
function update_key_account_map(){
  # clear old map
  for key in ${!key_account_map[@]}
  do
    # echo "clear-key: $key"
    # echo "clear-value: ${key_account_map[$key]}"
    unset key_account_map[$key]
  done
  
  # clear old map
  for key in ${!account_key_map[@]}
  do
    # echo "clear-key: $key"
    # echo "clear-value: ${account_key_map[$key]}"
    unset account_key_map[$key]
  done

  cmd_output="$(run_local_qoscli 'keys list')"
  # echo "cmd_output=$cmd_output"
  
  # parse array
  keys=($(echo "$cmd_output" | awk '{if(NR>1){print $1}}'))
  # echo "keys=${keys[@]}"
  accs=($(echo "$cmd_output" | awk '{if(NR>1){print $3}}'))
  # echo "accs=${accs[@]}"

  
  # get array size
  key_cnt=${#keys[@]}  
  # echo "key_cnt=$key_cnt"
  acc_cnt=${#accs[@]}
  # echo "acc_cnt=$acc_cnt"
    
  # need equal size
  if [ "$key_cnt" != "$acc_cnt" ];then
    printf "Error: account num is not equal to key num"
    exit
  fi
  # echo "OK: account num is equal to key num"
  
  # fill in map
  acc_index=0
  while [ $acc_index -lt $acc_cnt ]
  do
    # echo "acc_index=$acc_index"
    key_account_map["${keys[$acc_index]}"]="${accs[$acc_index]}"
    account_key_map["${accs[$acc_index]}"]="${keys[$acc_index]}"
    let acc_index++
  done
  
  # print
  if [ "$1" == "print-on" ];then
    print_key_account_map $2
  fi
}

# 更新用户账户地址列表
# $1 print-on/off
# $2 output file
function update_account(){
  # clear old array
  unset accounts

  # update accounts
  cmd_output=$(run_local_qoscli "keys list")
  #echo "cmd_output : $cmd_output"
  accounts_from_keystore=($(echo "$cmd_output" | awk '{if(NR>1){print $3}}'))
  #echo "accounts_from_keystore : ${accounts_from_keystore[@]}"
  accounts=(${accounts_from_keystore[@]} ${all_guardian[@]} ${validator_owners[@]} ${delegator_account[@]})
  #echo "accounts : ${accounts[@]}"
  accounts=($(echo "${accounts[@]}" | tr ' ' '\n' | sort -u | uniq))
  
  # print
  if [ "$1" == "print-on" ];then
    print_accounts $2
  fi
}

# 更新用户账户余额情况: QOS
# $1 account
# $2 account_info
function update_account_qos(){
  #echo "update account : $1"
  #echo "account qos (before null2zero) : ${account_qos_map[$1]}"
  account_qos_map[$1]=$(null2zero ${account_qos_map[$1]})
  #echo "account qos (after null2zero) : ${account_qos_map[$1]}"
  account_qos=$(null2zero $(echo $2 | grep -o '"qos":"[0-9]*"' | grep -o '[0-9]*'))
  #echo "new account qos : $account_qos"
  account_qos_diff_map[$1]=$(calc "$account_qos - ${account_qos_map[$1]}")
  #echo "account qos changed : ${account_qos_diff_map[$1]}"
  account_qos_map[$1]=$account_qos
}

# 更新用户账户余额情况: QSC 'star'
# $1 account
# $2 account_info
function update_account_star(){
  account_star_map[$1]=$(null2zero ${account_star_map[$1]})
  account_star=$(null2zero $(echo $2 | grep -o '"coin_name":"star","amount":"[0-9]*"' | grep -o '[0-9]*'))
  account_star_diff_map[$1]=$(calc "$account_star - ${account_star_map[$1]}")
  account_star_map[$1]=$account_star
}

# 更新用户账户余额情况
# $1 print-on/off
# $2 output file
function update_account_balance(){
  # update accounts
  update_key_account_map "$1" $2
  update_account "$1" $2

  # update account balance
  for account in ${accounts[@]}
  do
    account_info=$(run_local_qoscli "query account $account")
    update_account_qos "$account" "$account_info"
    update_account_star "$account" "$account_info"
  done

  # print
  if [ "$1" == "print-on" ];then
    print_account_balance $2
  fi
}



