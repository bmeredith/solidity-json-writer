//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title JsonWriter
 * @author Ben Meredith (@bmeredith)
 * @dev A library to generate RFC-7159 compliant JSON from within a smart contract.
 */
library JsonWriter {
    error UnbalancedJSON();

    struct Json {
        int256 depthBitTracker;
        bytes buffer;
    }

    bytes1 constant BACKSLASH = "\\";
    bytes1 constant BACKSPACE = "\x08";
    bytes1 constant CARRIAGE_RETURN = "\r";
    bytes1 constant DOUBLE_QUOTE = '"';
    bytes1 constant FORM_FEED = "\x0c";
    bytes1 constant HORIZONTAL_TAB = "\t";
    bytes1 constant NEWLINE = "\n";

    string constant TRUE = "true";
    string constant FALSE = "false";
    bytes1 constant OPEN_BRACE = "{";
    bytes1 constant CLOSED_BRACE = "}";
    bytes1 constant OPEN_BRACKET = "[";
    bytes1 constant CLOSED_BRACKET = "]";
    bytes1 constant COMMA = ",";

    uint8 constant ADDRESS_LENGTH = 20;
    int256 constant MAX_INT256 = type(int256).max;
    bytes16 constant HEX_DIGITS = "0123456789abcdef";
    bytes16 constant HEX_CAPITAL = "0123456789ABCDEF";

    /**
     * @dev Writes the beginning of a JSON array.
     */
    function writeStartArray(Json memory json) internal pure returns (Json memory) {
        return writeStart(json, OPEN_BRACKET);
    }

    /**
     * @dev Writes the beginning of a JSON array with a property name as the key.
     */
    function writeStartArray(Json memory json, string memory propertyName) internal pure returns (Json memory) {
        return writeStart(json, propertyName, OPEN_BRACKET);
    }

    /**
     * @dev Writes the beginning of a JSON object.
     */
    function writeStartObject(Json memory json) internal pure returns (Json memory) {
        return writeStart(json, OPEN_BRACE);
    }

    /**
     * @dev Writes the beginning of a JSON object with a property name as the key.
     */
    function writeStartObject(Json memory json, string memory propertyName) internal pure returns (Json memory) {
        return writeStart(json, propertyName, OPEN_BRACE);
    }

    /**
     * @dev Writes the end of a JSON array.
     */
    function writeEndArray(Json memory json) internal pure returns (Json memory) {
        return writeEnd(json, CLOSED_BRACKET);
    }

    /**
     * @dev Writes the end of a JSON object.
     */
    function writeEndObject(Json memory json) internal pure returns (Json memory) {
        return writeEnd(json, CLOSED_BRACE);
    }

    /**
     * @dev Writes the property name and address value (as a JSON string) as part of a name/value pair of a JSON object.
     */
    function writeAddressProperty(Json memory json, string memory propertyName, address value)
        internal
        pure
        returns (Json memory)
    {
        string memory addr = addressToString(value);
        if (json.depthBitTracker < 0) {
            json.buffer = abi.encodePacked(json.buffer, COMMA, '"', propertyName, '": "', addr, '"');
        } else {
            json.buffer = abi.encodePacked(json.buffer, '"', propertyName, '": "', addr, '"');
        }

        json.depthBitTracker = setListSeparatorFlag(json);
        return json;
    }

    /**
     * @dev Writes the address value (as a JSON string) as an element of a JSON array.
     */
    function writeAddressValue(Json memory json, address value) internal pure returns (Json memory) {
        string memory addr = addressToString(value);
        if (json.depthBitTracker < 0) {
            json.buffer = abi.encodePacked(json.buffer, COMMA, '"', addr, '"');
        } else {
            json.buffer = abi.encodePacked(json.buffer, '"', addr, '"');
        }

        json.depthBitTracker = setListSeparatorFlag(json);
        return json;
    }

    /**
     * @dev Writes the property name and boolean value (as a JSON literal "true" or "false") as part of a name/value pair of a JSON object.
     */
    function writeBooleanProperty(Json memory json, string memory propertyName, bool value)
        internal
        pure
        returns (Json memory)
    {
        string memory strValue = value ? TRUE : FALSE;
        if (json.depthBitTracker < 0) {
            json.buffer = abi.encodePacked(json.buffer, COMMA, '"', propertyName, '": ', strValue);
        } else {
            json.buffer = abi.encodePacked(json.buffer, '"', propertyName, '": ', strValue);
        }

        json.depthBitTracker = setListSeparatorFlag(json);
        return json;
    }

    /**
     * @dev Writes the boolean value (as a JSON literal "true" or "false") as an element of a JSON array.
     */
    function writeBooleanValue(Json memory json, bool value) internal pure returns (Json memory) {
        string memory strValue = value ? TRUE : FALSE;
        if (json.depthBitTracker < 0) {
            json.buffer = abi.encodePacked(json.buffer, COMMA, strValue);
        } else {
            json.buffer = abi.encodePacked(json.buffer, strValue);
        }

        json.depthBitTracker = setListSeparatorFlag(json);
        return json;
    }

    /**
     * @dev Writes the property name and int value (as a JSON number) as part of a name/value pair of a JSON object.
     */
    function writeIntProperty(Json memory json, string memory propertyName, int256 value)
        internal
        pure
        returns (Json memory)
    {
        string memory strValue = intToString(value);
        if (json.depthBitTracker < 0) {
            json.buffer =
                abi.encodePacked(json.buffer, COMMA, '"', propertyName, '": ', strValue);
        } else {
            json.buffer = abi.encodePacked(json.buffer, '"', propertyName, '": ', strValue);
        }

        json.depthBitTracker = setListSeparatorFlag(json);
        return json;
    }

    /**
     * @dev Writes the int value (as a JSON number) as an element of a JSON array.
     */
    function writeIntValue(Json memory json, int256 value) internal pure returns (Json memory) {
        string memory strValue = intToString(value);
        if (json.depthBitTracker < 0) {
            json.buffer = abi.encodePacked(json.buffer, COMMA, strValue);
        } else {
            json.buffer = abi.encodePacked(json.buffer, strValue);
        }

        json.depthBitTracker = setListSeparatorFlag(json);
        return json;
    }

    /**
     * @dev Writes the property name and value of null as part of a name/value pair of a JSON object.
     */
    function writeNullProperty(Json memory json, string memory propertyName) internal pure returns (Json memory) {
        if (json.depthBitTracker < 0) {
            json.buffer = abi.encodePacked(json.buffer, COMMA, '"', propertyName, '": null');
        } else {
            json.buffer = abi.encodePacked(json.buffer, '"', propertyName, '": null');
        }

        json.depthBitTracker = setListSeparatorFlag(json);
        return json;
    }

    /**
     * @dev Writes the value of null as an element of a JSON array.
     */
    function writeNullValue(Json memory json) internal pure returns (Json memory) {
        if (json.depthBitTracker < 0) {
            json.buffer = abi.encodePacked(json.buffer, COMMA, "null");
        } else {
            json.buffer = abi.encodePacked(json.buffer, "null");
        }

        json.depthBitTracker = setListSeparatorFlag(json);
        return json;
    }

    /**
     * @dev Writes the property name and string text value (as a JSON string) as part of a name/value pair of a JSON object.
     */
    function writeStringProperty(Json memory json, string memory propertyName, string memory value)
        internal
        pure
        returns (Json memory)
    {
        string memory jsonEscapedString = escapeJsonString(value);
        if (json.depthBitTracker < 0) {
            json.buffer = abi.encodePacked(json.buffer, COMMA, '"', propertyName, '": "', jsonEscapedString, '"');
        } else {
            json.buffer = abi.encodePacked(json.buffer, '"', propertyName, '": "', jsonEscapedString, '"');
        }

        json.depthBitTracker = setListSeparatorFlag(json);
        return json;
    }

    /**
     * @dev Writes the string text value (as a JSON string) as an element of a JSON array.
     */
    function writeStringValue(Json memory json, string memory value) internal pure returns (Json memory) {
        string memory jsonEscapedString = escapeJsonString(value);
        if (json.depthBitTracker < 0) {
            json.buffer = abi.encodePacked(json.buffer, COMMA, '"', jsonEscapedString, '"');
        } else {
            json.buffer = abi.encodePacked(json.buffer, '"', jsonEscapedString, '"');
        }

        json.depthBitTracker = setListSeparatorFlag(json);
        return json;
    }

    /**
     * @dev Writes the property name and uint value (as a JSON number) as part of a name/value pair of a JSON object.
     */
    function writeUintProperty(Json memory json, string memory propertyName, uint256 value)
        internal
        pure
        returns (Json memory)
    {
        string memory strValue = uintToString(value);
        if (json.depthBitTracker < 0) {
            json.buffer = abi.encodePacked(json.buffer, COMMA, '"', propertyName, '": ', strValue);
        } else {
            json.buffer = abi.encodePacked(json.buffer, '"', propertyName, '": ', strValue);
        }

        json.depthBitTracker = setListSeparatorFlag(json);
        return json;
    }

    /**
     * @dev Writes the uint value (as a JSON number) as an element of a JSON array.
     */
    function writeUintValue(Json memory json, uint256 value) internal pure returns (Json memory) {
        string memory strValue = uintToString(value);
        if (json.depthBitTracker < 0) {
            json.buffer = abi.encodePacked(json.buffer, COMMA, strValue);
        } else {
            json.buffer = abi.encodePacked(json.buffer, strValue);
        }

        json.depthBitTracker = setListSeparatorFlag(json);
        return json;
    }

    /**
     * @dev Writes the beginning of a JSON array or object based on the token parameter.
     */
    function writeStart(Json memory json, bytes1 token) private pure returns (Json memory) {
        if (json.depthBitTracker < 0) {
            json.buffer = abi.encodePacked(json.buffer, COMMA, token);
        } else {
            json.buffer = abi.encodePacked(json.buffer, token);
        }

        json.depthBitTracker &= MAX_INT256;
        json.depthBitTracker++;

        return json;
    }

    /**
     * @dev Writes the beginning of a JSON array or object based on the token parameter with a property name as the key.
     */
    function writeStart(Json memory json, string memory propertyName, bytes1 token) private pure returns (Json memory) {
        if (json.depthBitTracker < 0) {
            json.buffer = abi.encodePacked(json.buffer, COMMA, '"', propertyName, '": ', token);
        } else {
            json.buffer = abi.encodePacked(json.buffer, '"', propertyName, '": ', token);
        }

        json.depthBitTracker &= MAX_INT256;
        json.depthBitTracker++;

        return json;
    }

    /**
     * @dev Writes the end of a JSON array or object based on the token parameter.
     */
    function writeEnd(Json memory json, bytes1 token) private pure returns (Json memory) {
        json.buffer = abi.encodePacked(json.buffer, token);
        json.depthBitTracker = setListSeparatorFlag(json);

        if (getCurrentDepth(json) != 0) {
            json.depthBitTracker--;
        }

        return json;
    }

    /**
     * @dev Finalizes the JSON builder and returns the JSON string.
     *      Reverts if there are unclosed JSON objects/arrays.
     */
    function toString(Json memory json) internal pure returns (string memory) {
        if (getCurrentDepth(json) != 0) {
            revert UnbalancedJSON();
        }

        return string(json.buffer);
    }

    /**
     * @dev Escapes any characters that required by JSON to be escaped.
     */
    function escapeJsonString(string memory value) private pure returns (string memory str) {
        bytes memory b = bytes(value);
        uint256 extra;
        for (uint256 i; i < b.length; ) {
            bytes1 c = b[i];
            if (
                c == BACKSLASH ||
                c == DOUBLE_QUOTE ||
                c == HORIZONTAL_TAB ||
                c == FORM_FEED ||
                c == NEWLINE ||
                c == CARRIAGE_RETURN ||
                c == BACKSPACE
            ) {
                extra += 1; // e.g. `\n` is '\' + 'n' instead of single byte
            }
            unchecked { ++i; }
        }

        if (extra == 0) {
            return value;
        }

        bytes memory out = new bytes(b.length + extra);
        uint256 j;

        for (uint256 i; i < b.length; ) {
            bytes1 c = b[i];

            if (c == BACKSLASH) {
                out[j++] = "\\";
                out[j++] = "\\";
            } else if (c == DOUBLE_QUOTE) {
                out[j++] = "\\";
                out[j++] = '"';
            } else if (c == HORIZONTAL_TAB) {
                out[j++] = "\\";
                out[j++] = "t";
            } else if (c == FORM_FEED) {
                out[j++] = "\\";
                out[j++] = "f";
            } else if (c == NEWLINE) {
                out[j++] = "\\";
                out[j++] = "n";
            } else if (c == CARRIAGE_RETURN) {
                out[j++] = "\\";
                out[j++] = "r";
            } else if (c == BACKSPACE) {
                out[j++] = "\\";
                out[j++] = "b";
            } else {
                out[j++] = c;
            }

            unchecked { ++i; }
        }

        return string(out);
    }

    /**
     * @dev Tracks the recursive depth of the nested objects / arrays within the JSON text
     * written so far. This provides the depth of the current token.
     */
    function getCurrentDepth(Json memory json) private pure returns (int256) {
        return json.depthBitTracker & MAX_INT256;
    }

    /**
     * @dev The highest order bit of json.depthBitTracker is used to discern whether we are writing the first item in a list or not.
     * if (json.depthBitTracker >> 255) == 1, add a list separator before writing the item
     * else, no list separator is needed since we are writing the first item.
     */
    function setListSeparatorFlag(Json memory json) private pure returns (int256) {
        return json.depthBitTracker | (int256(1) << 255);
    }


    /**
     * @dev Converts an address to a string. Based off of OZ's Strings.sol implementation.
     */
    function addressToString(address addr) internal pure returns (string memory) {
        bytes memory buffer = bytes(toHexString(addr));

        // hash the hex part of buffer (skip length + 2 bytes, length 40)
        uint256 hashValue;
        assembly ("memory-safe") {
            hashValue := shr(96, keccak256(add(buffer, 0x22), 40))
        }

        for (uint256 i = 41; i > 1; --i) {
            // possible values for buffer[i] are 48 (0) to 57 (9) and 97 (a) to 102 (f)
            if (hashValue & 0xf > 7 && uint8(buffer[i]) > 96) {
                // case shift by xoring with 0x20
                buffer[i] ^= 0x20;
            }
            hashValue >>= 4;
        }
        return string(buffer);
    }

    function toHexString(address value) internal pure returns (string memory) {
        uint256 localValue = uint256(uint160(value));

        bytes memory buffer = new bytes(2 * ADDRESS_LENGTH + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * ADDRESS_LENGTH + 1; i > 1; --i) {
            buffer[i] = HEX_DIGITS[localValue & 0xf];
            localValue >>= 4;
        }
        
        return string(buffer);
    }

    /**
     * @dev Converts an int to a string.
     */
    function intToString(int256 i) internal pure returns (string memory) {
        if (i == 0) {
            return "0";
        }

        if (i == type(int256).min) {
            // hard-coded since int256 min value can't be converted to unsigned
            return "-57896044618658097711785492504343953926634992332820282019728792003956564819968";
        }

        bool negative = i < 0;
        uint256 len;
        uint256 j;
        if (!negative) {
            j = uint256(i);
        } else {
            j = uint256(-i);
            ++len; // make room for '-' sign
        }

        uint256 l = j;
        while (j != 0) {
            len++;
            j /= 10;
        }

        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (l != 0) {
            bstr[--k] = bytes1((48 + uint8(l - (l / 10) * 10)));
            l /= 10;
        }

        if (negative) {
            bstr[0] = "-"; // prepend '-'
        }

        return string(bstr);
    }

    /**
     * @dev Converts a uint to a string.
     */
    function uintToString(uint256 _i) internal pure returns (string memory) {
        if (_i == 0) {
            return "0";
        }

        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }

        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (_i != 0) {
            bstr[--k] = bytes1((48 + uint8(_i - (_i / 10) * 10)));
            _i /= 10;
        }

        return string(bstr);
    }
}
