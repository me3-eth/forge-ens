#!/bin/bash

if [ ! -e .env ] ; then
  echo -e ".env file is missing. Please run\n\tcp .env.template .env\nand fill out missing data"
  exit 1
fi

echo -n "Dependency check..."
deps=0

for name in curl jq
do
  if ! command -v $name >/dev/null 2>&1 ; then
    echo -en "\nMISSING $name"
    deps=1
  fi
done

if [ $deps -ne 1 ] ; then
  echo 'OK'
else
  echo -e "\nInstall missing dependencies before continuing"
  exit 1
fi

export $(grep -v '^#' .env | xargs)

# Generate list of ENS related addresses, env var must start with ENS_ADDR_
addrs=( $(compgen -A variable | grep ENS_ADDR_) )
etherscanHost=https://api.etherscan.io
rpcHost=https://eth-mainnet.alchemyapi.io/v2

for i in "${addrs[@]}"
do
  # Download contract name and abi from Etherscan
  etherscanContent=$(curl "${etherscanHost}/api?module=contract&action=getsourcecode&address=${!i}&apikey=${ETHERSCAN_API_KEY}")
  filename=$(jq -r '.result[0].ContractName' <<< "${etherscanContent}").json
  abi=$(jq -r '.result[0].ABI' <<< "${etherscanContent}")

  # Download bytecode from RPC
  rpcReq=$(printf "{\"jsonrpc\":\"2.0\",\"method\":\"eth_getCode\",\"params\":[\"%s\",\"latest\"],\"id\":0}" "${!i}")
  rpcContent=$(curl "${rpcHost}/${ALCHEMY_API_KEY}" -XPOST -H "Content-Type: application/json" -d "${rpcReq}")
  bytecode=$(jq -r '.result' <<< "${rpcContent}")

  printf "{\"abi\":%s,\"bytecode\":\"%s\"}" "${abi}" "${bytecode}" > abis/$filename
done
echo "Contracts saved in abis/"
