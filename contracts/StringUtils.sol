//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library StringUtils {

    function uintToString(uint _i) internal pure returns (string memory) {
        if (_i == 0) {
            return "0";
        }

        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }

        return string(bstr);
    }

    function intToString(int i) internal pure returns (string memory) {
        if (i == 0) { 
            return "0";
        }

        if (i == type(int256).min) {
            return "-57896044618658097711785492504343953926634992332820282019728792003956564819968"; // hard-coded since int256 min can't be converted to unsigned
        }

        bool negative = i < 0;
        uint j = uint(negative ? -i : i);
        uint l = j;
        uint len;
        while (j != 0){
            len++;
            j /= 10;
        }

        if (negative) {
             ++len;  // make room for '-' sign
        }

        bytes memory bstr = new bytes(len);
        uint k = len;
        while (l != 0){
            uint8 temp = (48 + uint8(l - l / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[--k] = b1;
            l /= 10;
        }

        if (negative) {
            bstr[0] = '-'; // prepend '-'
        }

        return string(bstr);
    }

    function addressToString(address _address) internal pure returns (string memory) {
        bytes32 value = bytes32(uint256(uint160(_address)));
        bytes memory alphabet = "0123456789abcdef";

        bytes memory str = new bytes(42);
        str[0] = '0';
        str[1] = 'x';
        for (uint256 i = 0; i < 20; i++) {
            str[2+i*2] = alphabet[uint8(value[i + 12] >> 4)];
            str[3+i*2] = alphabet[uint8(value[i + 12] & 0x0f)];
        }

        return string(str);
    }
    
    function strConcat(string memory a, string memory b, string memory c, string memory d, string memory e, string memory f) internal pure returns (string memory) {
        return string(abi.encodePacked(a, b, c, d, e, f));
    }
    
    function strConcat(string memory a, string memory b, string memory c, string memory d, string memory e) internal pure returns (string memory) {
        return string(abi.encodePacked(a, b, c, d, e));
    }
    
    function strConcat(string memory a, string memory b, string memory c, string memory d) internal pure returns (string memory) {
        return string(abi.encodePacked(a, b, c, d));
    }
    
    function strConcat(string memory a, string memory b, string memory c) internal pure returns (string memory) {
        return string(abi.encodePacked(a, b, c));
    }
    
    function strConcat(string memory a, string memory b) internal pure returns (string memory) {
        return string(abi.encodePacked(a, b));
    }
}