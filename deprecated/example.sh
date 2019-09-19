#!/bin/bash

testTimes=500

HOSTS=(192.168.1.224 192.168.1.225 192.168.1.226 192.168.1.227)
TYPE=(bond unbond bond unbond compound bond unbond uncomponud bond unbond redelegate bond unbond create-validator bond unbond revoke-validator bond active-validator bond)


QOSCLI="~/bin/qoscli"
QOSPWD="12345678"

SSHCOMMAND="sshpass -pqianbao2019 ssh vagrant@HOST \"COMMAND\""


#run_command host command
#ex. run_command 192.168.1.224 "$QOSCLI q validators --indent"
run_command(){
  c=${SSHCOMMAND/HOST/$1}
  c=${c/COMMAND/$2}
  eval $c
}

random(){
  ((r=$RANDOM%$1))
  echo $r
}

VALIDATORS=()
DELEGATORS=()
init_validators(){
  index=0
  all_validator=$(run_command ${HOSTS[0]} "$QOSCLI q validators --indent" | grep 'owner'|awk '{print $2}'|grep -Po '[a-z0-9A-Z]*')
  for i in $(echo $all_validator | tr ' ' '\n')
  do
    VALIDATORS[$index]=$i
    DELEGATORS[$index]=$i
    ((index=index+1))
  done
}

#1. init all operator users
init_validators

#$host $owner $delegator $amount
bond(){
  run_command $1 "echo $QOSPWD | $QOSCLI tx delegate --owner $2 --delegator $3 --tokens $4"
}

#$host $owner $delegator $amount
unBond(){
  run_command $1 "echo $QOSPWD | $QOSCLI tx unbond --owner $2 --delegator $3 --tokens $4"
}

#$host $owner $delegator
compound(){
  run_command $1 "echo $QOSPWD | $QOSCLI tx modify-compound  --compound --owner $2 --delegator $3"
}

#$host $owner $delegator
unComponud(){
  run_command $1 "echo $QOSPWD | $QOSCLI tx modify-compound --owner $2 --delegator $3"
}

# $host $owner $toOwner $delegator $amount
redelegate(){
  run_command $1 "echo $QOSPWD | $QOSCLI tx redelegate --from-owner $2 --to-owner $3 --delegator $4 --tokens $5"
}

createValidator(){
  //todo

}

#$host $owner
revokeValidator(){
  run_command $1 "echo $QOSPWD | $QOSCLI tx revoke-validator --owner $2"
}

#$host $owner $amount
activeValidator(){
  run_command $1 "echo $QOSPWD | $QOSCLI tx active-validator --owner $2 --tokens $3"
}

#2. main
count=0
while [[ $count -lt $testTimes ]]; do

  type=${TYPE[$(random ${#TYPE[@]})]}
  host=${HOSTS[$(random ${#HOSTS[@]})]}
  ((amount=$RANDOM%100+1))
  owner=${VALIDATORS[$(random ${#VALIDATORS[@]})]}
  delegator=${DELEGATORS[$(random ${#DELEGATORS[@]})]}

  case $type in
    "bond")
      bond $host $owner $delegator $amount
      ;;
    "unbond")
      unBond $host $owner $delegator $amount
      ;;
    "compound")
      compound $host $owner $delegator
      ;;
    "uncomponud")
      unComponud $host $owner $delegator
      ;;
    "redelegate")
      toOwner=${VALIDATORS[$(random ${#VALIDATORS[@]})]}
      redelegate $host $owner $toOwner $delegator $amount
      ;;
    "create-validator")
      createValidator $host $owner
      ;;
    "revoke-validator")
      revokeValidator $host $owner
      ;;
    "active-validator")
      activeValidator $host $owner $amount
      ;;
  esac


  ((count=count+1))
  # ((tt=$RANDOM%10+1))
  # sleep $tt

done
