#!/bin/bash

source ~/qos/testnet/config.sh

function upload_expect_script(){
  printf "\n================ Upload Expect Script ================\n"
  local_run_tx_cmd="~/qos/expect/run_tx_cmd.expect"
  remote_run_tx_cmd="~/qos/expect/run_tx_cmd.expect"
  local_import_key="~/qos/expect/import_key.expect"
  remote_import_key="~/qos/expect/import_key.expect"
  for host in ${ssh_hosts[@]}
  do
    printf "\n== Upload 'run_tx_cmd.expect' to host: %s \n" $host
    expect $uploader $host $ssh_usr $ssh_pwd $local_run_tx_cmd $remote_run_tx_cmd
    printf "\n== Upload 'import_key.expect' to host: %s \n" $host
    expect $uploader $host $ssh_usr $ssh_pwd $local_import_key $remote_import_key
  done
}
