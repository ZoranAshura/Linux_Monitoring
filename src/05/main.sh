declare RED='\033[0;41m'
declare GREEN='\033[0;42m'
declare NC='\033[0m'

sortByResponseCode() {
  echo -e "${GREEN}Choose methods:${NC}"
  echo -e "${GREEN}1 - GET${NC}"
  echo -e "${GREEN}2 - POST${NC}"
  echo -e "${GREEN}3 - PUT${NC}"
  echo -e "${GREEN}4 - PATCH${NC}"
  echo -e "${GREEN}5 - DELETE${NC}"
  read way
  if [[ ! $way =~ ^[0-9]+$ ]]; then
    echo -e "${RED}Error! The argument must contain only numbers.${NC}"
    exit 1
  fi
  if [ $way -eq 1 ]; then
    cat ../04/nginxLogs/*.log | grep "GET"
    echo -e "${GREEN}All entries sorted by response code (GET) - $(cat ../04/nginxLogs/*.log | grep "GET" | wc -l )${NC}"
  elif [ $way -eq 2 ]; then
    cat ../04/nginxLogs/*.log | grep "POST"
    echo -e "${GREEN}All entries sorted by response code (POST) - $(cat ../04/nginxLogs/*.log | grep "POST" | wc -l )${NC}"
  elif [ $way -eq 3 ]; then
    cat ../04/nginxLogs/*.log | grep "PUT"
    echo -e "${GREEN}All entries sorted by response code (PUT) - $(cat ../04/nginxLogs/*.log | grep "PUT" | wc -l )${NC}"
  elif [ $way -eq 4 ]; then
    cat ../04/nginxLogs/*.log | grep "PATCH"
    echo -e "${GREEN}All entries sorted by response code (PATCH) - $(cat ../04/nginxLogs/*.log | grep "PATCH" | wc -l )${NC}"
  elif [ $way -eq 5 ]; then
    cat ../04/nginxLogs/*.log | grep "DELETE"
    echo -e "${GREEN}All entries sorted by response code (DELETE) - $(cat ../04/nginxLogs/*.log | grep "DELETE" | wc -l )${NC}"
  else
    echo -e "${RED}Error! Invalid Input value.${NC}"
    exit 1
  fi
}

checkArguments() {
  if [ $# -ne 1 ]; then
    echo -e "${RED}Error! 1 argument was expected.${NC}"
    echo -e "${GREEN}Usage:  parse nginx logs <Way to parse>${NC}"
    echo -e "${GREEN}1) All entries sorted by response code${NC}"
    echo -e "${GREEN}2) All unique IPs found in the entries${NC}"
    echo -e "${GREEN}3) All requests with errors (response code - 4xx or 5xxx)${NC}"
    echo -e "${GREEN}4) All unique IPs found among the erroneous requests${NC}"
    exit 1
  fi

  if [ $1 -eq 1 ]; then
    sortByResponseCode
  elif [ $1 -eq 2 ]; then
    cat ../04/nginxLogs/*.log | awk '{print $1}' | sort -u -k 1,1.6
    echo -e "${GREEN}Total number of unique IP addresses - $(cat ../04/nginxLogs/*.log | awk '{print $1}' | sort -u -k 1,1.6 | wc -l )${NC}"
  elif [ $1 -eq 3 ]; then
    cat ../04/nginxLogs/*.log | awk '{if ($9 >=400) print $0}'
    echo -e "${GREEN}All requests with errors - $(cat ../04/nginxLogs/*.log | awk '{if ($9 >=400) print $0}' | wc -l )${NC}"
  elif [ $1 -eq 4 ]; then
    cat ../04/nginxLogs/*.log | awk '{if ($9 >=400) print $0}' | awk '{print $1}' | sort -u -k 1,1.6
    echo -e "${GREEN}All unique IPs found among the erroneous requests - $(cat ../04/nginxLogs/*.log | awk '{if ($9 >=400) print $0}' | awk '{print $1}' | sort -u -k 1,1.6 | wc -l )${NC}"
  else
    echo -e "${RED}Error! There're only 4 ways to parse logs (expected input from 1 to 4)${NC}"
  fi
}

checkArguments $@
