#!/bin/bash
echo "令用户alice, bob, charles分别委托500,000QOS给验证人node"
expect -c "
set timeout 1
spawn ~/qoscli tx delegate --owner node --delegator alice --tokens 500000 --indent
expect \"Password to sign with 'alice':\" {send \"12345678\r\"}
interact
"
expect -c "
set timeout 1
spawn ~/qoscli tx delegate --owner node --delegator bob --tokens 500000 --indent
expect \"Password to sign with 'bob':\" {send \"12345678\r\"}
interact
"
expect -c "
set timeout 1
spawn ~/qoscli tx delegate --owner node --delegator charles --tokens 500000 --indent
expect \"Password to sign with 'charles':\" {send \"12345678\r\"}
interact
"
