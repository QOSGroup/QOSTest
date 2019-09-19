#!/bin/bash

# 检查参数
if [ $# != 5 ];then
  echo "Usage: \"bash monitor.sh <proposal-id> <opt_node> <opt_alice> <opt_bob> <opt_charles>\""
  echo "Avaliable options: Yes, Abstain, No, NoWithVeto"
  echo "Example: \"bash monitor.sh 1 Abstain Yes Yes No\""
  exit 1
fi

# 执行投票
source ~/vote.sh $1 $2 $3 $4 $5

# 初始化
pid=$1
saved_proposal_status=$(echo $(~/qoscli query proposal $pid) | grep -o '"proposal_status":"[a-zA-Z]*"' | grep -o '"[a-zA-Z]*"')
saved_block_height="0"
saved_node_qos="0"

# 开始循环
latest_proposal_status=$(echo $(~/qoscli query proposal $pid) | grep -o '"proposal_status":"[a-zA-Z]*"' | grep -o '"[a-zA-Z]*"')
while [ $latest_proposal_status == $saved_proposal_status ]
do
  latest_status=$(~/qoscli query status)
  latest_block_height=$(echo $latest_status | grep -o '"latest_block_height":"[0-9]*"' | grep -o '[0-9]*')
  if [ $latest_block_height != $saved_block_height ];then
	# 到达新块高度
	echo "---- 到达新块高度 ----"
	saved_block_height=$latest_block_height
	latest_block_time=$(echo $latest_status | grep -o '"latest_block_time":".*T.*Z"' | awk -F ':' '{print $2":"$3":"$4}')
	echo "块高度="$latest_block_height"  块时间="$latest_block_time"  提案状态="$latest_proposal_status
	latest_community_fee=$(~/qoscli query community-fee-pool)
	node_qos=$(echo $(~/qoscli query account node) | grep -o '"qos":"[0-9]*"' | grep -o '[0-9]*')
	node_qos_change=$(expr $node_qos - $saved_node_qos)
	saved_node_qos=$node_qos
	echo "社区费池="$latest_community_fee"  用户node余额="$node_qos"  用户node余额变化="$node_qos_change
	~/qoscli query delegator-income --owner node --delegator node --indent
  fi
  sleep 1s
  latest_proposal_status=$(echo $(~/qoscli query proposal $pid) | grep -o '"proposal_status":"[a-zA-Z]*"' | grep -o '"[a-zA-Z]*"')
done

# 监听提案状态变化之后的3块
echo "==== 提案状态发生变化 ===="
count="0"
while [ $count != "3" ]
do
  latest_status=$(~/qoscli query status)
  latest_block_height=$(echo $latest_status | grep -o '"latest_block_height":"[0-9]*"' | grep -o '[0-9]*')
  if [ $latest_block_height != $saved_block_height ];then
	# 到达新块高度
	echo "---- 到达新块高度 ----"
	saved_block_height=$latest_block_height
	latest_block_time=$(echo $latest_status | grep -o '"latest_block_time":".*T.*Z"' | awk -F ':' '{print $2":"$3":"$4}')
	echo "块高度="$latest_block_height"  块时间="$latest_block_time"  提案状态="$latest_proposal_status
	latest_community_fee=$(~/qoscli query community-fee-pool)
	node_qos=$(echo $(~/qoscli query account node) | grep -o '"qos":"[0-9]*"' | grep -o '[0-9]*')
	node_qos_change=$(expr $node_qos - $saved_node_qos)
	saved_node_qos=$node_qos
	echo "社区费池="$latest_community_fee"  用户node余额="$node_qos"  用户node余额变化="$node_qos_change
	~/qoscli query delegator-income --owner node --delegator node --indent
	count=$(expr $count + 1)
  fi
  sleep 1s
done