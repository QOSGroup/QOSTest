#!/bin/bash

source ~/qos/testnet/config.sh
source ~/qos/testnet/exec.sh

function redeploy(){
  printf "\n================ Redeploy QOS Testnet ================\n"
  local_ip="$(ifconfig -a |grep inet |grep -v inet6 |grep -v 127 |head -n 1 |awk '{print $2}')"
  
  # step 1.stop qosd service at hosts
  printf "\n==== step 1.stop qosd service at hosts \n"
  for host in ${ssh_hosts[@]}
  do
    printf "\n== Host: %s \n" $host
    run_cmd $host "bash ~/qos/stop_qosd.sh"
  done
  
  # step 2.init master node at local
  printf "\n==== step 2.init master node at local \n"
  bash ~/qos/init/init_master.sh
  
  # step 3.upload genesis.json and init_slave.sh to hosts
  printf "\n==== step 3.upload genesis.json and init_slave.sh to hosts \n"
  local_genesis="~/qos/init/genesis.json"
  remote_genesis="~/qos/init/genesis.json"
  local_init_slave="~/qos/init/init_slave.sh"
  remote_init_slave="~/qos/init/init_slave.sh"
  for host in ${ssh_hosts[@]}
  do
    printf "\n== Upload 'genesis.json' to host: %s \n" $host
    expect $uploader $host $ssh_usr $ssh_pwd $local_genesis $remote_genesis
    printf "\n== Upload 'init_slave.sh' to host: %s \n" $host
    expect $uploader $host $ssh_usr $ssh_pwd $local_init_slave $remote_init_slave
  done
  
  # step 4.init slave node at hosts
  printf "\n==== step 4.init slave node at hosts \n"
  for host in ${ssh_hosts[@]}
  do
    if [ "$host" != "$local_ip" ];then
      printf "\n== Host: %s \n" $host
      run_cmd $host "bash ~/qos/init/init_slave.sh"
    fi
  done
  
  # step 5.start qosd service at hosts
  printf "\n==== step 5.start qosd service at hosts \n"  
  for host in ${ssh_hosts[@]}
  do
    printf "\n== Host: %s \n" $host
    run_cmd $host "bash ~/qos/start_qosd.sh >/dev/null 2>&1 &"
  done
}

