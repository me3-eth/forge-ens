# forge-ens

ENS contracts that are forge compatible.

## Why?

Maybe it exists somewhere but `ensdomains/ens-contracts` does not have the currently deployed ENS contracts, even if you roll back to the first commit. I've tried searching the rest of the Github org without success.

## What

1. a bash script to download the contracts deployed at given addresses
2. these contracts are committed to the repo so that you can just include this without fuss
3. a setup contract so you can just get to business

## Usage

With `forge`:

```sh
forge install me3-eth/forge-ens
```

## Development

1. Download dependencies:
    ```sh
    # arch
    pacman -S jq curl
    
    # debian
    apt install jq curl
    ```
2. Get yourself an [Etherscan account](https://docs.etherscan.io/getting-started/creating-an-account) and [Etherscan API key](https://docs.etherscan.io/getting-started/viewing-api-usage-statistics)
3. Make your own copy of the env vars
    ```sh
    cp .env.template .env
    ```
4. Update the `ETHERSCAN_API_KEY` value with your API key
5. Profit

### Updating the contracts

The **get-ens.sh** script will download the contracts that match the addresses in the **.env** file.


## License clarifications

ENS contracts are covered under whatever license they have listed in the **.sol** files.

Shell script and setup contract are whatever **LICENSE** file says.
