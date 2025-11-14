//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title JsonWriter
 * @author Ben Meredith (@bmeredith)
 * @dev A library to generate RFC-7159 compliant JSON from within a smart contract.
 */
library JsonWriter {
    struct Json {
        bytes buffer;
        uint32 depth; // tracks nesting depth (0 = root)
        bool[32] needsComma; // per-depth comma flags
    }

    bytes1 constant BACKSLASH = "\\";
    bytes1 constant BACKSPACE = "\x08";
    bytes1 constant CARRIAGE_RETURN = "\r";
    bytes1 constant DOUBLE_QUOTE = '"';
    bytes1 constant FORM_FEED = "\x0c";
    bytes1 constant FORWARD_SLASH = "/";
    bytes1 constant HORIZONTAL_TAB = "\t";
    bytes1 constant NEWLINE = "\n";

    string constant TRUE = "true";
    string constant FALSE = "false";
    bytes1 constant OPEN_BRACE = "{";
    bytes1 constant CLOSED_BRACE = "}";
    bytes1 constant OPEN_BRACKET = "[";
    bytes1 constant CLOSED_BRACKET = "]";
    bytes1 constant COMMA = ",";

    int256 constant MAX_INT256 = type(int256).max;
    bytes16 constant HEX_DIGITS = "0123456789abcdef";
    bytes16 constant HEX_CAPITAL = "0123456789ABCDEF";

    /**
     * @dev Writes the beginning of a JSON array.
     */
    function writeStartArray(Json memory json) internal pure returns (Json memory) {
        _beginValue(json);
        _append1(json, OPEN_BRACKET);
        _enter(json);
        return json;
    }

    /**
     * @dev Writes the beginning of a JSON array with a property name as the key.
     */
    function writeStartArray(Json memory json, string memory propertyName) internal pure returns (Json memory) {
        _beginValue(json);
        _append(json, abi.encodePacked('"', propertyName, '": ', OPEN_BRACKET));
        _enter(json);
        return json;
    }

    /**
     * @dev Writes the beginning of a JSON object.
     */
    function writeStartObject(Json memory json) internal pure returns (Json memory) {
        _beginValue(json);
        _append1(json, OPEN_BRACE);
        _enter(json);
        return json;
    }

    /**
     * @dev Writes the beginning of a JSON object with a property name as the key.
     */
    function writeStartObject(Json memory json, string memory propertyName) internal pure returns (Json memory) {
        _beginValue(json);
        _append(json, abi.encodePacked('"', propertyName, '": ', OPEN_BRACE));
        _enter(json);
        return json;
    }

    /**
     * @dev Writes the end of a JSON array.
     */
    function writeEndArray(Json memory json) internal pure returns (Json memory) {
        _append1(json, CLOSED_BRACKET);
        _exit(json);
        return json;
    }

    /**
     * @dev Writes the end of a JSON object.
     */
    function writeEndObject(Json memory json) internal pure returns (Json memory) {
        _append1(json, CLOSED_BRACE);
        _exit(json);
        return json;
    }

    /**
     * @dev Writes the property name and address value (as a JSON string) as part of a name/value pair of a JSON object.
     */
    function writeAddressProperty(Json memory json, string memory propertyName, address value)
        internal
        pure
        returns (Json memory)
    {
        _beginValue(json);
        _append(json, abi.encodePacked('"', propertyName, '": "', addressToString(value), '"'));
        _markValueWritten(json);
        return json;
    }

    /**
     * @dev Writes the address value (as a JSON string) as an element of a JSON array.
     */
    function writeAddressValue(Json memory json, address value) internal pure returns (Json memory) {
        _beginValue(json);
        _append(json, abi.encodePacked('"', addressToString(value), '"'));
        _markValueWritten(json);
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
        _beginValue(json);
        string memory strValue = value ? TRUE : FALSE;
        _append(json, abi.encodePacked('"', propertyName, '": ', strValue));
        _markValueWritten(json);
        return json;
    }

    /**
     * @dev Writes the boolean value (as a JSON literal "true" or "false") as an element of a JSON array.
     */
    function writeBooleanValue(Json memory json, bool value) internal pure returns (Json memory) {
        _beginValue(json);
        string memory strValue = value ? TRUE : FALSE;
        _append(json, abi.encodePacked(strValue));
        _markValueWritten(json);
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
        _beginValue(json);
        _append(json, abi.encodePacked('"', propertyName, '": ', intToString(value)));
        _markValueWritten(json);
        return json;
    }

    /**
     * @dev Writes the int value (as a JSON number) as an element of a JSON array.
     */
    function writeIntValue(Json memory json, int256 value) internal pure returns (Json memory) {
        _beginValue(json);
        _append(json, abi.encodePacked(intToString(value)));
        _markValueWritten(json);
        return json;
    }

    /**
     * @dev Writes the property name and value of null as part of a name/value pair of a JSON object.
     */
    function writeNullProperty(Json memory json, string memory propertyName) internal pure returns (Json memory) {
        _beginValue(json);
        _append(json, abi.encodePacked('"', propertyName, '": null'));
        _markValueWritten(json);
        return json;
    }

    /**
     * @dev Writes the value of null as an element of a JSON array.
     */
    function writeNullValue(Json memory json) internal pure returns (Json memory) {
        _beginValue(json);
        _append(json, "null");
        _markValueWritten(json);
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
        _beginValue(json);
        _append(json, abi.encodePacked('"', propertyName, '": "', escapeJsonString(value), '"'));
        _markValueWritten(json);
        return json;
    }

    /**
     * @dev Writes the string text value (as a JSON string) as an element of a JSON array.
     */
    function writeStringValue(Json memory json, string memory value) internal pure returns (Json memory) {
        _beginValue(json);
        _append(json, abi.encodePacked('"', escapeJsonString(value), '"'));
        _markValueWritten(json);
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
        _beginValue(json);
        _append(json, abi.encodePacked('"', propertyName, '": ', uintToString(value)));
        _markValueWritten(json);
        return json;
    }

    /**
     * @dev Writes the uint value (as a JSON number) as an element of a JSON array.
     */
    function writeUintValue(Json memory json, uint256 value) internal pure returns (Json memory) {
        _beginValue(json);
        _append(json, abi.encodePacked(uintToString(value)));
        _markValueWritten(json);
        return json;
    }

    /**
     * @dev Escapes any characters that required by JSON to be escaped.
     */
    function escapeJsonString(string memory value) private pure returns (string memory str) {
        bytes memory b = bytes(value);
        bool foundEscapeChars;

        for (uint256 i; i < b.length;) {
            if (b[i] == BACKSLASH) {
                foundEscapeChars = true;
                break;
            } else if (b[i] == DOUBLE_QUOTE) {
                foundEscapeChars = true;
                break;
            } else if (b[i] == FORWARD_SLASH) {
                foundEscapeChars = true;
                break;
            } else if (b[i] == HORIZONTAL_TAB) {
                foundEscapeChars = true;
                break;
            } else if (b[i] == FORM_FEED) {
                foundEscapeChars = true;
                break;
            } else if (b[i] == NEWLINE) {
                foundEscapeChars = true;
                break;
            } else if (b[i] == CARRIAGE_RETURN) {
                foundEscapeChars = true;
                break;
            } else if (b[i] == BACKSPACE) {
                foundEscapeChars = true;
                break;
            }

            unchecked {
                ++i;
            }
        }

        if (!foundEscapeChars) {
            return value;
        }

        for (uint256 i; i < b.length;) {
            if (b[i] == BACKSLASH) {
                str = string(abi.encodePacked(str, "\\\\"));
            } else if (b[i] == DOUBLE_QUOTE) {
                str = string(abi.encodePacked(str, '\\"'));
            } else if (b[i] == FORWARD_SLASH) {
                str = string(abi.encodePacked(str, "\\/"));
            } else if (b[i] == HORIZONTAL_TAB) {
                str = string(abi.encodePacked(str, "\\t"));
            } else if (b[i] == FORM_FEED) {
                str = string(abi.encodePacked(str, "\\f"));
            } else if (b[i] == NEWLINE) {
                str = string(abi.encodePacked(str, "\\n"));
            } else if (b[i] == CARRIAGE_RETURN) {
                str = string(abi.encodePacked(str, "\\r"));
            } else if (b[i] == BACKSPACE) {
                str = string(abi.encodePacked(str, "\\b"));
            } else {
                str = string(abi.encodePacked(str, b[i]));
            }

            unchecked {
                ++i;
            }
        }

        return str;
    }

    function _append(Json memory json, bytes memory data) private pure {
        json.buffer = abi.encodePacked(json.buffer, data);
    }

    function _append1(Json memory json, bytes1 b) private pure {
        json.buffer = abi.encodePacked(json.buffer, b);
    }

    /**
     * @dev Called before writing a *value* at the current depth.
     *      If this is not the first value at this depth, adds a comma.
     */
    function _beginValue(Json memory json) private pure {
        if (json.depth == 0) {
            return;
        }

        uint32 level = json.depth - 1;
        if (json.needsComma[level]) {
            _append1(json, COMMA);
        }
    }

    /**
     * @dev Flags that at least one value has been written at this depth to mark if a comma is needed.
     */
    function _markValueWritten(Json memory json) private pure {
        if (json.depth == 0) {
            return;
        }

        uint32 level = json.depth - 1;
        json.needsComma[level] = true;
    }

    /**
     * @dev Called when entering a JSON object/array.
     */
    function _enter(Json memory json) private pure {
        json.depth++;
        require(json.depth <= 32, "JsonWriter: max depth exceeded");
        json.needsComma[json.depth - 1] = false;
    }

    /**
     * @dev Called when exiting a JSON object/array.
     */
    function _exit(Json memory json) private pure {
        require(json.depth > 0, "JsonWriter: unmatched end");
        json.depth--;
        _markValueWritten(json);
    }

    /**
     * @dev Finalizes the JSON builder and returns the JSON string.
     *      Reverts if there are unclosed JSON objects/arrays.
     */
    function toString(Json memory json) internal pure returns (string memory) {
        require(json.depth == 0, "JsonWriter: unbalanced JSON");
        return string(json.buffer);
    }

    /**
     * @dev Converts an address to a string.
     */
    function addressToString(address _address) internal pure returns (string memory) {
        bytes memory lowercase = new bytes(40);
        uint160 currentAddressValue = uint160(_address);

        for (uint256 i; i < 40;) {
            lowercase[39 - i] = HEX_DIGITS[currentAddressValue & 0xf];
            currentAddressValue >>= 4;

            unchecked {
                ++i;
            }
        }
        bytes32 hashedAddress = keccak256(abi.encodePacked(lowercase));

        bytes memory buffer = new bytes(42);
        buffer[0] = "0";
        buffer[1] = "x";

        uint160 addressValue = uint160(_address);
        uint160 hashValue = uint160(bytes20(hashedAddress));
        for (uint256 i = 41; i > 1;) {
            uint256 hashIndex = hashValue & 0xf;
            if (hashIndex > 7) {
                buffer[i] = HEX_CAPITAL[addressValue & 0xf];
            } else {
                buffer[i] = HEX_DIGITS[addressValue & 0xf];
            }
            addressValue >>= 4;
            hashValue >>= 4;

            unchecked {
                --i;
            }
        }

        return string(abi.encodePacked(buffer));
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
