#!/bin/bash

# config
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

seeds='ffa6944e48dcdb0ed6d0dae6fdb1b4fb0bae1f81@192.168.17.52:26656'

echo "1. 清除原有的.qosd和.qoscli目录"
rm -rf $qosd_config_dir
rm -rf $qoscli_config_dir

echo "2. 初始化qos配置文件"
$qosd init --moniker $local_node_moniker --chain-id $qos_chain_id >/dev/null

echo "3. 使用测试网genesis.json文件替换生成的genesis.json文件"
cp -f $genesis_backup $genesis_path

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
echo "5. 配置到Node节点的连接: 在config.toml文件中, 设置seeds: "$seeds
sed -ri 's#seeds = \"(([0-9a-z]*@[0-9.]*:[0-9]*);*)*\"#seeds = \"'$seeds'\"#g' $qosd_config_dir/config/config.toml

