//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../JsonWriter.sol";

contract JsonWriterMock {
    
    using JsonWriter for JsonWriter.Json;

    function writeStartArray(JsonWriter.Json memory json) public pure returns (JsonWriter.Json memory) {
        return JsonWriter.writeStartArray(json);
    }

    function writeStartObject(JsonWriter.Json memory json) public pure returns (JsonWriter.Json memory) {
        return JsonWriter.writeStartObject(json);
    }

    function writeEndArray(JsonWriter.Json memory json) public pure returns (JsonWriter.Json memory) {
        return JsonWriter.writeEndArray(json);
    }

    function writeEndObject(JsonWriter.Json memory json) public pure returns (JsonWriter.Json memory) {
        return JsonWriter.writeEndObject(json);
    }

    function writeAddressValue(JsonWriter.Json memory json, address value) public pure returns (JsonWriter.Json memory) {
        return JsonWriter.writeAddressValue(json, value);
    }

    function writeBooleanValue(JsonWriter.Json memory json, bool value) public pure returns (JsonWriter.Json memory) {
        return JsonWriter.writeBooleanValue(json, value);
    }

    function writeIntValue(JsonWriter.Json memory json, int value) public pure returns (JsonWriter.Json memory) {
        return JsonWriter.writeIntValue(json, value);
    }

    function writeStringValue(JsonWriter.Json memory json, string memory value) public pure returns (JsonWriter.Json memory) {
        return JsonWriter.writeStringValue(json, value);
    }

    function writeUintValue(JsonWriter.Json memory json, uint value) public pure returns (JsonWriter.Json memory) {
        return JsonWriter.writeUintValue(json, value);
    }
}