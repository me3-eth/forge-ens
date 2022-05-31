// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.10;

import "forge-std/Test.sol";
import { EnsSetup } from  "../EnsSetup.sol";

contract TestEnsSetup is Test {
  EnsSetup private _ens;

  function setUp() public virtual {
    _ens = new EnsSetup();
    _ens.setUp();
  }

  function testTestNodeGenerated () public {
    assertEq32(_ens.demoNode(), 0xe16d706abaf956b7ea28cbd2c8fdee2870106a93d02046daf8c54bc46bf61cbf);
  }
}
