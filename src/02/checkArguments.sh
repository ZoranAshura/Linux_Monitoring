#!/bin/bash

declare RED='\033[0;41m'
declare GREEN='\033[0;42m'
declare NC='\033[0m'

checkArguments() {
  local length=$1
  if [ $# -ne 3 ]; then
    echo -e "${RED}Error! 3 arguments were expected.${NC}"
    echo -e "${GREEN}Usage:  generatefiles <charactersFFolders> <charactersFiles> <size of file>${NC}"
    exit 1
  fi

  if [[ ! $1 =~ ^[[:alpha:]]+$ ]] || [ ! ${#length} -le 7 ]; then
      echo -e "${RED}Error. The first argument must contain only alphabet letters (no more than 7 characters).${NC}"
      exit 1
  elif [ ${#length} -eq 1 ]; then
      echo -e "${RED}Error. The script can only be run using at least 2 characters(1 - argument).${NC}"
      exit 1
  fi

  if [[ $2 =~ ^[a-zA-Z]*[.][a-zA-Z]*$ ]]; then
    fileName=$(echo "$2" | awk -F "." '{print $1}')
    fileExtension=$(echo "$2" | awk -F "." '{print $2}')
    if [ ! ${#fileName} -le 7 ] || [ ! ${#fileExtension} -le 3 ]; then
      echo -e "${RED}Error. (2 argument) Invalid name for file (no more than 7 characters for the name, no more than 3 characters for the extension).${NC}"
      echo -e "${RED}You can use only alphabet letters.${NC}"
      echo -e "${RED}Correct example - text.txt${NC}"
      exit 1
    elif [ ${#fileName} -eq 1 ]; then
      echo -e "${RED}Error. The script can only be run using at least 2 characters(2 - argument).${NC}"
      exit 1
    fi
  else
    echo -e "${RED}Error. (2 argument) Invalid name for file (no more than 7 characters for the name, no more than 3 characters for the extension).${NC}"
    echo -e "${RED}You can use only alphabet letters.${NC}"
    echo -e "${RED}Correct example - text.txt${NC}"
    exit 1
  fi

  if [[ $3 =~ ^[0-9]+Mb$ ]]; then
    fileSize=$(echo "$3" | awk -F "M" '{print $1}')
    if [ ! $fileSize -le 100 ] || [ $fileSize -eq 0 ]; then
      echo -e "${RED}Error. (3 argument) The file size can't be greater than 100Mb.${NC}"
      exit 1
    fi
  else
    echo -e "${RED}Error. Expeted file size in Mb${NC}"
    exit 1
  fi
}

checkArguments $@
