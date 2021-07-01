//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../StringUtils.sol";

contract StringUtilsMock {

    function addressToString(address _address) public pure returns (string memory) {
        return StringUtils.addressToString(_address);
    }
}