#!/bin/bash

declare numLogs=$((100 + RANDOM % 1000))
declare currentDate=$(date +%d%m%y)
numLogs=$(echo "${numLogs} 5" | awk '{printf "%.0f\n", $1 / $2}')

fillFile() {
  local logFile=$1
  local i=1
  for (( ; i <= $numLogs; i++))
  do
    local ipAddress=$(dd if=/dev/urandom bs=4 count=1 2>/dev/null | od -An -tu1 | awk '{OFS="."; print $1, $2, $3, $4}')
    local userAgent=$(sort -R ./Parts/ua.txt | head -n 1)
    local responseCode=$(sort -R ./Parts/rc.txt | head -n 1)
    local method=$(sort -R ./Parts/methods.txt | head -n 1)
    local dateSecond=$(date +%z)
    local dateFirst=$(date | awk '{print $3"/"$2"/"$7":"$4}')
    local dateFinal="[${dateFirst} ${dateSecond}]"
    local info="${ipAddress} - - ${dateFinal} \"${method} / HTTP/1.1\" ${responseCode} 100 \"-\" ${userAgent}"
    echo $info >> $logFile
  done
}

createLogs() {
  if [ ! -d "./nginxLogs" ]; then
    mkdir "nginxLogs"
  fi
  for (( i=1; i <= 5; i++))
  do
    fillFile "./nginxLogs/access_${i}_${currentDate}.log"
  done
}

createLogs
