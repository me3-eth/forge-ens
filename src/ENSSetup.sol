// SPDX-License-Identifier: BSD-2-Clause-Patent
pragma solidity 0.8.10;

interface Cheatcodes {
  function getCode(string calldata) external returns(bytes memory);
}

interface PriceOracle {
  function price () external view returns(uint); // TODO
}

interface IETHRegistrarController {
  function rentPrice (string memory, uint) external view returns(uint);
  function valid (string memory) external pure returns(bool);
  function available (string memory) external view returns(bool);
  function makeCommitment (string memory, address, bytes32) external pure returns(bytes32);
  function makeCommitmentWithConfig (string memory, address, bytes32, address, address) external pure returns(bytes32);
  function commit (bytes32) external;
  function register (string calldata, address, uint, bytes32) external payable;
  function registerWithConfig (string memory, address, uint, bytes32, address, address) external payable;
  function renew (string calldata, uint) external payable;
  function supportsInterface (bytes3) external pure returns(bool);

  // onlyOwner functions
  function setPriceOracle (PriceOracle) external;
  function setCommitmentAges (uint, uint) external;
  function withdraw () external;
}

contract ENSSetup {
  Cheatcodes public cheats;

  constructor (Cheatcodes _cheats) {
    cheats = _cheats;
  }

  function deploy () public {
  }
}
