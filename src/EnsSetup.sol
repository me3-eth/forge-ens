// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.10;

import "ds-test/test.sol";

import "ens-contracts/registry/ENS.sol";
import "ens-contracts/registry/ENSRegistry.sol";
import "ens-contracts/registry/ENSRegistryWithFallback.sol";
import "ens-contracts/ethregistrar/BaseRegistrarImplementation.sol";
import "ens-contracts/ethregistrar/ETHRegistrarController.sol";
import "ens-contracts/ethregistrar/PriceOracle.sol";
import "ens-contracts/resolvers/PublicResolver.sol";

contract MagicMoney is PriceOracle {
  function price(string calldata name, uint expires, uint duration) external view returns(uint) {
    return 5000;
  }
}

interface CheatCodes {
  function load (address, bytes32) external returns(bytes32);
  function prank (address) external;
  function store (address, bytes32, bytes32) external;
  function warp (uint256) external;
  function expectEmit (bool, bool, bool, bool) external;
}

contract EnsSetup is DSTest {
  CheatCodes public cheats = CheatCodes(HEVM_ADDRESS);

  ENSRegistry private _oldEns;

  PriceOracle public _priceOracle;
  ENSRegistryWithFallback public _ens;
  BaseRegistrarImplementation public _baseRegistrar;
  ETHRegistrarController public _defaultRegistrarController;
  PublicResolver public _defaultResolver;

  address constant public CONTROLLER_ADDR = 0x0000000000000000000000000000000000012345;

  // value taken from ENS contract: BulkRenewal @ 3b52784
  bytes32 public ethNode = 0x93cdeb708b7545dc668eb9280176169d1c33cfd8ed6f04690a0bcc88a93fc4ae;

  function labelhash (string memory node) public returns(bytes32) {
    return keccak256(bytes(node));
  }

  function setUp() public virtual {
    _oldEns = new ENSRegistry();
    _priceOracle = new MagicMoney();

    _ens = new ENSRegistryWithFallback(_oldEns);
    _defaultResolver = new PublicResolver(_ens);

    // Base registrar and registry config
    _baseRegistrar = new BaseRegistrarImplementation(_ens, ethNode);
    _baseRegistrar.addController(CONTROLLER_ADDR);
    _ens.setOwner(0x0, address(_baseRegistrar));

    // set .eth owner to BaseRegistrarImplementation
    uint256 ethOwnerSlot = uint256(keccak256(abi.encode(ethNode, 0)));
    cheats.store(address(_ens), bytes32(ethOwnerSlot), bytes32(uint256(uint160(address(_baseRegistrar)))));

    // make sure chain is at least 91 days old so that labels can be registered
    cheats.warp(_baseRegistrar.GRACE_PERIOD() + 1 days);

    // register testing.eth
    cheats.prank(CONTROLLER_ADDR);
    _baseRegistrar.register(uint256(labelhash("testing")), address(this), 86400);

    // use current public ENS registrar controller
    _defaultRegistrarController = new ETHRegistrarController(_baseRegistrar, _priceOracle, 60, 86400);
    _baseRegistrar.addController(address(_defaultRegistrarController));
  }
}
