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
    assertEq(_ens.testNode(), 0x752abc59291a33b761efe24d65fe88c18bcb7a92fbad9670ce6e8e9e098ee3d1);
  }
}
