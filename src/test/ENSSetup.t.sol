// SPDX-License-Identifier: BSD-2-Clause-Patent
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "../ENSSetup.sol";

contract ENSSetupTest is DSTest {
  ENSSetup public ens = new ENSSetup();

  function setUp() public {
    ens.deploy();
  }

  function testExample() public {
    log_named_address("registry addr", address(ens.registry()));
    assertTrue(true);
  }
}
