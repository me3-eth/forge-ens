# forge-ens

Forge-compatible ENS contracts, attempting to mirror mainnet as best as possible.

_NOTE:_ If you are doing any time-based work, this pushes your chain aheah 91 days. This is to work with an internal check in `BaseRegistrarImplementation.sol` from ENS.

## Usage

Install:

```sh
forge install me3-eth/forge-ens
```

Use in your tests:

```solidity
import { EnsSetup } from "forge-ens/EnsSetup.sol";

contract TestSomething is EnsSetup {
  function setUp () public {
    super.setUp();

    // create yo.demo.eth with PublicResolver at a 1yr TTL
    _ens.setSubnodeRecord(demoNode, labelhash("yo"), address(this), address(_defaultResolver), 86400);

    // create someone.eth via prank
    vm.prank(CONTROLLER_ADDR)
    _baseRegistrar.register(uint256(labelhash("someone")), address(this), 86400);

    // create somewhere.eth the standard way
    bytes32 commitment = _defaultRegistrarController.commit(keccak256(bytes("whatever")));
    vm.warp(block.timestamp + 60); // minimum commitment age
    _defaultRegistrarController.register{value: 5000}("somewhere", address(this), 86400, commitment);
  }
}
```

`EnsSetup` inherits the `Test` contract from `foundry-rs/forge-std` so you have access to all assertions and the VM.

### Exposed variables and functions

#### `labelhash (string memory node) returns(bytes32)`

Please see <https://docs.ens.domains/contract-api-reference/name-processing#hashing-names>

#### `namehash (bytes32 node, bytes32 labelhash) returns(bytes32)`

Please see <https://docs.ens.domains/contract-api-reference/name-processing#hashing-names>

#### `CONTROLLER_ADDR`

The controller of the base registrar

#### `ethNode`

Matches the base `.eth` node hash from [`BulkRenewal.sol`](https://github.com/ensdomains/ethregistrar/blob/eb81e93861871122044dace61ca5a99b47257520/contracts/BulkRenewal.sol#L9)

#### `demoNode`

During `setUp()`, this will be created as `demo.eth`

#### `_ens`

An implementation of the ENS registry, specifically `ENSRegistryWithFallback.sol`

#### `_baseRegistrar`

Exposing `BaseRegistrarImplementation.sol` for doing additional ENS setup. For example:

```solidity
// create someone.eth via prank, making the owner the calling contract
vm.prank(CONTROLLER_ADDR)
_baseRegistrar.register(uint256(labelhash("someone")), address(this), 86400);
```

#### `_priceOracle`

Simple price oracle used by the default registrar.

#### `_defaultRegistrarController`

The registrar that users/contracts will interact with in production. For example:

```solidity
// create somewhere.eth the standard way, calling contract becomes the owner
bytes32 commitment = _defaultRegistrarController.commit(keccak256(bytes("notimportant")));
vm.warp(block.timestamp + 60); // move forward in time for the minimum commitment age
uint256 cost = _priceOracle.price();
_defaultRegistrarController.register{value: cost}("somewhere", address(this), 86400, commitment);
```

## Why

The process of setting up the entire ENS stack can be difficult. This contract
provides all of the pieces to interact with ENS in tests.

You could also just fork mainnet.

## Roadmap

### Use deployed contracts

The ENS repository doesn't exactly match the deployed contracts. We get close by
going far enough back in history. It would be more accurate to use the deployed
contracts as a basis for testing.

### Versioning

The ENS team is working on new contracts, a big one being `NameWrapper`.
Versioning individual contracts would allow for testing compatibility across a
variety of deployed contracts.

## License clarifications

ENS contracts are covered under whatever license they have listed in the **.sol** files.

Shell script and setup contract are whatever **LICENSE** file says.
