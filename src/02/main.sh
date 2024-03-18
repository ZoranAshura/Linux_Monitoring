#!/bin/bash
declare startTime=$(date +%s.%N)
source checkArguments.sh $@
source fileGen.sh $@
declare endTime=$(date +%s.%N)
declare totalTime=$(echo "$startTime $endTime" | awk '{print $1 - $2}')
echo "Script execution time (in seconds) = $totalTime"
