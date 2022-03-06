// SPDX-License-Identifier: BSD-2-Clause-Patent
pragma solidity 0.8.10;

import "enscontracts/BaseRegistrarImplementation.sol";
import "enscontracts/ENSRegistryWithFallback.sol";
import "enscontracts/PublicResolver.sol";

contract ENSSetup {
  ENSRegistryWithFallback public registry;
  BaseRegistrarImplementation public registrar;
  PublicResolver public resolver;

  function deploy () {
    registry = new ENSRegistryWithFallback();
  }
}
