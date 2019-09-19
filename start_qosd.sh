#!/bin/bash

# config
qos_path=~/qos
log_path=$qos_path/logs
latest_log=$log_path/qosd_latest.log
self_log=$log_path/qosd_keep_alive.log

# var
interval=30
retry_count=0
retry_limit=10
retry=(1st 2nd 3th 4th 5th 6th 7th 8th 9th 10th)

# ensure logs dir and self log
mkdir -p $log_path

# main
while true
do
  flag=$(ps aux|grep "qosd"|grep -v "grep"|grep -v "bash"|wc -l)
  ts=$(date '+%Y-%m-%d_%H:%M:%S')
  if [ $flag == 0 ];then
    echo "$ts [failed] Service qosd is down." >> $self_log
    # rename log file
    if [ -f $latest_log ];then
      echo "move $latest_log to $log_path/qosd_$ts.log" >> $self_log
      mv $latest_log $log_path/qosd_$ts.log
    fi
    # start qosd   
    echo "$ts [failed] ${retry[$retry_count]} try to start service qosd." >> $self_log
    let retry_count++   
    nohup $qos_path/bin/qosd start > $latest_log 2>&1 &
    echo "$ts [failed] Result: $result" >> $self_log
    # recheck
    flag=$(ps aux|grep "qosd"|grep -v "grep"|wc -l)
    if [ $flag == 0 ];then
      # start failed
      echo "$ts [failed] Service qosd is failed to start." >> $self_log
      if [ $retry_count == $retry_limit ];then
        exit
      fi
      echo "$ts [failed] Next retry will after $interval second(s)." >> $self_log
    else
      # start success
      echo "$ts [ ok ] Service qosd is started." >> $self_log
      let retry_count=0
    fi
  else
    echo "$ts [ ok ] Service qosd is alive." >> $self_log
  fi
  sleep $interval
done

