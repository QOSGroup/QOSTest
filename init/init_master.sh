#!/bin/bash

# configs
echo "1. 准备环境参数"

password="wf.cy.zs.wzj"

qosd_config_dir=~/.qosd
qoscli_config_dir=~/.qoscli

qos_dir=~/qos
qosd=$qos_dir/bin/qosd
qoscli=$qos_dir/bin/qoscli

qos_chain_id="test-chain"
local_node_moniker="local-test"
root_ca=$qos_dir/certs/root.pub

genesis_path=$qosd_config_dir/config/genesis.json
genesis_backup=$qos_dir/init/genesis.json
gentx_scan_path=$qosd_config_dir/config/gentx

ip=$(ifconfig -a |grep inet |grep -v inet6 |grep -v 127 |head -n 1 |awk '{print $2}')
port=26656

# params
echo " - genesis交易扫描路径: "$gentx_scan_path
echo " - 监听地址: "$ip":"$port
echo " - 关闭防火墙"
expect -c "
set timeout 10
spawn sudo iptables -F
sleep 3
send \"$password\r\"
expect eof
"
# main code
echo "2. 清除原有的.qosd和.qoscli目录"
rm -rf $qosd_config_dir
rm -rf $qoscli_config_dir

echo "3. 初始化qos配置文件"
$qosd init --moniker $local_node_moniker --chain-id $qos_chain_id >/dev/null

echo "4.1 导入密钥node"
expect 1>/dev/null -c "
set timeout 10
spawn $qoscli keys import node
sleep 0.5
send \"tKFI6TwnYSV2ONVfW5xTappKiwnf0kvMClxPOmPKwFjpJxi3P7an/LUZkN7Re6JsXTDU08TrJjaj0Y2CNRgWqg==\r\"
expect \"*key:\" {send \"12345678\r\"}
expect \"*passphrase:\" {send \"12345678\r\"}
interact
"
echo "4.2 导入密钥alice"
expect 1>/dev/null -c "
set timeout 10
spawn $qoscli keys import alice
sleep 0.5
send \"3UcHjus5TjQGpdJgXhNtViLbwQIKtcbVKDHbVa9w+iMRsip6l3yrb7xedOO+WqOdZvVqm3EsSSOJK69fTme4GA==\r\"
expect \"*key:\" {send \"12345678\r\"}
expect \"*passphrase:\" {send \"12345678\r\"}
interact
"
echo "4.3 导入密钥bob"
expect 1>/dev/null -c "
set timeout 10
spawn $qoscli keys import bob
sleep 0.5
send \"AlIiQkdzRu63iPE7OgPjEpR1SO2OOlWukVGUovTqBEQ21DSPKLvr2QCgfL2SOG/O+85BXm9w666mD7+v6QNhUA==\r\"
expect \"*key:\" {send \"12345678\r\"}
expect \"*passphrase:\" {send \"12345678\r\"}
interact
"
echo "4.3 导入密钥charles"
expect 1>/dev/null -c "
set timeout 10
spawn $qoscli keys import charles
sleep 0.5
send \"lfDVAXO1j+5cWk8uJQ5Dy9k1hw9GvnkZi7jOa9aDM/9SKeMd/jGcXNOLS12r7yih6EqDvRYKl1e7jyPfuQhzww==\r\"
expect \"*key:\" {send \"12345678\r\"}
expect \"*passphrase:\" {send \"12345678\r\"}
interact
"
echo "4.4 导入密钥david"
expect 1>/dev/null -c "
set timeout 10
spawn $qoscli keys import david
sleep 0.5
send \"16yZhwCO3LSeHGbMYUVsRKgw1u2DsmR0yKC8PBFejdrQR/P3Vo3bP4ItHlVz96OlCd3dA0cOxfbU06WpKhRgsw==\r\"
expect \"*key:\" {send \"12345678\r\"}
expect \"*passphrase:\" {send \"12345678\r\"}
interact
"
echo "4.5 导入密钥qcpSigner"
expect 1>/dev/null -c "
set timeout 10
spawn $qoscli keys import qcpSigner
sleep 0.5
send \"eRwYKN/jB1AtVAXmFJxGQcnQ1UqMWH5kcQSsPf/IgW0htIzJreJHbMfXBbnC0duZam7FEsgHvCcU0AMLgf8+zA==\r\"
expect \"*key:\" {send \"12345678\r\"}
expect \"*passphrase:\" {send \"12345678\r\"}
interact
"
echo "4.6 导入密钥starBanker"
expect 1>/dev/null -c "
set timeout 10
spawn $qoscli keys import starBanker
sleep 0.5
send \"ZO0OMPF4OSy0N5AWQ3rFqftmAT3IM7d7OLgef+VatLbxrieUCO7SOOQfCIisBOItTql6iTmeeF3voMhq5PJsHw==\r\"
expect \"*key:\" {send \"12345678\r\"}
expect \"*passphrase:\" {send \"12345678\r\"}
interact
"

