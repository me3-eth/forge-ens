#!/bin/bash

export $(grep -v '^#' .env | xargs)

addrs=( $(compgen -A variable | grep ENS_ADDR_) )
endpoint=https://api.etherscan.io/

for i in "${addrs[@]}"
do
  content=$(curl "${endpoint}/api?module=contract&action=getsourcecode&address=${!i}&apikey=${ETHERSCAN_API_KEY}")
  filename=$(jq -r '.result[0].ContractName' <<< "${content}").sol
  jq -r '.result[0].SourceCode' <<< "${content}" > src/$filename
done
