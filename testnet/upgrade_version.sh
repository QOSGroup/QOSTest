#!/bin/bash

source ~/qos/testnet/config.sh

function upgrade_qos_version(){
  printf "\n================ Upgrade QOS Version ================\n"
  printf "\n== stop qosd service at hosts \n"
  for host in ${ssh_hosts[@]}
  do
    run_cmd_and_print $host "bash ~/qos/stop_qosd.sh"
  done
  local_qosd="~/qos/bin/qosd"
  remote_qosd="~/qos/bin/qosd"
  local_qoscli="~/qos/bin/qoscli"
  remote_qoscli="~/qos/bin/qoscli"
  for host in ${ssh_hosts[@]}
  do
    printf "\n== Upload 'qosd' to host: %s \n" $host
    expect $uploader $host $ssh_usr $ssh_pwd $local_qosd $remote_qosd
    printf "\n== Upload 'qoscli' to host: %s \n" $host
    expect $uploader $host $ssh_usr $ssh_pwd $local_qoscli $remote_qoscli
  done
}

function upgrade_kepler_version(){
  printf "\n================ Upgrade Kepler Version ================\n"
  local_kepler="~/qos/bin/kepler"
  remote_kepler="~/qos/bin/kepler"
  for host in ${ssh_hosts[@]}
  do
    printf "\n== Upload 'kepler' to host: %s \n" $host
    expect $uploader $host $ssh_usr $ssh_pwd $local_kepler $remote_kepler
  done
}
