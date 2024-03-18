#!/bin/bash

declare RED='\033[0;41m'
declare GREEN='\033[0;42m'
declare NC='\033[0m'

invalidInput() {
  echo -e "${RED}Error! Invalid input value!.${NC}"
  exit 1
}

outputResult() {
  echo -e "${GREEN}Successful result! All garbage files have been deleted!${NC}"
  echo -e "${GREEN}free memory space - $(df -h / | awk 'NR>1 {print $4}')${NC}"
}

cleanByLog() {
  local numFolders=$(cat /var/log/fileGen2.log | awk '/Type: -d/ {print $6}' | wc -l)
  local folderIndex=1
  local folder='r'
  for (( ; folderIndex <= $numFolders; folderIndex++ ))
  do
    folder=$(cat /var/log/fileGen2.log | awk '/Type: -d/ {print $6}' | awk -v var=$folderIndex 'NR == var' | awk '{print substr($0, 1, length($0)-1)}')
    echo "$folder"
    rm -rf $folder
  done
  outputResult
}

cleanByDate() {
  echo -e "${GREEN}Enter the start and end times up to the minute (DMY - 120124) (HH:MM). All files created within the specified time interval will be deleted.${NC}"
  read -p "Date - (When did it happen?): " fileDate
  read -p "Time - start: " timeStart
  read -p "Time - end(current time): " timeEnd
  if [[ ! $fileDate =~ ^([0-2][0-9]|3[0-1])(0[1-9]|1[0-2])([0-9]{2})$ ]]; then
    invalidInput
  fi
  if [[ $timeStart =~ ^([01]?[0-9]|2[0-3]):[0-5][0-9]$ ]]; then
    local startHours=$((60 * $(echo "$timeStart" | awk -F ":" '{print $1}')))
    local startMinute=$(echo "$timeStart" | awk -F ":" '{print $2}')
    local startResult=$(($startHours + $startMinute))
  else
    invalidInput
  fi
  if [[ $timeEnd =~ ^([01]?[0-9]|2[0-3]):[0-5][0-9]$ ]]; then
    local endHours=$((60 * $(echo "$timeEnd" | awk -F ":" '{print $1}')))
    local endMinute=$(echo "$timeEnd" | awk -F ":" '{print $2}')
    local endResult=$(($endHours + $endMinute))
  else
    invalidInput
  fi
  local time=$(($endResult - $startResult))
  local date=$(echo "*_")$fileDate
  local folders=$( find / -type d -name $date -mmin -$time)
  rm -rf $folders
  outputResult
}

cleanByName() {
  local date=$(echo "*_")$(date +"%d%m%y")
  local folders=$(find / -type d -name $date  -mmin -1000)
  rm -rf $folders
  outputResult
}

checkArguments() {
  if [ $# -ne 1 ]; then
    echo -e "${RED}Error! 1 argument was expected.${NC}"
    echo -e "${GREEN}Usage: cleaningFiles <Way to clean system>${NC}"
    echo -e "${GREEN}1) By log file${NC}"
    echo -e "${GREEN}2) By creation date and time${NC}"
    echo -e "${GREEN}3) By name mask${NC}"
    exit 1
  fi

  if [ $1 -eq 1 ]; then
    cleanByLog
  elif [ $1 -eq 2 ]; then
    cleanByDate
  elif [ $1 -eq 3 ]; then
    cleanByName
  else
    echo -e "${RED}Error! There're only 3 ways to clean system (expected input from 1 to 3)${NC}"
  fi
}

checkArguments $@
