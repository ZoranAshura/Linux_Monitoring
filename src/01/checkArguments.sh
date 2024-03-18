#!/bin/bash

declare RED='\033[0;41m'
declare GREEN='\033[0;42m'
declare NC='\033[0m'

checkArguments() {
  local length=$3
  if [ $# -ne 6 ]; then
    echo -e "${RED}Error! 6 arguments were expected.${NC}"
    echo -e "${GREEN}Usage:  generatefiles <absolute path> <num of folders> <charactersFFolders> <num of files> <charactersFiles> <size of file>${NC}"
    exit 1
  fi

  if [[ ! $1 =~ ^"/" ]] || [ ! -d $1 ]; then
    echo -e "${RED}Error! The input argument is not a valid directory path.${NC}"
    echo -e "${RED}Please, enter absolute path, starts with '/' directory.${NC}"
    exit 1
  fi

  if [[ ! $2 =~ ^[0-9]+$ ]]; then
    echo -e "${RED}Error. The second argument must contain only numbers.${NC}"
    exit 1
  fi

  if [[ ! $3 =~ ^[[:alpha:]]+$ ]] || [ ! ${#length} -le 7 ]; then
    echo -e "${RED}Error. The third argument must contain only alphabet letters (no more than 7 characters).${NC}"
    exit 1
  elif [ ${#length} -eq 1 ]; then
    echo -e "${RED}Error. The script can only be run using at least 2 characters(3 - argument).${NC}"
    exit 1
  fi

  if [[ ! $4 =~ ^[0-9]+$ ]]; then
      echo -e "${RED}Error. The fourth argument argument must contain only numbers.${NC}"
      exit 1
  fi

  if [[ $5 =~ ^[a-zA-Z]*[.][a-zA-Z]*$ ]]; then
    fileName=$(echo "$5" | awk -F "." '{print $1}')
    fileExtension=$(echo "$5" | awk -F "." '{print $2}')
    if [ ! ${#fileName} -le 7 ] || [ ! ${#fileExtension} -le 3 ]; then
      echo -e "${RED}Error. (5 argument) Invalid name for file (no more than 7 characters for the name, no more than 3 characters for the extension).${NC}"
      echo -e "${RED}You can use only alphabet letters.${NC}"
      echo -e "${RED}Correct example - text.txt${NC}"
      exit 1
    elif [ ${#fileName} -eq 1 ]; then
      echo -e "${RED}Error. The script can only be run using at least 2 characters(5 - argument).${NC}"
      exit 1
    fi
  else
    echo -e "${RED}Error. (5 argument) Invalid name for file (no more than 7 characters for the name, no more than 3 characters for the extension).${NC}"
    echo -e "${RED}You can use only alphabet letters.${NC}"
    echo -e "${RED}Correct example - text.txt${NC}"
    exit 1
  fi

  if [[ $6 =~ ^[0-9]+kb$ ]]; then
    fileSize=$(echo "$6" | awk -F "k" '{print $1}')
    if [ ! $fileSize -le 100 ] || [ $fileSize -eq 0 ]; then
      echo -e "${RED}Error. (6 argument) The file size can't be greater than 100kb.${NC}"
      exit 1
    fi
  else
    echo -e "${RED}Error. Expeted file size in kb${NC}"
    exit 1
  fi
}

checkArguments $@
