#!/bin/bash
# 准备输出文件夹 详情
dir=~/batch_test_output/transfer
rm -rf $dir
mkdir -p $dir
# 1. 公链转账
#     1. 公链QOS转账: `10,000QOS`
#         1. 公链QOS一对一转账: `alice,10000QOS` ➟ `bob,10000QOS`
ts=$(date +"%Y-%m-%d %H:%M:%S")
file_name="1.1.1.公链QOS一对一转账.md"
echo "[ $ts ] 正在生成: $dir/$file_name"
bash transfer.sh 'alice,10000QOS' 'bob,10000QOS' > $dir/$file_name
#         2. 公链QOS一对多转账: `alice,10000QOS` ➟ `bob,5000QOS;charles,5000QOS`
ts=$(date +"%Y-%m-%d %H:%M:%S")
file_name="1.1.2.公链QOS一对多转账.md"
echo "[ $ts ] 正在生成: $dir/$file_name"
bash transfer.sh 'alice,10000QOS' 'bob,5000QOS;charles,5000QOS' > $dir/$file_name
#         3. 公链QOS多对一转账: `alice,5000QOS;bob,5000QOS` ➟ `charles,10000QOS`
ts=$(date +"%Y-%m-%d %H:%M:%S")
file_name="1.1.3.公链QOS多对一转账.md"
echo "[ $ts ] 正在生成: $dir/$file_name"
bash transfer.sh 'alice,5000QOS;bob,5000QOS' 'charles,10000QOS' > $dir/$file_name
#         4. 公链QOS多对多转账: `alice,5000QOS;bob,5000QOS` ➟ `charles,5000QOS;node,5000QOS`
ts=$(date +"%Y-%m-%d %H:%M:%S")
file_name="1.1.4.公链QOS多对多转账.md"
echo "[ $ts ] 正在生成: $dir/$file_name"
bash transfer.sh 'alice,5000QOS;bob,5000QOS' 'charles,5000QOS;node,5000QOS' > $dir/$file_name
#     2. 公链QSC转账: `10,000star`
#         1. 公链QSC一对一转账: `alice,10000star` ➟ `bob,10000star`
ts=$(date +"%Y-%m-%d %H:%M:%S")
file_name="1.2.1.公链QSC一对一转账.md"
echo "[ $ts ] 正在生成: $dir/$file_name"
bash transfer.sh 'alice,10000star' 'bob,10000star' > $dir/$file_name
#         2. 公链QSC一对多转账: `alice,10000star` ➟ `bob,5000star;charles,5000star`
ts=$(date +"%Y-%m-%d %H:%M:%S")
file_name="1.2.2.公链QSC一对多转账.md"
echo "[ $ts ] 正在生成: $dir/$file_name"
bash transfer.sh 'alice,10000star' 'bob,5000star;charles,5000star' > $dir/$file_name
#         3. 公链QSC多对一转账: `alice,5000star;bob,5000star` ➟ `charles,10000star`
ts=$(date +"%Y-%m-%d %H:%M:%S")
file_name="1.2.3.公链QSC多对一转账.md"
echo "[ $ts ] 正在生成: $dir/$file_name"
bash transfer.sh 'alice,5000star;bob,5000star' 'charles,10000star' > $dir/$file_name
#         4. 公链QSC多对多转账: `alice,5000star;bob,5000star` ➟ `charles,5000star;node,5000star`
ts=$(date +"%Y-%m-%d %H:%M:%S")
file_name="1.2.4.公链QSC多对多转账.md"
echo "[ $ts ] 正在生成: $dir/$file_name"
bash transfer.sh 'alice,5000star;bob,5000star' 'charles,5000star;node,5000star' > $dir/$file_name
#     3. 公链QOS-QSC混合转账: `10,000QOS,10,000star`
#         1. 公链QOS-QSC混合一对一转账: `alice,10000QOS,10000star` ➟ `bob,10000QOS,10000star`
ts=$(date +"%Y-%m-%d %H:%M:%S")
file_name="1.3.1.公链QOS-QSC混合一对一转账.md"
echo "[ $ts ] 正在生成: $dir/$file_name"
bash transfer.sh 'alice,10000QOS,10000star' 'bob,10000QOS,10000star' > $dir/$file_name
#         2. 公链QOS-QSC混合一对多转账: `alice,10000QOS,10000star` ➟ `bob,5000QOS,5000star;charles,5000QOS,5000star`
ts=$(date +"%Y-%m-%d %H:%M:%S")
file_name="1.3.2.公链QOS-QSC混合一对多转账.md"
echo "[ $ts ] 正在生成: $dir/$file_name"
bash transfer.sh 'alice,10000QOS,10000star' 'bob,5000QOS,5000star;charles,5000QOS,5000star' > $dir/$file_name
#         3. 公链QOS-QSC混合多对一转账: `alice,5000QOS,5000star;bob,5000QOS,5000star` ➟ `charles,10000QOS,10000star`
ts=$(date +"%Y-%m-%d %H:%M:%S")
file_name="1.3.3.公链QOS-QSC混合多对一转账.md"
echo "[ $ts ] 正在生成: $dir/$file_name"
bash transfer.sh 'alice,5000QOS,5000star;bob,5000QOS,5000star' 'charles,10000QOS,10000star' > $dir/$file_name
#         4. 公链QOS-QSC混合多对多转账: `alice,5000QOS,5000star;bob,5000QOS,5000star` ➟ `charles,5000QOS,5000star;node,5000QOS,5000star`
ts=$(date +"%Y-%m-%d %H:%M:%S")
file_name="1.3.4.公链QOS-QSC混合多对多转账.md"
echo "[ $ts ] 正在生成: $dir/$file_name"
bash transfer.sh 'alice,5000QOS,5000star;bob,5000QOS,5000star' 'charles,5000QOS,5000star;node,5000QOS,5000star' > $dir/$file_name
# 2. 跨链转账
#     1. 跨链QOS转账: `10,000QOS`
#         1. 跨链QOS一对一转账: `alice,10000QOS` ➟ `bob,10000QOS`
ts=$(date +"%Y-%m-%d %H:%M:%S")
file_name="2.1.1.跨链QOS一对一转账.md"
echo "[ $ts ] 正在生成: $dir/$file_name"
bash transfer.sh 'alice,10000QOS' 'bob,10000QOS' 1 > $dir/$file_name
#         2. 跨链QOS一对多转账: `alice,10000QOS` ➟ `bob,5000QOS;charles,5000QOS`
ts=$(date +"%Y-%m-%d %H:%M:%S")
file_name="2.1.2.跨链QOS一对多转账.md"
echo "[ $ts ] 正在生成: $dir/$file_name"
bash transfer.sh 'alice,10000QOS' 'bob,5000QOS;charles,5000QOS' 2 > $dir/$file_name
#         3. 跨链QOS多对一转账: `alice,5000QOS;bob,5000QOS` ➟ `charles,10000QOS`
ts=$(date +"%Y-%m-%d %H:%M:%S")
file_name="2.1.3.跨链QOS多对一转账.md"
echo "[ $ts ] 正在生成: $dir/$file_name"
bash transfer.sh 'alice,5000QOS;bob,5000QOS' 'charles,10000QOS' 3 > $dir/$file_name
#         4. 跨链QOS多对多转账: `alice,5000QOS;bob,5000QOS` ➟ `charles,5000QOS;node,5000QOS`
ts=$(date +"%Y-%m-%d %H:%M:%S")
file_name="2.1.4.跨链QOS多对多转账.md"
echo "[ $ts ] 正在生成: $dir/$file_name"
bash transfer.sh 'alice,5000QOS;bob,5000QOS' 'charles,5000QOS;node,5000QOS' 4 > $dir/$file_name
#     2. 跨链QSC转账: `10,000star`
#         1. 跨链QSC一对一转账: `alice,10000star` ➟ `bob,10000star`
ts=$(date +"%Y-%m-%d %H:%M:%S")
file_name="2.2.1.跨链QSC一对一转账.md"
echo "[ $ts ] 正在生成: $dir/$file_name"
bash transfer.sh 'alice,10000star' 'bob,10000star' 5 > $dir/$file_name
#         2. 跨链QSC一对多转账: `alice,10000star` ➟ `bob,5000star;charles,5000star`
ts=$(date +"%Y-%m-%d %H:%M:%S")
file_name="2.2.2.跨链QSC一对多转账.md"
echo "[ $ts ] 正在生成: $dir/$file_name"
bash transfer.sh 'alice,10000star' 'bob,5000star;charles,5000star' 6 > $dir/$file_name
#         3. 跨链QSC多对一转账: `alice,5000star;bob,5000star` ➟ `charles,10000star`
ts=$(date +"%Y-%m-%d %H:%M:%S")
file_name="2.2.3.跨链QSC多对一转账.md"
echo "[ $ts ] 正在生成: $dir/$file_name"
bash transfer.sh 'alice,5000star;bob,5000star' 'charles,10000star' 7 > $dir/$file_name
#         4. 跨链QSC多对多转账: `alice,5000star;bob,5000star` ➟ `charles,5000star;node,5000star`
ts=$(date +"%Y-%m-%d %H:%M:%S")
file_name="2.2.4.跨链QSC多对多转账.md"
echo "[ $ts ] 正在生成: $dir/$file_name"
bash transfer.sh 'alice,5000star;bob,5000star' 'charles,5000star;node,5000star' 8 > $dir/$file_name
#     3. 跨链QOS-QSC混合转账: `10,000QOS,10,000star`
#         1. 跨链QOS-QSC混合一对一转账: `alice,10000QOS,10000star` ➟ `bob,10000QOS,10000star`
ts=$(date +"%Y-%m-%d %H:%M:%S")
file_name="2.3.1.跨链QOS-QSC混合一对一转账.md"
echo "[ $ts ] 正在生成: $dir/$file_name"
bash transfer.sh 'alice,10000QOS,10000star' 'bob,10000QOS,10000star' 9 > $dir/$file_name
#         2. 跨链QOS-QSC混合一对多转账: `alice,10000QOS,10000star` ➟ `bob,5000QOS,5000star;charles,5000QOS,5000star`
ts=$(date +"%Y-%m-%d %H:%M:%S")
file_name="2.3.2.跨链QOS-QSC混合一对多转账.md"
echo "[ $ts ] 正在生成: $dir/$file_name"
bash transfer.sh 'alice,10000QOS,10000star' 'bob,5000QOS,5000star;charles,5000QOS,5000star' 10 > $dir/$file_name
#         3. 跨链QOS-QSC混合多对一转账: `alice,5000QOS,5000star;bob,5000QOS,5000star` ➟ `charles,10000QOS,10000star`
ts=$(date +"%Y-%m-%d %H:%M:%S")
file_name="2.3.3.跨链QOS-QSC混合多对一转账.md"
echo "[ $ts ] 正在生成: $dir/$file_name"
bash transfer.sh 'alice,5000QOS,5000star;bob,5000QOS,5000star' 'charles,10000QOS,10000star' 11 > $dir/$file_name
#         4. 跨链QOS-QSC混合多对多转账: `alice,5000QOS,5000star;bob,5000QOS,5000star` ➟ `charles,5000QOS,5000star;node,5000QOS,5000star`
ts=$(date +"%Y-%m-%d %H:%M:%S")
file_name="2.3.4.跨链QOS-QSC混合多对多转账.md"
echo "[ $ts ] 正在生成: $dir/$file_name"
bash transfer.sh 'alice,5000QOS,5000star;bob,5000QOS,5000star' 'charles,5000QOS,5000star;node,5000QOS,5000star' 12 > $dir/$file_name
