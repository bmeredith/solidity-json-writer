//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../JsonWriter.sol";

contract JsonWriterMock {
    using JsonWriter for JsonWriter.Json;

    function writeStartArray(JsonWriter.Json memory json)
        public
        pure
        returns (JsonWriter.Json memory)
    {
        return JsonWriter.writeStartArray(json);
    }

    function writeStartArrayProperty(
        JsonWriter.Json memory json,
        string memory propertyName
    ) public pure returns (JsonWriter.Json memory) {
        return JsonWriter.writeStartArray(json, propertyName);
    }

    function writeStartObject(JsonWriter.Json memory json)
        public
        pure
        returns (JsonWriter.Json memory)
    {
        return JsonWriter.writeStartObject(json);
    }

    function writeEndArray(JsonWriter.Json memory json)
        public
        pure
        returns (JsonWriter.Json memory)
    {
        return JsonWriter.writeEndArray(json);
    }

    function writeEndObject(JsonWriter.Json memory json)
        public
        pure
        returns (JsonWriter.Json memory)
    {
        return JsonWriter.writeEndObject(json);
    }

    function writeAddressProperty(
        JsonWriter.Json memory json,
        string memory propertyName,
        address value
    ) public pure returns (JsonWriter.Json memory) {
        return JsonWriter.writeAddressProperty(json, propertyName, value);
    }

    function writeAddressValue(JsonWriter.Json memory json, address value)
        public
        pure
        returns (JsonWriter.Json memory)
    {
        return JsonWriter.writeAddressValue(json, value);
    }

    function writeBooleanProperty(
        JsonWriter.Json memory json,
        string memory propertyName,
        bool value
    ) public pure returns (JsonWriter.Json memory) {
        return JsonWriter.writeBooleanProperty(json, propertyName, value);
    }

    function writeBooleanValue(JsonWriter.Json memory json, bool value)
        public
        pure
        returns (JsonWriter.Json memory)
    {
        return JsonWriter.writeBooleanValue(json, value);
    }

    function writeIntProperty(
        JsonWriter.Json memory json,
        string memory propertyName,
        int256 value
    ) public pure returns (JsonWriter.Json memory) {
        return JsonWriter.writeIntProperty(json, propertyName, value);
    }

    function writeIntValue(JsonWriter.Json memory json, int256 value)
        public
        pure
        returns (JsonWriter.Json memory)
    {
        return JsonWriter.writeIntValue(json, value);
    }

    function writeNullProperty(
        JsonWriter.Json memory json,
        string memory propertyName
    ) public pure returns (JsonWriter.Json memory) {
        return JsonWriter.writeNullProperty(json, propertyName);
    }

    function writeNullValue(JsonWriter.Json memory json)
        public
        pure
        returns (JsonWriter.Json memory)
    {
        return JsonWriter.writeNullValue(json);
    }

    function writeStringProperty(
        JsonWriter.Json memory json,
        string memory propertyName,
        string memory value
    ) public pure returns (JsonWriter.Json memory) {
        return JsonWriter.writeStringProperty(json, propertyName, value);
    }

    function writeStringValue(JsonWriter.Json memory json, string memory value)
        public
        pure
        returns (JsonWriter.Json memory)
    {
        return JsonWriter.writeStringValue(json, value);
    }

    function writeUintProperty(
        JsonWriter.Json memory json,
        string memory propertyName,
        uint256 value
    ) public pure returns (JsonWriter.Json memory) {
        return JsonWriter.writeUintProperty(json, propertyName, value);
    }

    function writeUintValue(JsonWriter.Json memory json, uint256 value)
        public
        pure
        returns (JsonWriter.Json memory)
    {
        return JsonWriter.writeUintValue(json, value);
    }
}
