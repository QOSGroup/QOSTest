#!/bin/bash
seeds='40b0489fa8ddb3ac2b7c43276477206c6a0c9989@192.168.61.129:26656'
echo "1. 清除原有的.qosd和.qoscli目录"
rm -rf ./.qosd
rm -rf ./.qoscli
echo "2. 初始化qos配置文件"
./qosd init --moniker "local-test" --chain-id "test-chain"
echo "3. 使用测试网genesis.json文件替换生成的genesis.json文件"
cp -f ~/genesis.json ~/.qosd/config/genesis.json
echo "4.1 导入密钥node"
expect -c "
set timeout 1
spawn ~/qoscli keys import node
send \"tKFI6TwnYSV2ONVfW5xTappKiwnf0kvMClxPOmPKwFjpJxi3P7an/LUZkN7Re6JsXTDU08TrJjaj0Y2CNRgWqg==\r\"
expect \"*key:\" {send \"12345678\r\"}
expect \"*passphrase:\" {send \"12345678\r\"}
interact
"
echo "4.2 导入密钥alice"
expect -c "
set timeout 1
spawn ~/qoscli keys import alice
send \"3UcHjus5TjQGpdJgXhNtViLbwQIKtcbVKDHbVa9w+iMRsip6l3yrb7xedOO+WqOdZvVqm3EsSSOJK69fTme4GA==\r\"
expect \"*key:\" {send \"12345678\r\"}
expect \"*passphrase:\" {send \"12345678\r\"}
interact
"
echo "4.3 导入密钥bob"
expect -c "
set timeout 1
spawn ~/qoscli keys import bob
send \"AlIiQkdzRu63iPE7OgPjEpR1SO2OOlWukVGUovTqBEQ21DSPKLvr2QCgfL2SOG/O+85BXm9w666mD7+v6QNhUA==\r\"
expect \"*key:\" {send \"12345678\r\"}
expect \"*passphrase:\" {send \"12345678\r\"}
interact
"
echo "4.3 导入密钥charles"
expect -c "
set timeout 1
spawn ~/qoscli keys import charles
send \"lfDVAXO1j+5cWk8uJQ5Dy9k1hw9GvnkZi7jOa9aDM/9SKeMd/jGcXNOLS12r7yih6EqDvRYKl1e7jyPfuQhzww==\r\"
expect \"*key:\" {send \"12345678\r\"}
expect \"*passphrase:\" {send \"12345678\r\"}
interact
"
echo "5. 配置到Node节点的连接: 在config.toml文件中, 设置seeds: "$seeds
sed -ri 's#seeds = \"(([0-9a-z]*@[0-9.]*:[0-9]*);*)*\"#seeds = \"'$seeds'\"#g' ~/.qosd/config/config.toml

