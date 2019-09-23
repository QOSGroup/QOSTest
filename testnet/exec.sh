#!/bin/bash

source ~/qos/testnet/config.sh

# SSH Connection Example
# sshpass -p qianbao2019 ssh vagrant@192.168.1.224
# sshpass -p admin ssh admin@192.168.2.129 

function get_timestamp(){
  sec_and_ns=$(date '+%s-%N')
  let sec=10#${sec_and_ns%-*}
  let ns=10#${sec_and_ns##*-}
  timestamp=$((sec*1000+ns/1000000))
  echo "$timestamp"
}

function run_local_cmd(){
  echo "$(bash -c "$1" 2>&1)"
}

function run_local_qoscli(){
  echo "$(~/qos/bin/qoscli $1 2>&1)"
}

# $1 host
# $2 cmd
# $3 inputs
function run_remote_cmd(){
  # expect run_cmd_via_ssh.expect <ssh_host> <ssh_usr> <ssh_pwd> <cmd> [inputs]
  ts1=$(get_timestamp)
  expect_script=~/qos/expect/run_cmd_via_ssh.expect
  expect_cmd="expect 2>&1 $expect_script $1 $ssh_usr $ssh_pwd '$2' $3"
  output=$(eval "$expect_cmd")
  ts2=$(get_timestamp)
  delta1=$((ts2-ts1))
  # remove input from output
  uniq_input=$(echo "$3" | awk '{for(i=1;i<=NF;i++){print $i}}' | sort -u | uniq)
  for input in $uniq_input
  do
    output=$(echo "$output" | sed "/^$input\r$/d")
  done
  ts3=$(get_timestamp)
  delta2=$((ts3-ts2))
  # return output
  echo
  echo "--------------------------------"
  echo "Expect命令:"
  echo "$expect_cmd"
  echo "命令执行结果:"
  echo "$output"
  echo "命令执行耗时: $delta1 ms" 
  echo "结果处理耗时: $delta2 ms" 
  echo "--------------------------------" 
}
# run_remote_cmd 192.168.2.128 "~/qos/bin/qoscli tx transfer --senders 'node,100qos;alice,100qos' --receivers 'bob,100qos;charles,100qos' --indent" "12345678 12345678 55556767"


# $1 host
# $2 cmd
function run_cmd(){
  sshpass -p $ssh_pwd ssh $ssh_usr@$1 "$2"
}

# $1 host
# $2 tx_cmd
function run_tx_cmd(){
  cmd="expect ~/qos/expect/run_tx_cmd.expect '$2'"
  run_cmd $1 "$cmd"
}

# $1 host
# $2 key's name
# $3 key's private key
function import_key(){
  cmd="expect ~/qos/expect/import_key.expect $ssh_qoscli $2 $ssh_qos_pwd $3"
  result="$(run_cmd $1 "$cmd")"
  echo "$result"
}

# Function to execute cmd via ssh
# $1 host
# $2 cmd
function run_cmd_and_print(){
  echo -e "\n================================"
  echo "== Execute on: $ssh_usr@$1"
  echo "== Command: "
  echo "$2"
  echo "==------------------------------"
  echo "== Executing... "
  result="$(run_cmd $1 "$2")"
  echo "== Result:"
  echo "$result"
  echo "================================"
}

# $1 host
# $2 tx_cmd
function run_tx_cmd_and_print(){
  echo -e "\n================================"
  echo "== Execute on: $ssh_usr@$1"
  echo "== Tx Command: "
  echo "$2"
  echo "==------------------------------"
  echo "== Expect Command: "
  cmd="expect ~/qos/expect/run_tx_cmd.expect \"$2\""
  echo "$cmd"
  echo "==------------------------------"
  echo "== Executing... "
  result="$(run_cmd $1 "$cmd")"
  echo "==------------------------------"
  echo "== Result:"
  echo "$result"
  echo "================================"
}

# $1 host
# $2 key's name
# $3 key's private key
function import_key_and_print(){
  echo "================================"
  echo "== Execute on: $ssh_usr@$1"
  echo "==------------------------------"
  echo "== Key's name: "
  echo "$2"
  echo "== Key's private_key: "
  echo "$3"
  echo "==------------------------------"
  echo "== Expect Command: "
  cmd="expect ~/qos/expect/import_key.expect $ssh_qoscli $2 $ssh_qos_pwd $3"
  echo "$cmd"
  echo "==------------------------------"
  echo "== Executing... "
  result="$(run_cmd $1 "$cmd")"
  echo "==------------------------------"
  echo "== Result:"
  echo "$result"
  echo "================================"
}
