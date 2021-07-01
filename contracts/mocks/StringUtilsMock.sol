//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../StringUtils.sol";

contract StringUtilsMock {

    function addressToString(address _address) public pure returns (string memory) {
        return StringUtils.addressToString(_address);
    }

    function intToString(int _i) public pure returns (string memory) {
        return StringUtils.intToString(_i);
    }

    function uintToString(uint _i) public pure returns (string memory) {
        return StringUtils.uintToString(_i);
    }
}