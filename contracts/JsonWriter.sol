//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./StringUtils.sol";

library JsonWriter {
    
    using StringUtils for string;

    struct Json {
        int256 depthBitTracker;
        string value;
    }

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
    function writeStartArray(
        Json memory json
    ) internal pure returns (Json memory) {
        return writeStart(json, OPEN_BRACKET);
    }

    /**
     * @dev Writes the beginning of a JSON array with a property name as the key.
     */
    function writeStartArray(
        Json memory json, 
        string memory propertyName
    ) internal pure returns (Json memory) {
        return writeStart(json, propertyName, OPEN_BRACKET);
    }

    /**
     * @dev Writes the beginning of a JSON object.
     */
    function writeStartObject(
        Json memory json
    ) internal pure returns (Json memory) {
        return writeStart(json, OPEN_BRACE);
    }

    /**
     * @dev Writes the beginning of a JSON object with a property name as the key.
     */
    function writeStartObject(
        Json memory json, 
        string memory propertyName
    ) internal pure returns (Json memory) {
        return writeStart(json, propertyName, OPEN_BRACE);
    }

    /**
     * @dev Writes the end of a JSON array.
     */
    function writeEndArray(
        Json memory json
    ) internal pure returns (Json memory) {
        json.value = string(abi.encodePacked(json.value, CLOSED_BRACKET));
        return json;
    }

    /**
     * @dev Writes the end of a JSON object.
     */
    function writeEndObject(
        Json memory json
    ) internal pure returns (Json memory) {
        json.value = string(abi.encodePacked(json.value, CLOSED_BRACE));
        return json;
    }

    /**
     * @dev Writes the property name and address value (as a JSON string) as part of a name/value pair of a JSON object.
     */
    function writeAddressProperty(
        Json memory json,
        string memory propertyName, 
        address value
    ) internal pure returns (Json memory) {
        if(json.depthBitTracker < 0) {
            json.value = appendListSeparator(json);
        }
        
        json.value = json.value.strConcat('"', propertyName, '": "', StringUtils.addressToString(value), '"');
        json.depthBitTracker = setListSeparatorFlag(json);

        return json;
    }

    /**
     * @dev Writes the address value (as a JSON string) as an element of a JSON array.
     */
    function writeAddressValue(
        Json memory json, 
        address value
    ) internal pure returns (Json memory) {
        if(json.depthBitTracker < 0) {
            json.value = appendListSeparator(json);
        }

        json.value = json.value.strConcat('"', StringUtils.addressToString(value), '"');
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
        if(json.depthBitTracker < 0) {
            json.value = appendListSeparator(json);
        }

        string memory strValue;
        if(value) {
            strValue = TRUE;
        }
        else {
            strValue = FALSE;
        }

        json.value = json.value.strConcat('"', propertyName, '": ', strValue);
        json.depthBitTracker = setListSeparatorFlag(json);

        return json;
    }

    /**
     * @dev Writes the boolean value (as a JSON literal "true" or "false") as an element of a JSON array.
     */
    function writeBooleanValue(
        Json memory json, 
        bool value
    ) internal pure returns (Json memory) {
        if(json.depthBitTracker < 0) {
            json.value = appendListSeparator(json);
        }

        string memory strValue;
        if(value) {
            strValue = TRUE;
        }
        else {
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
        int value
    ) internal pure returns (Json memory) {
        if(json.depthBitTracker < 0) {
            json.value = appendListSeparator(json);
        }

        json.value = json.value.strConcat('"', propertyName, '": ', StringUtils.intToString(value));
        json.depthBitTracker = setListSeparatorFlag(json);

        return json;
    }

    /**
     * @dev Writes the int value (as a JSON number) as an element of a JSON array.
     */
    function writeIntValue(
        Json memory json,
        int value
    ) internal pure returns (Json memory) {
        if(json.depthBitTracker < 0) {
            json.value = appendListSeparator(json);
        }

        json.value = json.value.strConcat(StringUtils.intToString(value));
        json.depthBitTracker = setListSeparatorFlag(json);

        return json;
    }

    /**
     * @dev Writes the property name and uint value (as a JSON number) as part of a name/value pair of a JSON object.
     */
    function writeUintProperty(
        Json memory json, 
        string memory propertyName, 
        uint value
    ) internal pure returns (Json memory) {
        if(json.depthBitTracker < 0) {
            json.value = appendListSeparator(json);
        }

        json.value = json.value.strConcat('"', propertyName, '": ', StringUtils.uintToString(value));
        json.depthBitTracker = setListSeparatorFlag(json);

        return json;
    }

    /**
     * @dev Writes the uint value (as a JSON number) as an element of a JSON array.
     */
    function writeUintValue(
        Json memory json, 
        uint value
    ) internal pure returns (Json memory) {
        if(json.depthBitTracker < 0) {
            json.value = appendListSeparator(json);
        }

        json.value = json.value.strConcat(StringUtils.uintToString(value));
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
        if(json.depthBitTracker < 0) {
            json.value = appendListSeparator(json);
        }

        json.value = json.value.strConcat('"', propertyName, '": "', value, '"');
        json.depthBitTracker = setListSeparatorFlag(json);

        return json;
    }

    /**
     * @dev Writes the property name and string text value (as a JSON string) as part of a name/value pair of a JSON object.
     */
    function writeStringValue(
        Json memory json, 
        string memory value
    ) internal pure returns (Json memory) {
        if(json.depthBitTracker < 0) {
            json.value = appendListSeparator(json);
        }

        json.value = json.value.strConcat('"', value, '"');
        json.depthBitTracker = setListSeparatorFlag(json);

        return json;
    }

    /**
     * @dev Writes the beginning of a JSON array or object based on the token parameter.
     */
    function writeStart(
        Json memory json, 
        bytes1 token
    ) private pure returns (Json memory) {
        if(json.depthBitTracker < 0) {
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
        if(json.depthBitTracker < 0) {
            json.value = appendListSeparator(json);
        }

        json.value = json.value.strConcat('"', propertyName, '": ', string(abi.encodePacked(token)));

        json.depthBitTracker &= MAX_INT256;
        json.depthBitTracker += 1;

        return json;
    }

    /**
     * @dev Writes the end of a JSON array or object based on the token parameter.
     */
    function writeEnd(
        Json memory json, 
        bytes1 token
    ) private pure returns (Json memory) {
        json.value = string(abi.encodePacked(json.value, token));

        json.depthBitTracker = setListSeparatorFlag(json);
        if(getCurrentDepth(json) != 0) {
            json.depthBitTracker -= 1;
        }

        return json;
    }

    /**
     * @dev Tracks the recursive depth of the nested objects / arrays within the JSON text
     * written so far. This provides the depth of the current token.
     */
    function getCurrentDepth(
        Json memory json
    ) private pure returns (int256) {
        return json.depthBitTracker & MAX_INT256;
    }

    /**
     * @dev The highest order bit of json.depthBitTracker is used to discern whether we are writing the first item in a list or not.
     * if (json.depthBitTracker >> 255) == 1, add a list separator before writing the item
     * else, no list separator is needed since we are writing the first item.
     */
    function setListSeparatorFlag(
        Json memory json
    ) private pure returns (int256) {
        return json.depthBitTracker | (int256(1) << 255);        
    }

    /**
     * @dev Appends the list separator character to the JSON string.
     */
    function appendListSeparator(
        Json memory json
    ) private pure returns (string memory) {
        return string(abi.encodePacked(json.value, LIST_SEPARATOR));
    }
}