echo "5. 添加账户node,alice,bob,charles,starBanker到genesis.json文件"
$qosd add-genesis-accounts node,48999960000000QOS
$qosd add-genesis-accounts alice,10000000QOS
$qosd add-genesis-accounts bob,10000000QOS
$qosd add-genesis-accounts charles,10000000QOS
$qosd add-genesis-accounts starBanker,10000000QOS
echo "6. 在genesis.json文件中，将账户node标记为特权用户(Guardian)"
$qosd add-guardian --address qosacc1qgwgmpsrd6anj3qjvjsqztj3xt9v24c4lygasm --description "Genesis-Guardian-Node"
echo "7. 生成创世交易：使账户node成为验证人(Validator), 绑定5,000，000QOS"
expect 1>/dev/null -c "
set timeout 10
spawn $qosd gentx --moniker v_node --owner node --tokens 5000000
expect \"Password to sign with 'node':\" {send \"12345678\r\"}
interact
"
echo "8. 收集创世交易到genesis.json文件"
$qosd collect-gentxs
echo "9. config Root CA"
$qosd config-root-ca --qcp $root_ca --qsc $root_ca
echo "9. 修改genesis.json文件中的参数"
# gov normal
#sed -ri 's/"normal_min_deposit": "100000"/"normal_min_deposit": "100000"/g' ~/.qosd/config/genesis.json
sed -ri 's/"normal_max_deposit_period": "604800000000000"/"normal_max_deposit_period": "120000000000"/g' ~/.qosd/config/genesis.json
sed -ri 's/"normal_voting_period": "1209600000000000"/"normal_voting_period": "120000000000"/g' ~/.qosd/config/genesis.json
# gov important
sed -ri 's/"important_min_deposit": "500000"/"important_min_deposit": "100000"/g' ~/.qosd/config/genesis.json
sed -ri 's/"important_max_deposit_period": "604800000000000"/"important_max_deposit_period": "120000000000"/g' ~/.qosd/config/genesis.json
sed -ri 's/"important_voting_period": "1209600000000000"/"important_voting_period": "120000000000"/g' ~/.qosd/config/genesis.json
# gov critical
sed -ri 's/"critical_min_deposit": "1000000"/"critical_min_deposit": "100000"/g' ~/.qosd/config/genesis.json
sed -ri 's/"critical_max_deposit_period": "604800000000000"/"critical_max_deposit_period": "120000000000"/g' ~/.qosd/config/genesis.json
sed -ri 's/"critical_voting_period": "1209600000000000"/"critical_voting_period": "120000000000"/g' ~/.qosd/config/genesis.json
# income
sed -ri 's/"delegator_income_period_height": "720"/"delegator_income_period_height": "5"/g' ~/.qosd/config/genesis.json
# unbond
sed -ri 's/"unbond_frozen_height": "259200"/"unbond_frozen_height": "1"/g' ~/.qosd/config/genesis.json
echo "10. 复制genesis.json文件, 覆盖到~/qos/genesis.json中"
cp -f $genesis_path $genesis_backup
echo "11. 提取Node-ID, 生成Seeds"
files=$(ls $gentx_scan_path)
items=${files//@127.0.0.1.json/@$ip:$port}
for item in $items
do
 line=$line$item\;
done
seeds=${line:0:-1}
echo $seeds
echo "12. 修改init_slave脚本文件中的seeds"
sed -ri "s/seeds='(([0-9a-z]*@[0-9.]*:[0-9]*);*)*'/seeds='"$seeds"'/g" $qos_dir/init/init_slave.sh

