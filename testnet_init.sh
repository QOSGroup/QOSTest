#!/bin/bash

source ~/qos/testnet/redeploy.sh
source ~/qos/testnet/upgrade_version.sh

function init_testnet(){
  upgrade_qos_version
  #upgrade_kepler_version
  redeploy
}

init_testnet
