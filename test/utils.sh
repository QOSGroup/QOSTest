#!/bin/bash

# 定义函数: calc
function calc() {
  echo "$(echo "$1" | bc)"
}

# 定义函数: 用于将null转为0
function null2zero(){
  if test -z "$1"
  then
    echo "0"
  else
    echo $1
  fi
}

# 定义函数: trim
function trim(){
  trimmed=$1
  trimmed=${trimmed%% }
  trimmed=${trimmed## }
  echo $trimmed
}

# Function to print array
# - $1 array
function print_array(){

  if [ ${#1} == 0 ];then
    printf "Empty\n"
  else
    printf "| Index | Value                                                                                                                    |\n"
    printf "| ----: | :----------------------------------------------------------------------------------------------------------------------- |\n"
    index=0
    for item in $1
    do 
      printf "| %5s | %-120s |\n" $index "$item"
      let index++
    done
  fi
}
# print_array "arr" ${#arr[@]} "$(echo ${arr[@]})"
