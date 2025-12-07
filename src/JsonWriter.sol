//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title JsonWriter 2.0.0
 * @author Ben Meredith (@bmeredith)
 * @dev A library to generate RFC-7159 compliant JSON from within a smart contract.
 */
library JsonWriter {
    error UnbalancedJSON();

    struct Json {
        bytes buffer;
        uint256 cursor; // next write index
        uint256 capacity; // allocated length
        uint256 depth; // lower bits = depth, high bit = needs comma
    }

    uint256 constant CTRL_CHARS_MASK =
        (uint256(1) << uint8(BACKSPACE)) | 
        (uint256(1) << uint8(HORIZONTAL_TAB)) | 
        (uint256(1) << uint8(NEWLINE)) | 
        (uint256(1) << uint8(FORM_FEED)) | 
        (uint256(1) << uint8(CARRIAGE_RETURN));

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
    uint256 constant INITIAL_CAPACITY = 512;
    uint256 constant COMMA_FLAG = 1 << 8;
    uint256 constant DEPTH_MASK = 0xFF;
    bytes16 constant HEX_DIGITS = "0123456789abcdef";
    bytes16 constant HEX_CAPITAL = "0123456789ABCDEF";

    /**
     * @dev Writes the beginning of a JSON array.
     */
    function writeStartArray(Json memory json) internal pure returns (Json memory) {
        _ensureInit(json);
        _writeCommaIfNeeded(json);
        _writeByte(json, OPEN_BRACKET);

        json.depth = (json.depth & COMMA_FLAG) | ((json.depth & ~COMMA_FLAG) + 1);
        json.depth &= ~COMMA_FLAG;
        return json;
    }

    /**
     * @dev Writes the beginning of a JSON array with a property name as the key.
     */
    function writeStartArray(Json memory json, string memory propertyName) internal pure returns (Json memory) {
        _writeCommaIfNeeded(json);
        _writeByte(json, DOUBLE_QUOTE);
        _writeBytes(json, bytes(propertyName));
        _writeByte(json, DOUBLE_QUOTE);
        _writeByte(json, ":");
        _writeByte(json, OPEN_BRACKET);

        json.depth = (json.depth & COMMA_FLAG) | ((json.depth & ~COMMA_FLAG) + 1);
        json.depth &= ~COMMA_FLAG;
        return json;
    }

    /**
     * @dev Writes the beginning of a JSON object.
     */
    function writeStartObject(Json memory json) internal pure returns (Json memory) {
        _ensureInit(json);
        _writeCommaIfNeeded(json);
        _writeByte(json, OPEN_BRACE);

        json.depth = (json.depth & COMMA_FLAG) | ((json.depth & ~COMMA_FLAG) + 1);
        json.depth &= ~COMMA_FLAG; // first element = no comma yet
        return json;
    }

    /**
     * @dev Writes the beginning of a JSON object with a property name as the key.
     */
    function writeStartObject(Json memory json, string memory propertyName) internal pure returns (Json memory) {
        _ensureInit(json);
        _writeCommaIfNeeded(json);
        _writeByte(json, DOUBLE_QUOTE);
        _writeBytes(json, bytes(propertyName));
        _writeByte(json, DOUBLE_QUOTE);
        _writeByte(json, ":");
        _writeByte(json, OPEN_BRACE);

        json.depth = (json.depth & COMMA_FLAG) | ((json.depth & ~COMMA_FLAG) + 1);
        json.depth &= ~COMMA_FLAG; // first element = no comma yet
        return json;
    }

    /**
     * @dev Writes the end of a JSON array.
     */
    function writeEndArray(Json memory json) internal pure returns (Json memory) {
        _writeByte(json, CLOSED_BRACKET);

        // pop depth
        uint256 depth = (json.depth & ~COMMA_FLAG);
        if (depth == 0) { 
            revert UnbalancedJSON();
        }
        depth -= 1;
        
        // restore needsComma for parent
        json.depth = depth | COMMA_FLAG;

        return json;
    }

    /**
     * @dev Writes the end of a JSON object.
     */
    function writeEndObject(Json memory json) internal pure returns (Json memory) {
        _writeByte(json, CLOSED_BRACE);

        // pop depth
        uint256 depth = (json.depth & ~COMMA_FLAG);
        if (depth == 0) { 
            revert UnbalancedJSON();
        }
        depth -= 1;

        // restore needsComma for parent
        json.depth = depth | COMMA_FLAG;

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
        _writeCommaIfNeeded(json);
        _writeByte(json, DOUBLE_QUOTE);
        _writeBytes(json, bytes(propertyName));
        _writeByte(json, DOUBLE_QUOTE);
        _writeByte(json, ":");
        _writeByte(json, DOUBLE_QUOTE);
        _writeBytes(json, bytes(_addressToString(value)));
        _writeByte(json, DOUBLE_QUOTE);
        return json;
    }

    /**
     * @dev Writes the address value (as a JSON string) as an element of a JSON array.
     */
    function writeAddressValue(Json memory json, address value) internal pure returns (Json memory) {
        _writeCommaIfNeeded(json);
        _writeByte(json, DOUBLE_QUOTE);
        _writeBytes(json, bytes(_addressToString(value)));
        _writeByte(json, DOUBLE_QUOTE);
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
        _writeCommaIfNeeded(json);
        _writeByte(json, DOUBLE_QUOTE);
        _writeBytes(json, bytes(propertyName));
        _writeByte(json, DOUBLE_QUOTE);
        _writeByte(json, ":");
        _writeBytes(json, bytes(strValue));
        return json;
    }

    /**
     * @dev Writes the boolean value (as a JSON literal "true" or "false") as an element of a JSON array.
     */
    function writeBooleanValue(Json memory json, bool value) internal pure returns (Json memory) {
        string memory strValue = value ? TRUE : FALSE;
        _writeCommaIfNeeded(json);
        _writeBytes(json, bytes(strValue));
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
        _writeCommaIfNeeded(json);
        _writeByte(json, DOUBLE_QUOTE);
        _writeBytes(json, bytes(propertyName));
        _writeByte(json, DOUBLE_QUOTE);
        _writeByte(json, ":");
        _writeBytes(json, bytes(_intToString(value)));
        return json;
    }

    /**
     * @dev Writes the int value (as a JSON number) as an element of a JSON array.
     */
    function writeIntValue(Json memory json, int256 value) internal pure returns (Json memory) {
        _writeCommaIfNeeded(json);
        _writeBytes(json, bytes(_intToString(value)));
        return json;
    }

    /**
     * @dev Writes the property name and value of null as part of a name/value pair of a JSON object.
     */
    function writeNullProperty(Json memory json, string memory propertyName) internal pure returns (Json memory) {
        _writeCommaIfNeeded(json);
        _writeByte(json, DOUBLE_QUOTE);
        _writeBytes(json, bytes(propertyName));
        _writeByte(json, DOUBLE_QUOTE);
        _writeByte(json, ":");
        _writeBytes(json, "null");
        return json;
    }

    /**
     * @dev Writes the value of null as an element of a JSON array.
     */
    function writeNullValue(Json memory json) internal pure returns (Json memory) {
        _writeCommaIfNeeded(json);
        _writeBytes(json, "null");
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
        _writeCommaIfNeeded(json);
        _writeByte(json, DOUBLE_QUOTE);
        _writeBytes(json, bytes(propertyName));
        _writeByte(json, DOUBLE_QUOTE);
        _writeByte(json, ":");
        _writeStringLiteral(json, value);
        return json;
    }

    /**
     * @dev Writes the string text value (as a JSON string) as an element of a JSON array.
     */
    function writeStringValue(Json memory json, string memory value) internal pure returns (Json memory) {
        _writeCommaIfNeeded(json);
        _writeStringLiteral(json, value);
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
        _writeCommaIfNeeded(json);
        _writeByte(json, DOUBLE_QUOTE);
        _writeBytes(json, bytes(propertyName));
        _writeByte(json, DOUBLE_QUOTE);
        _writeByte(json, ":");
        _writeBytes(json, bytes(_uintToString(value)));
        return json;
    }

    /**
     * @dev Writes the uint value (as a JSON number) as an element of a JSON array.
     */
    function writeUintValue(Json memory json, uint256 value) internal pure returns (Json memory) {
        _writeCommaIfNeeded(json);
        _writeBytes(json, bytes(_uintToString(value)));
        return json;
    }

    /**
     * @dev Finalizes the JSON builder and returns the JSON string.
     *      Reverts if there are unclosed JSON objects/arrays.
     */
    function toString(Json memory json) internal pure returns (string memory) {
        if ((json.depth & ~COMMA_FLAG) != 0) {
            revert UnbalancedJSON();
        }
        return string(_slice(json));
    }

    /**
     * @dev Converts an address to a checksummed string. Based off of OZ's Strings.sol implementation.
     */
    function _addressToString(address addr) private pure returns (string memory) {
        bytes memory buffer = bytes(_toHexString(addr));

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

    function _ensureCapacity(Json memory json, uint256 needed) private pure {
        if (json.cursor + needed <= json.capacity) {
            return;
        }

        uint256 newCapacity = json.capacity * 2;
        if (newCapacity < json.cursor + needed) {
            newCapacity = json.cursor + needed;
        }

        bytes memory newBuffer = new bytes(newCapacity);

        for (uint256 i; i < json.cursor;++i) {
            newBuffer[i] = json.buffer[i];
        }

        json.buffer = newBuffer;
        json.capacity = newCapacity;
    }

    function _ensureInit(Json memory json) private pure {
        if (json.capacity == 0) {
            json.capacity = INITIAL_CAPACITY;
            json.buffer = new bytes(INITIAL_CAPACITY);
            json.cursor = 0;
            json.depth = 0; // depth=0, needsComma=0
        }
    }

    /**
     * @dev Escapes characters that are required by JSON to be escaped.
     * Escapes backslash and double quote: \" \\
     * Escapes all ASCII control chars < 0x20:
     *   For chars in CTRL_CHARS_MASK, use short escapes
     *   For all others, use \u00XX
     */
    function _escapeJsonString(string memory value) private pure returns (string memory str) {
        bytes memory b = bytes(value);
        uint256 len = b.length;
        uint256 extra;

        // determine how many extra bytes are needed
        for (uint256 i; i < len;) {
            bytes1 char = b[i];
            uint8 code = uint8(char);

            if (char == BACKSLASH || char == DOUBLE_QUOTE) {
                extra += 1;
            } else if (code < 0x20) {
                // use short escape (1 extra byte), otherwise use \u00xx (5 extra bytes)
                bool hasShortEscape = (CTRL_CHARS_MASK & (uint256(1) << code)) != 0;
                extra += hasShortEscape ? 1 : 5;
            }

            unchecked { ++i; }
        }

        if (extra == 0) {
            return value;
        }

        bytes memory out = new bytes(len + extra);
        uint256 j;

        for (uint256 i; i < len;) {
            bytes1 char = b[i];
            uint8 code = uint8(char);

            if (char == BACKSLASH) {
                out[j++] = "\\";
                out[j++] = "\\";
            } else if (char == DOUBLE_QUOTE) {
                out[j++] = "\\";
                out[j++] = '"';
            } else if (code < 0x20) {
                bool hasShortEscape = (CTRL_CHARS_MASK & (uint256(1) << code)) != 0;
                out[j++] = "\\";
                
                if (hasShortEscape) {
                    if (char == BACKSPACE) {
                        out[j++] = "b";
                    } else if (char == HORIZONTAL_TAB) {
                        out[j++] = "t";
                    } else if (char == NEWLINE) {
                        out[j++] = "n";
                    } else if (char == FORM_FEED) {
                        out[j++] = "f";
                    } else if (char == CARRIAGE_RETURN) {
                        out[j++] = "r";
                    }
                } else {
                    // set other control chars as \u00XX
                    out[j++] = "u";
                    out[j++] = "0";
                    out[j++] = "0";
                    out[j++] = HEX_DIGITS[code >> 4];
                    out[j++] = HEX_DIGITS[code & 0x0f];
                }
            } else {
                // normal char
                out[j++] = char;
            }

            unchecked { ++i; }
        }

        return string(out);
    }

    /**
     * @dev Converts a `bytes` buffer to its non-checksummed ASCII `string` hexadecimal representation.
     */
    function _toHexString(address value) private pure returns (string memory) {
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
    function _intToString(int256 i) private pure returns (string memory) {
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
            // casting positive int256 to uint256 is always safe
            // forge-lint: disable-next-line(unsafe-typecast)
            j = uint256(i);
        } else {
            // casting (-i) from int256 to uint256 is safe because:
            // 1. int256.min is handled separately, so -i will never overflow.
            // 2. for any other negative i, -i is in the range [1, 2^255 - 1], which fits safely in uint256.
            // forge-lint: disable-next-line(unsafe-typecast)
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
            uint256 digit = l % 10;
            // casting to uint8 is safe because (48 + digit) is always in the ASCII range 48–57 (<256)
            // forge-lint: disable-next-line(unsafe-typecast)
            bstr[--k] = bytes1(uint8(48 + digit));
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
    function _uintToString(uint256 _i) private pure returns (string memory) {
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
            uint256 digit = _i % 10;
            // casting to uint8 is safe because (48 + digit) is always in the ASCII range 48–57 (<256)
            // forge-lint: disable-next-line(unsafe-typecast)
            bstr[--k] = bytes1(uint8(48 + digit));
            _i /= 10;
        }

        return string(bstr);
    }

    function _slice(Json memory json) private pure returns (bytes memory) {
        bytes memory out = new bytes(json.cursor);
        for (uint256 i; i < json.cursor; ++i) {
            out[i] = json.buffer[i];
        }

        return out;
    }

    function _writeByte(Json memory json, bytes1 b) private pure {
        _ensureInit(json);
        _ensureCapacity(json, 1);
        json.buffer[json.cursor++] = b;
    }

    function _writeBytes(Json memory json, bytes memory data) private pure {
        _ensureInit(json);
        uint256 len = data.length;
        _ensureCapacity(json, len);
        for (uint256 i;i < len;i++) {
            json.buffer[json.cursor++] = data[i];
        }
    }

    function _writeCommaIfNeeded(Json memory json) private pure {
        if ((json.depth & COMMA_FLAG) != 0) {
            _writeByte(json, COMMA);
        } else {
            json.depth |= COMMA_FLAG;
        }
    }

    function _writeStringLiteral(Json memory json, string memory _value) private pure {
        _writeByte(json, DOUBLE_QUOTE);

        bytes memory value = bytes(_value);
        uint256 len = value.length;

        for (uint256 i;i < len;++i) {
            bytes1 c = value[i];
            uint8 code = uint8(value[i]);

            if (c == BACKSLASH) {
                _writeByte(json, BACKSLASH);
                _writeByte(json, BACKSLASH);
            }
            else if (c == DOUBLE_QUOTE) {
                _writeByte(json, BACKSLASH); 
                _writeByte(json, DOUBLE_QUOTE);
            }
            else if (code < 0x20) {
                _writeByte(json, BACKSLASH);

                bool hasShortEscape = (CTRL_CHARS_MASK & (uint256(1) << code)) != 0;
                if (hasShortEscape) {
                    if (code == 8) {
                        _writeByte(json, "b");
                    }
                    else if (code == 9) {
                        _writeByte(json, "t");
                    } 
                    else if (code == 10) {
                        _writeByte(json, "n");
                    }
                    else if (code == 12) {
                        _writeByte(json, "f");
                    }
                    else if (code == 13) {
                        _writeByte(json, "r");
                    }
                } else {
                    // set other control chars as \u00XX
                    _writeByte(json, "u");
                    _writeByte(json, "0");
                    _writeByte(json, "0");
                    _writeByte(json, HEX_DIGITS[code >> 4]);
                    _writeByte(json, HEX_DIGITS[code & 0x0f]);
                }
            }
            else {
                _writeByte(json, bytes1(code));
            }
        }

        _writeByte(json, DOUBLE_QUOTE);
    }
}
