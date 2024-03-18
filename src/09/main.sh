#!/bin/bash
declare z=$(ps aux)
declare totalRamKb=$(free | awk 'NR==2 {print $2}')
declare usedRamKb=$(free | awk 'NR==2 {print $3}')
declare availableRam=$(free | awk 'NR==2 {print $7}')
declare availableSecMemory=$(df / | awk 'NR==2 {print $4}')
declare totalSecMemory=$(df / | awk 'NR==2 {print $2}')

while read -r z
do
   cpu=$cpu$(awk '{print "cpu_usage{process=\""$11"\", pid=\""$2"\"}", $3z}');
done <<< "$z"
declare arg1Ram=$(echo "available_ram $availableRam")
declare arg2Ram=$(echo "used_ram $usedRamKb")
declare arg3Ram=$(echo "total_ram $totalRamKb")
declare arg1SecMemory=$(echo "available_hard_drive_memory $availableSecMemory")
declare arg2SecMemory=$(echo "total_hard_drive_memory $totalSecMemory")

curl -X POST -H  "Content-Type: text/plain" --data "$cpu
" http://localhost:9091/metrics/job/top/instance/machine
curl -X POST -H  "Content-Type: text/plain" --data "$arg1Ram
" http://localhost:9091/metrics/job/top/instance/machine
curl -X POST -H  "Content-Type: text/plain" --data "$arg2Ram
" http://localhost:9091/metrics/job/top/instance/machine
curl -X POST -H  "Content-Type: text/plain" --data "$arg3Ram
" http://localhost:9091/metrics/job/top/instance/machine
curl -X POST -H  "Content-Type: text/plain" --data "$arg1SecMemory
" http://localhost:9091/metrics/job/top/instance/machine
curl -X POST -H  "Content-Type: text/plain" --data "$arg2SecMemory
" http://localhost:9091/metrics/job/top/instance/machine

# Use this command in terminal - while sleep 1; do ./main.sh; done;
