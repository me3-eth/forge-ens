# forge-ens

Forge-compatible ENS contracts, attempting to mirror mainnet as best as possible.

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
