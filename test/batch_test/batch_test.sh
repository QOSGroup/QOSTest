#!/bin/bash

source ~/qos/testnet/config.sh
source ~/qos/test/metrics.sh

# $1 host
# $2 trimmed_line
# $3 output
function handle_cmd(){
  # parse command and its input
  cmd=$(trim "$(echo "$2" | awk -F '<==' '{print $1}')")
  cmd_input=$(trim "$(echo "$2" | awk -F '<==' '{print $2}')")

  # run command
  if [[ $cmd == qoscli* ]]; then
    qoscli_cmd=$(trim "${cmd:6}")
    if [[ $qoscli_cmd == tx* ]];then
      run_tx_cmd_and_update_metrics $1 "$ssh_qoscli $qoscli_cmd" "$cmd_input" $3
    else
      run_remote_cmd $1 "$ssh_qoscli $qoscli_cmd" "$cmd_input" | tee -a $3
    fi
  elif [[ $cmd == qosd* ]];then
    qosd_cmd=$(trim "${cmd:4}")
    run_remote_cmd $1 "$ssh_qosd $qosd_cmd" "$cmd_input" | tee -a $3
  elif [[ $cmd == run_local* ]];then
    local_cmd=$(trim "${cmd:9}")
    run_local_cmd "$local_cmd" | tee -a $3
  else
    run_remote_cmd $1 "$cmd" "$cmd_input" | tee -a $3
  fi
}

# $1 host
# $2 input_file
# $3 output_file
function handle_script(){
  # prepare args
  host=$1
  input=$2
  output=$3
  
  # handle lines in script file
  cmd_index=0
  script_line_index=0
  script_line_total=$(awk 'END{print NR}' $input)
  #echo "Total line = $script_line_total"
  while [ "$script_line_index" -lt "$script_line_total " ]
  do
    let script_line_index++
    #echo "Current line :  $script_line_index  of $script_line_total"
    raw_line=$(awk "NR==$script_line_index{print}" $input)
    trimmed_line=$(trim "$raw_line")
    if [ -z "$trimmed_line" ];then
      # empty line
      printf "\n" | tee -a $output
    elif [[ $trimmed_line == \#* ]];then
      # comment line
      printf "\n================================================================\n" | tee -a $output
      printf "\n> %s\n" "$trimmed_line" | tee -a $output
    else
      # command line
      let cmd_index++
      printf "\n================================================================\n" | tee -a $output
      printf "\n== [ %s ] Command [ No.%s ]\n" "$(date '+%Y-%m-%d %H:%M:%S')" $cmd_index | tee -a $output
      printf "\n> %s\n" "$trimmed_line" | tee -a $output
      handle_cmd $host "$trimmed_line" $output
    fi
    #echo "Current line  is done :  $script_line_index  of $script_line_total"
  done
}


function batch_test(){
  printf "\n================ Batch Test ================\n"
  
  # prepare input and output folder
  input_dir=~/qos/test/batch_test/script
  output_dir=~/qos/test/batch_test/output/$(date '+%Y%m%d_%H%M%S')
  mkdir -p "$output_dir"
  printf "\nInput Folder: %s \n" $input_dir
  printf "\nOutput Folder: %s \n" $output_dir
  
  # prepare host to run script
  host_index=0
  host_total=${#ssh_hosts[@]}
  host_flag=0
  while [ $host_index -lt $host_total ]
  do
    host=${ssh_hosts[$host_index]}
    printf "\n寻找远程主机: %s\n" $host
    if [ "$host" != "$local_host" ];then
      host_flag=1
    printf "\n使用远程主机: %s\n" $host
      break
    fi
    let host_index++
  done
  
  if [ "$host_flag" == "0" ];then
    printf "\n警告: ssh_hosts中缺少远程主机, 将使用本地主机进行测试(无法创建Validator)\n"
    host=$local_host
  fi
  
  # run batch test
  printf "\n========-------- Run Scripts --------========\n"
  for input_file in $(ls $input_dir | grep ".txt")
  do
    # prepare input and output file
    output_file=$(echo $input_file | sed 's/.txt/_output.txt/g')
    input=$input_dir/$input_file
    output=$output_dir/$output_file
    printf "\nInput File: %s \n" $input_file
    printf "\nOutput File: %s \n" $output_file
    
    # handle script file
    handle_script $host $input $output
  done
}

