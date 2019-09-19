#!/bin/bash

# check param num
if [ $# != 5 ];then
  echo "Usage: \"bash vote.sh <proposal-id> <opt_node> <opt_alice> <opt_bob> <opt_charles>\""
  echo "Avaliable options: Yes, Abstain, No, NoWithVeto"
  echo "Example: \"bash vote.sh 1 Abstain Yes Yes No\""
  exit 1
fi

# proposal-id
pid=$1

# option settings
opt_node=$2
opt_alice=$3
opt_bob=$4
opt_charles=$5

# voting
echo "==== node >> "$opt_node" ===="
expect -c "
set timeout 1
spawn ~/qoscli tx vote --proposal-id "$pid" --voter node --option "$opt_node" --indent
expect \"Password to sign with 'node':\" {send \"12345678\r\"}
interact
"
echo "==== alice >> "$opt_alice" ===="
expect -c "
set timeout 1
spawn ~/qoscli tx vote --proposal-id "$pid" --voter alice --option "$opt_alice" --indent
expect \"Password to sign with 'alice':\" {send \"12345678\r\"}
interact
"
echo "==== bob >> "$opt_bob" ===="
expect -c "
set timeout 1
spawn ~/qoscli tx vote --proposal-id "$pid" --voter bob --option "$opt_bob" --indent
expect \"Password to sign with 'bob':\" {send \"12345678\r\"}
interact
"
echo "==== charles >> "$opt_charles" ===="
expect -c "
set timeout 1
spawn ~/qoscli tx vote --proposal-id "$pid" --voter charles --option "$opt_charles" --indent
expect \"Password to sign with 'charles':\" {send \"12345678\r\"}
interact
"
echo "======== tally ========"
~/qoscli query tally $pid --indent

