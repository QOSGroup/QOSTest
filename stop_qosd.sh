#!/bin/bash

# stop qosd_keep_alive
flag=$(ps aux|grep "start_qosd"|grep -v "grep"|wc -l)
if [ $flag -ge 1 ]
  then
    pids=$(ps aux|grep "start_qosd"|grep -v "grep"|awk '{print $2}')
    for pid in $pids
    do
      echo "[   ok   ] Service qosd_keep_alive is running, pid= $pid"
      kill -9 $pid
      flag_new=$(ps aux|grep "start_qosd"|grep -v "grep"|wc -l)
      if [ $flag_new == $[$flag - 1] ]
        then  
          echo "[   ok   ] Service qosd_keep_alive [ pid= $pid ] is down"
        else
          echo "[ Failed ] Failed to kill the service qosd_keep_alive [ pid= $pid ]"
      fi
      flag=$flag_new
    done
  else
    echo "[ Failed ] Service qosd_keep_alive is not running"
fi

# stop qosd
flag=$(ps aux|grep "qosd start"|grep -v "grep"|wc -l)
if [ $flag -ge 1 ]
  then
    pids=$(ps aux|grep "qosd start"|grep -v "grep"|grep -v "bash"|awk '{print $2}')
    for pid in $pids
    do
      echo "[   ok   ] Service qosd is running, pid= $pid"
      kill -9 $pid
      flag_new=$(ps aux|grep "qosd start"|grep -v "grep"|grep -v "bash"|wc -l)
      if [ $flag_new == $[$flag - 1] ]
        then  
          echo "[   ok   ] Service qosd [ pid= $pid ] is down"
        else
          echo "[ Failed ] Failed to kill the service qosd [ pid= $pid ]"
      fi
      flag=$flag_new
    done
  else
    echo "[ Failed ] Service qosd is not running"
fi


