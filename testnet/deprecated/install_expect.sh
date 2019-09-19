#!/bin/bash

source ~/qos/testnet/config.sh
source ~/qos/testnet/exec.sh

function install_expect(){
  printf "\n================ Install Expect ================\n"
  cmd_flag="yum list installed | grep 'expect' | wc -l"
  cmd_main="sudo yum install -y expect"
  for host in ${ssh_hosts[@]}
  do
    printf "\n== Ensure service 'expect' is installed on host: %s \n" $host
    flag=$(run_cmd $host "$cmd_flag")
    if [ $flag == 0 ];then
      # start service
      printf "\n== Installing service 'expect' on host: %s \n" $host
      run_cmd_and_print $host "$cmd_main"
      
      # recheck
      flag=$(run_cmd $host "$cmd_flag")
      if [ $flag == 0 ];then
        printf "\n== Failed to Install service 'expect' on host: %s \n" $host
      elif [ $flag == 1 ];then
        printf "\n== Success to Install service 'expect' on host: %s \n" $host
      fi
    elif [ $flag == 1 ];then
      printf "\n== Servive 'expect' is already installed on host: %s \n" $host
    fi
  done
}
