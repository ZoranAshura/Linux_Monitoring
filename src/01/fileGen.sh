#!/bin/bash
declare path=$1
declare numFolders=$2
declare folderSymbols=$3
declare numFiles=$4
declare fileSymbols=$(echo "$5" | awk -F "." '{print $1}')
declare fileExtension=$(echo "$5" | awk -F "." '{print $2}')
declare fileSize=$(echo "$6" | awk -F "k" '{print $1}')

createNames(){
  local indexCharacter=$1
  local characters=$2
  local COUNT=$3
  local length=$(echo "$characters" | awk '{print length}')
  local remainder=$(expr ${indexCharacter} % ${length})
  if [ $remainder -eq 0 ]; then
    remainder=$length
  fi
  local character=$(echo "$characters" | awk 'BEGIN { FS = "" } { for (i=1; i<=length; i++) print substr($0, i, 1) }' | awk -v var=$remainder 'NR == var')
  local newValue=$(awk -v count="$COUNT" -v var="$character" 'BEGIN { for (i = 0; i < count; i++) printf var }')
  local finalValue=$(echo "$characters" | awk -v var1="$character" -v var2="$newValue" 'BEGIN {count=0} {if (count == 0) {sub(var1, var2, $0); count++} print}')
  echo "$finalValue"
}

checkNumChar() {
  local count=$1
  local length=$2
  local remainder=$3
  if [ $length -le 2 ] && [ $count -eq 1 ]; then
    ((count++))
  fi
  if [ $remainder -eq 1 ]; then
    ((count++))
  fi
  echo $count
}

CreateFolders(){
  local depth=$1
  local folderRoot=$2
  if [ ! $folderRoot == $path ]; then
    CreateFiles $folderRoot folder$name
  fi
  if [ $depth -eq 1 ]
  then
      return;
  fi
  local newDepth=$((depth + 1))
  local countFolders=1
  local folderIndex=1
  local lengthFolder=$(echo "$folderSymbols" | awk '{print length}')
  for (( ; folderIndex <= $numFolders; folderIndex++ ))
  do
      local remainder=$(expr ${folderIndex} % ${lengthFolder})
      countFolders=$(checkNumChar $countFolders $lengthFolder $remainder)
      local firstName=$(createNames "$folderIndex" "$folderSymbols" "$countFolders")
      local secondName=$(date +"%d%m%y")
      local folderName=${firstName}_${secondName}
      fullFolderName=$folderRoot/$folderName
      mkdir $fullFolderName
      echo "Type: -d; Path: ${folderRoot}; Name: ${fullFolderName}; Date: $(date)" >> /var/log/fileGen1.log
      local newRoot=$fullFolderName
      CreateFolders "$newDepth" "$newRoot" "$folderSymbols"
  done
}

CreateFiles(){
  local folderRoot=$1
  local folderName=$2
  local countFiles=1
  local fileIndex=1
  local lengthFile=$(echo "$fileSymbols" | awk '{print length}')
  for (( ; fileIndex <= $numFiles; fileIndex++ ))
  do
      local remainder=$(expr ${fileIndex} % ${lengthFile})
      countFiles=$(checkNumChar $countFiles $lengthFile $remainder)
      local firstName=$(createNames "$fileIndex" "$fileSymbols" "$countFiles")
      local secondName=$(date +"%d%m%y")
      local fileName=${firstName}_${secondName}.${fileExtension}
      CreateFile "$fileName" "$folderRoot"
      echo "Type: -f; Path: ${folderRoot}/${fullFolderName}/; Name: ${fileName}; Date: $(date)" >> /var/log/fileGen1.log
  done
}

CreateFile(){
  local rootSize=$(df / | awk 'NR>1 {print $4}')
  if [ $rootSize -le 1000000 ]; then
    echo "Warning! There is 1GB of free space left on the file system!"
    echo "Terminating file generations..."
    exit 1
  fi
  local fileName=$1
  local folderRoot=$2
  local fullFileName=$folderRoot/$fileName
  head -c ${fileSize}KB /dev/urandom > $fullFileName
}


CreateFolders "0" "$path" "$folderSymbols"
