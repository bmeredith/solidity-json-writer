//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./StringUtils.sol";
import "hardhat/console.sol";

library JsonWriter {
    using StringUtils for string;

    struct Json {
        int256 depthBitTracker;
        string value;
    }

    bytes1 constant BACKSLASH = bytes1(uint8(92));
    bytes1 constant BACKSPACE = bytes1(uint8(8));
    bytes1 constant CARRIAGE_RETURN = bytes1(uint8(13));
    bytes1 constant DOUBLE_QUOTE = bytes1(uint8(34));
    bytes1 constant FORM_FEED = bytes1(uint8(12));
    bytes1 constant FRONTSLASH = bytes1(uint8(47));
    bytes1 constant HORIZONTAL_TAB = bytes1(uint8(9));
    bytes1 constant NEWLINE = bytes1(uint8(10));

    string constant TRUE = "true";
    string constant FALSE = "false";
    bytes1 constant OPEN_BRACE = "{";
    bytes1 constant CLOSED_BRACE = "}";
    bytes1 constant OPEN_BRACKET = "[";
    bytes1 constant CLOSED_BRACKET = "]";
    bytes1 constant LIST_SEPARATOR = ",";

    int256 constant MAX_INT256 = type(int256).max;

    /**
     * @dev Writes the beginning of a JSON array.
     */
    function writeStartArray(Json memory json)
        internal
        pure
        returns (Json memory)
    {
        return writeStart(json, OPEN_BRACKET);
    }

    /**
     * @dev Writes the beginning of a JSON array with a property name as the key.
     */
    function writeStartArray(Json memory json, string memory propertyName)
        internal
        pure
        returns (Json memory)
    {
        return writeStart(json, propertyName, OPEN_BRACKET);
    }

    /**
     * @dev Writes the beginning of a JSON object.
     */
    function writeStartObject(Json memory json)
        internal
        pure
        returns (Json memory)
    {
        return writeStart(json, OPEN_BRACE);
    }

    /**
     * @dev Writes the beginning of a JSON object with a property name as the key.
     */
    function writeStartObject(Json memory json, string memory propertyName)
        internal
        pure
        returns (Json memory)
    {
        return writeStart(json, propertyName, OPEN_BRACE);
    }

    /**
     * @dev Writes the end of a JSON array.
     */
    function writeEndArray(Json memory json)
        internal
        pure
        returns (Json memory)
    {
        return writeEnd(json, CLOSED_BRACKET);
    }

    /**
     * @dev Writes the end of a JSON object.
     */
    function writeEndObject(Json memory json)
        internal
        pure
        returns (Json memory)
    {
        return writeEnd(json, CLOSED_BRACE);
    }

    /**
     * @dev Writes the property name and address value (as a JSON string) as part of a name/value pair of a JSON object.
     */
    function writeAddressProperty(
        Json memory json,
        string memory propertyName,
        address value
    ) internal pure returns (Json memory) {
        if (json.depthBitTracker < 0) {
            json.value = appendListSeparator(json);
        }

        json.value = json.value.strConcat(
            '"',
            propertyName,
            '": "',
            StringUtils.addressToString(value),
            '"'
        );
        json.depthBitTracker = setListSeparatorFlag(json);

        return json;
    }

    /**
     * @dev Writes the address value (as a JSON string) as an element of a JSON array.
     */
    function writeAddressValue(Json memory json, address value)
        internal
        pure
        returns (Json memory)
    {
        if (json.depthBitTracker < 0) {
            json.value = appendListSeparator(json);
        }

        json.value = json.value.strConcat(
            '"',
            StringUtils.addressToString(value),
            '"'
        );
        json.depthBitTracker = setListSeparatorFlag(json);

        return json;
    }

    /**
     * @dev Writes the property name and boolean value (as a JSON literal "true" or "false") as part of a name/value pair of a JSON object.
     */
    function writeBooleanProperty(
        Json memory json,
        string memory propertyName,
        bool value
    ) internal pure returns (Json memory) {
        if (json.depthBitTracker < 0) {
            json.value = appendListSeparator(json);
        }

        string memory strValue;
        if (value) {
            strValue = TRUE;
        } else {
            strValue = FALSE;
        }

        json.value = json.value.strConcat('"', propertyName, '": ', strValue);
        json.depthBitTracker = setListSeparatorFlag(json);

        return json;
    }

    /**
     * @dev Writes the boolean value (as a JSON literal "true" or "false") as an element of a JSON array.
     */
    function writeBooleanValue(Json memory json, bool value)
        internal
        pure
        returns (Json memory)
    {
        if (json.depthBitTracker < 0) {
            json.value = appendListSeparator(json);
        }

        string memory strValue;
        if (value) {
            strValue = TRUE;
        } else {
            strValue = FALSE;
        }

        json.value = json.value.strConcat(strValue);
        json.depthBitTracker = setListSeparatorFlag(json);

        return json;
    }

    /**
     * @dev Writes the property name and int value (as a JSON number) as part of a name/value pair of a JSON object.
     */
    function writeIntProperty(
        Json memory json,
        string memory propertyName,
        int256 value
    ) internal pure returns (Json memory) {
        if (json.depthBitTracker < 0) {
            json.value = appendListSeparator(json);
        }

        json.value = json.value.strConcat(
            '"',
            propertyName,
            '": ',
            StringUtils.intToString(value)
        );
        json.depthBitTracker = setListSeparatorFlag(json);

        return json;
    }

    /**
     * @dev Writes the int value (as a JSON number) as an element of a JSON array.
     */
    function writeIntValue(Json memory json, int256 value)
        internal
        pure
        returns (Json memory)
    {
        if (json.depthBitTracker < 0) {
            json.value = appendListSeparator(json);
        }

        json.value = json.value.strConcat(StringUtils.intToString(value));
        json.depthBitTracker = setListSeparatorFlag(json);

        return json;
    }

    /**
     * @dev Writes the property name and value of null as part of a name/value pair of a JSON object.
     */
    function writeNullProperty(Json memory json, string memory propertyName)
        internal
        pure
        returns (Json memory)
    {
        if (json.depthBitTracker < 0) {
            json.value = appendListSeparator(json);
        }

        json.value = json.value.strConcat('"', propertyName, '": null');
        json.depthBitTracker = setListSeparatorFlag(json);

        return json;
    }

    /**
     * @dev Writes the value of null as an element of a JSON array.
     */
    function writeNullValue(Json memory json)
        internal
        pure
        returns (Json memory)
    {
        if (json.depthBitTracker < 0) {
            json.value = appendListSeparator(json);
        }

        json.value = json.value.strConcat("null");
        json.depthBitTracker = setListSeparatorFlag(json);

        return json;
    }

    /**
     * @dev Writes the string text value (as a JSON string) as an element of a JSON array.
     */
    function writeStringProperty(
        Json memory json,
        string memory propertyName,
        string memory value
    ) internal pure returns (Json memory) {
        if (json.depthBitTracker < 0) {
            json.value = appendListSeparator(json);
        }

        string memory jsonEscapedString = escapeJsonString(value);
        json.value = json.value.strConcat(
            '"',
            propertyName,
            '": "',
            jsonEscapedString,
            '"'
        );
        json.depthBitTracker = setListSeparatorFlag(json);

        return json;
    }

    /**
     * @dev Writes the property name and string text value (as a JSON string) as part of a name/value pair of a JSON object.
     */
    function writeStringValue(Json memory json, string memory value)
        internal
        pure
        returns (Json memory)
    {
        if (json.depthBitTracker < 0) {
            json.value = appendListSeparator(json);
        }

        string memory jsonEscapedString = escapeJsonString(value);
        json.value = json.value.strConcat('"', jsonEscapedString, '"');
        json.depthBitTracker = setListSeparatorFlag(json);

        return json;
    }

    /**
     * @dev Writes the property name and uint value (as a JSON number) as part of a name/value pair of a JSON object.
     */
    function writeUintProperty(
        Json memory json,
        string memory propertyName,
        uint256 value
    ) internal pure returns (Json memory) {
        if (json.depthBitTracker < 0) {
            json.value = appendListSeparator(json);
        }

        json.value = json.value.strConcat(
            '"',
            propertyName,
            '": ',
            StringUtils.uintToString(value)
        );
        json.depthBitTracker = setListSeparatorFlag(json);

        return json;
    }

    /**
     * @dev Writes the uint value (as a JSON number) as an element of a JSON array.
     */
    function writeUintValue(Json memory json, uint256 value)
        internal
        pure
        returns (Json memory)
    {
        if (json.depthBitTracker < 0) {
            json.value = appendListSeparator(json);
        }

        json.value = json.value.strConcat(StringUtils.uintToString(value));
        json.depthBitTracker = setListSeparatorFlag(json);

        return json;
    }

    /**
     * @dev Writes the beginning of a JSON array or object based on the token parameter.
     */
    function writeStart(Json memory json, bytes1 token)
        private
        pure
        returns (Json memory)
    {
        if (json.depthBitTracker < 0) {
            json.value = appendListSeparator(json);
        }

        json.value = string(abi.encodePacked(json.value, token));

        json.depthBitTracker &= MAX_INT256;
        json.depthBitTracker += 1;

        return json;
    }

    /**
     * @dev Writes the beginning of a JSON array or object based on the token parameter with a property name as the key.
     */
    function writeStart(
        Json memory json,
        string memory propertyName,
        bytes1 token
    ) private pure returns (Json memory) {
        if (json.depthBitTracker < 0) {
            json.value = appendListSeparator(json);
        }

        json.value = json.value.strConcat(
            '"',
            propertyName,
            '": ',
            string(abi.encodePacked(token))
        );

        json.depthBitTracker &= MAX_INT256;
        json.depthBitTracker += 1;

        return json;
    }

    /**
     * @dev Writes the end of a JSON array or object based on the token parameter.
     */
    function writeEnd(Json memory json, bytes1 token)
        private
        pure
        returns (Json memory)
    {
        json.value = string(abi.encodePacked(json.value, token));

        json.depthBitTracker = setListSeparatorFlag(json);
        if (getCurrentDepth(json) != 0) {
            json.depthBitTracker -= 1;
        }

        return json;
    }

    function getBoolean(uint256 _packedBools, uint256 _boolNumber)
        public
        pure
        returns (bool)
    {
        uint256 flag = (_packedBools >> _boolNumber) & uint256(1);
        return (flag == 1 ? true : false);
    }

    function setBoolean(
        uint256 _packedBools,
        uint256 _boolNumber,
        bool _value
    ) public pure returns (uint256) {
        if (_value) return _packedBools | (uint256(1) << _boolNumber);
        else return _packedBools & ~(uint256(1) << _boolNumber);
    }

    /**
     * @dev Escapes any characters that required by JSON to be escaped.
     */
    function escapeJsonString(string memory value)
        private
        pure
        returns (string memory str)
    {
        bytes memory b = bytes(value);
        bool foundEscapeChars;

        for (uint256 i; i < b.length; i++) {
            if (b[i] == BACKSLASH) {
                foundEscapeChars = true;
                break;
            } else if (b[i] == DOUBLE_QUOTE) {
                foundEscapeChars = true;
                break;
            } else if (b[i] == FRONTSLASH) {
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
        }

        if (!foundEscapeChars) {
            return value;
        }

        for (uint256 i; i < b.length; i++) {
            if (b[i] == BACKSLASH) {
                str = string(abi.encodePacked(str, "\\\\"));
            } else if (b[i] == DOUBLE_QUOTE) {
                str = string(abi.encodePacked(str, '\\"'));
            } else if (b[i] == FRONTSLASH) {
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
        }

        return str;
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
    function setListSeparatorFlag(Json memory json)
        private
        pure
        returns (int256)
    {
        return json.depthBitTracker | (int256(1) << 255);
    }

    /**
     * @dev Appends the list separator character to the JSON string.
     */
    function appendListSeparator(Json memory json)
        private
        pure
        returns (string memory)
    {
        return string(abi.encodePacked(json.value, LIST_SEPARATOR));
    }
}
