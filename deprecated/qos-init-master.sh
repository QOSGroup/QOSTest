#!/bin/bash
# params
echo "1. 准备环境参数"
path=~/.qosd/config/gentx
echo "1.1 交易扫描路径: "$path
ip=$(ifconfig -a |grep inet |grep -v inet6 |grep -v 127 |head -n 1 |awk '{print $2}')
port=26656
echo "1.2 监听地址: "$ip":"$port
echo "1.3 关闭防火墙: "
pwd="admin"
expect -c "
set timeout 1
spawn sudo iptables -F
send \""$pwd"\r\"
interact
"
# main code
echo "2. 清除原有的.qosd和.qoscli目录"
rm -rf ./.qosd
rm -rf ./.qoscli
echo "3. 初始化qos配置文件"
./qosd init --moniker "local-test" --chain-id "test-chain"
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
echo "5. 添加账户node,alice,bob,charles到genesis.json文件"
./qosd add-genesis-accounts node,1000000QOS
./qosd add-genesis-accounts alice,700000QOS
./qosd add-genesis-accounts bob,600000QOS
./qosd add-genesis-accounts charles,1000000QOS
echo "6. 在genesis.json文件中，将账户node标记为特权用户(Guardian)"
./qosd add-guardian --address address1qgwgmpsrd6anj3qjvjsqztj3xt9v24c4mh77x3 --description "Genesis Guardian node"
echo "7. 生成创世交易：使账户node成为验证人(Validator), 绑定500，000QOS"
expect -c "
set timeout 1
spawn ~/qosd gentx --moniker central --owner node --tokens 500000
expect \"Password to sign with 'node':\" {send \"12345678\r\"}
interact
"
echo "8. 收集创世交易到genesis.json文件"
./qosd collect-gentxs
echo "9. config Root CA"
./qosd config-root-ca --qcp ~/root.pub --qsc ~/root.pub
echo "9. 修改genesis.json文件中的governance参数"
sed -ri 's/"min_deposit": "10"/"min_deposit": "100000"/g' ~/.qosd/config/genesis.json
sed -ri 's/"max_deposit_period": "172800000000000"/"max_deposit_period": "120000000000"/g' ~/.qosd/config/genesis.json
sed -ri 's/"voting_period": "172800000000000"/"voting_period": "120000000000"/g' ~/.qosd/config/genesis.json
echo "10. 复制genesis.json文件, 覆盖到~/genesis.json中"
cp -f ~/.qosd/config/genesis.json ~/genesis.json
echo "11. 提取Node-ID, 生成Seeds"
files=$(ls $path)
items=${files//@127.0.0.1.json/@$ip:$port}
for item in $items
do
 line=$line$item\;
done
seeds=${line:0:-1}
echo $seeds
echo "12. 修改~/qos-init-slave脚本文件中的seeds"
sed -ri "s/seeds='(([0-9a-z]*@[0-9.]*:[0-9]*);*)*'/seeds='"$seeds"'/g" ~/qos-init-slave.sh

