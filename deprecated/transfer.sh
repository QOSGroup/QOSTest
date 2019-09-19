#!/bin/bash
# 定义函数: 用于将null转为0
function null2zero(){
  if test -z "$1"
  then
    echo "0"
  else
    echo $1
  fi
}

# 检查入参
if [ $# -lt "2" -o $# -gt "3" ]; then
  echo -e "Usage: \"bash transfer.sh [senders] [receivers] <qcp-blockheight>\""
  echo -e "Example(链内转账): \n\t\"bash transfer.sh 'alice,5000QOS;bob,5000QOS' 'charles,5000QOS;node,5000QOS'\""
  echo -e "Example(跨链转账): \n\t\"bash transfer.sh 'alice,5000QOS;bob,5000QOS' 'charles,5000QOS;node,5000QOS' 1\""
  exit
fi

# 准备参数
qcp_chain_id="test-qcp-chain"
qcp_signer="qcp"
senders=$1
receivers=$2
qcp_block_height=$3

# 构建转账命令
senders_cmd="--senders '$senders'"
receivers_cmd="--receivers '$receivers'"
qcp_cmd="--qcp --qcp-from $qcp_chain_id --qcp-signer $qcp_signer --qcp-blockheight $qcp_block_height"
cmd="~/qoscli tx transfer --indent $senders_cmd $receivers_cmd"
if [ $# == 3 ]; then
  cmd="$cmd $qcp_cmd"
fi

# 转账之前，用户账户余额情况
account_node_old=$(~/qoscli query account node)
account_alice_old=$(~/qoscli query account alice)
account_bob_old=$(~/qoscli query account bob)
account_charles_old=$(~/qoscli query account charles)

# 解析数据
node_qos_old=$(echo $account_node_old | grep -o '"qos":"[0-9]*"' | grep -o '[0-9]*')
node_star_old=$(echo $account_node_old | grep -o '"coin_name":"star","amount":"[0-9]*"' | grep -o '[0-9]*')
alice_qos_old=$(echo $account_alice_old | grep -o '"qos":"[0-9]*"' | grep -o '[0-9]*')
alice_star_old=$(echo $account_alice_old | grep -o '"coin_name":"star","amount":"[0-9]*"' | grep -o '[0-9]*')
bob_qos_old=$(echo $account_bob_old | grep -o '"qos":"[0-9]*"' | grep -o '[0-9]*')
bob_star_old=$(echo $account_bob_old | grep -o '"coin_name":"star","amount":"[0-9]*"' | grep -o '[0-9]*')
charles_qos_old=$(echo $account_charles_old | grep -o '"qos":"[0-9]*"' | grep -o '[0-9]*')
charles_star_old=$(echo $account_charles_old | grep -o '"coin_name":"star","amount":"[0-9]*"' | grep -o '[0-9]*')

# 处理null值
node_qos_old=$(null2zero $node_qos_old)
node_star_old=$(null2zero $node_star_old)
alice_qos_old=$(null2zero $alice_qos_old)
alice_star_old=$(null2zero $alice_star_old)
bob_qos_old=$(null2zero $bob_qos_old)
bob_star_old=$(null2zero $bob_star_old)
charles_qos_old=$(null2zero $charles_qos_old)
charles_star_old=$(null2zero $charles_star_old)

# 打印
printf "# 交易之前\n"
printf "## 账户余额情况\n"
printf "| key | qos | star |\n"
printf "| --: | --: | ---: |\n"
printf "| %s | %s | %s |\n" "node"    $node_qos_old    $node_star_old
printf "| %s | %s | %s |\n" "alice"   $alice_qos_old   $alice_star_old
printf "| %s | %s | %s |\n" "bob"     $bob_qos_old     $bob_star_old
printf "| %s | %s | %s |\n" "charles" $charles_qos_old $charles_star_old

# 社区费池
community_fee_old=$(~/qoscli query community-fee-pool | sed 's/\"//g')
printf "## 社区费池情况\n"
printf "| community_fee   | Δcommunity_fee |\n"
printf "| --------------: | --------------: |\n"
printf "| %s | %s |\n" $community_fee_old "0"

# 执行转账
printf "# 执行交易\n"
expect << EOF
set timeout 10
log_user 0
spawn bash -c "$cmd > ~/temp.log"
expect {
  "Password to sign with '*':" {send "12345678\r";exp_continue;}
  eof
}
EOF

# 读取~/temp.log文件, 提取交易哈希, 并根据哈希查询交易详情
log=$(cat ~/temp.log)
printf "## 交易结果\n"
echo -e "\`\`\`json"
echo "$log"
echo -e "\`\`\`"
tx_hash=$(echo $log | grep -o '"hash": "[0-9A-Z]*"' | grep -o '[0-9A-Z]*')
printf "## 交易哈希\n"
echo -e "\`$tx_hash\`"
tx=$(~/qoscli query tx $tx_hash --indent)
printf "## 交易详情\n"
echo -e "\`\`\`json"
echo "$tx"
echo -e "\`\`\`"

# 等待转账生效
printf "# 交易生效过程\n"
count="0"
latest_status=$(~/qoscli query status)
saved_block_height=$(echo $latest_status | grep -o '"latest_block_height":"[0-9]*"' | grep -o '[0-9]*')
while [ $count != "2" ]
do
  latest_status=$(~/qoscli query status)
  latest_block_height=$(echo $latest_status | grep -o '"latest_block_height":"[0-9]*"' | grep -o '[0-9]*')
  if [ $latest_block_height != $saved_block_height ];then
    printf "## 到达新块: [%s] ==> [%s]\n" $saved_block_height $latest_block_height
    saved_block_height=$latest_block_height
    count=$(expr $count + 1)

    # 转账之后，用户账户余额情况
    account_node_new=$(~/qoscli query account node)
    account_alice_new=$(~/qoscli query account alice)
    account_bob_new=$(~/qoscli query account bob)
    account_charles_new=$(~/qoscli query account charles)
    
    # 解析数据
    node_qos_new=$(echo $account_node_new | grep -o '"qos":"[0-9]*"' | grep -o '[0-9]*')
    node_star_new=$(echo $account_node_new | grep -o '"coin_name":"star","amount":"[0-9]*"' | grep -o '[0-9]*')
    alice_qos_new=$(echo $account_alice_new | grep -o '"qos":"[0-9]*"' | grep -o '[0-9]*')
    alice_star_new=$(echo $account_alice_new | grep -o '"coin_name":"star","amount":"[0-9]*"' | grep -o '[0-9]*')
    bob_qos_new=$(echo $account_bob_new | grep -o '"qos":"[0-9]*"' | grep -o '[0-9]*')
    bob_star_new=$(echo $account_bob_new | grep -o '"coin_name":"star","amount":"[0-9]*"' | grep -o '[0-9]*')
    charles_qos_new=$(echo $account_charles_new | grep -o '"qos":"[0-9]*"' | grep -o '[0-9]*')
    charles_star_new=$(echo $account_charles_new | grep -o '"coin_name":"star","amount":"[0-9]*"' | grep -o '[0-9]*')

    # 处理null值
    node_qos_new=$(null2zero $node_qos_new)
    node_star_new=$(null2zero $node_star_new)
    alice_qos_new=$(null2zero $alice_qos_new)
    alice_star_new=$(null2zero $alice_star_new)
    bob_qos_new=$(null2zero $bob_qos_new)
    bob_star_new=$(null2zero $bob_star_new)
    charles_qos_new=$(null2zero $charles_qos_new)
    charles_star_new=$(null2zero $charles_star_new)

    # 打印
    printf "### 账户余额情况\n"
    printf "| key | qos | star |\n"
    printf "| --: | --: | ---: |\n"
    printf "| %s | %s | %s |\n" "node"    $node_qos_new    $node_star_new
    printf "| %s | %s | %s |\n" "alice"   $alice_qos_new   $alice_star_new
    printf "| %s | %s | %s |\n" "bob"     $bob_qos_new     $bob_star_new
    printf "| %s | %s | %s |\n" "charles" $charles_qos_new $charles_star_new

    # 账户余额QOS变动情况
    node_qos_diff=$(expr $node_qos_new - $node_qos_old)
    alice_qos_diff=$(expr $alice_qos_new - $alice_qos_old)
    bob_qos_diff=$(expr $bob_qos_new - $bob_qos_old)
    charles_qos_diff=$(expr $charles_qos_new - $charles_qos_old)

    # 账户余额QSC变动情况
    node_star_diff=$(expr $node_star_new - $node_star_old)
    alice_star_diff=$(expr $alice_star_new - $alice_star_old)
    bob_star_diff=$(expr $bob_star_new - $bob_star_old)
    charles_star_diff=$(expr $charles_star_new - $charles_star_old)

    # 打印
    printf "### 账户余额变动情况\n"
    printf "| key   | Δqos | Δstar |\n"
    printf "| ----: | ----: | -----: |\n"
    printf "| %s | %s | %s |\n" "node"    $node_qos_diff    $node_star_diff
    printf "| %s | %s | %s |\n" "alice"   $alice_qos_diff   $alice_star_diff
    printf "| %s | %s | %s |\n" "bob"     $bob_qos_diff     $bob_star_diff
    printf "| %s | %s | %s |\n" "charles" $charles_qos_diff $charles_star_diff
 
     # 社区费池
    community_fee_new=$(~/qoscli query community-fee-pool | sed 's/\"//g')
    community_fee_diff=$(expr $community_fee_new - $community_fee_old)
    community_fee_old=$community_fee_new
    printf "### 社区费池情况\n"
    printf "| community_fee   | Δcommunity_fee |\n"
    printf "| --------------: | --------------: |\n"
    printf "| %s | %s |\n" $community_fee_new $community_fee_diff
    
    # 更新缓存
    node_qos_old=$node_qos_new
    node_star_old=$node_star_new
    alice_qos_old=$alice_qos_new
    alice_star_old=$alice_star_new
    bob_qos_old=$bob_qos_new
    bob_star_old=$bob_star_new
    charles_qos_old=$charles_qos_new
    charles_star_old=$charles_star_new
  fi
  sleep 0.1s
done
