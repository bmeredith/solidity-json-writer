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
}