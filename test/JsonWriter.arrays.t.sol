// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {JsonWriter} from "../src/JsonWriter.sol";

contract JsonWriterArrayTest is Test {
    using JsonWriter for JsonWriter.Json;

    function test_writesEmptyArrayForInitialJSONString() public pure {
        JsonWriter.Json memory json;
        string memory output = json
            .writeStartArray()
            .writeEndArray()
            .toString();

        assertEq(output, "[]");
    }

    function test_writesArrayWithinArray() public pure {
        JsonWriter.Json memory json;
        string memory output = json
            .writeStartArray()
                .writeStartArray()
                .writeEndArray()
            .writeEndArray()
            .toString();

        assertEq(output, "[[]]");
    }

    function test_writesMultipleArraysWithinAnArray() public pure {
        JsonWriter.Json memory json;
        string memory output = json
            .writeStartArray()
                .writeStartArray()
                .writeEndArray()
                .writeStartArray()
                .writeEndArray()
            .writeEndArray()
            .toString();

        assertEq(output, "[[],[]]");
    }

    function test_writesArrayWithNestedObject() public pure {
        JsonWriter.Json memory json;
        string memory output = json
            .writeStartArray()
                .writeStartObject()
                .writeEndObject()
            .writeEndArray()
            .toString();

        assertEq(output, "[{}]");
    }

    function test_writesArrayWithMultipleNestedObjects() public pure {
        JsonWriter.Json memory json;
        string memory output = json
            .writeStartArray()
                .writeStartObject()
                .writeEndObject()
                .writeStartObject()
                .writeEndObject()
            .writeEndArray()
            .toString();

        assertEq(output, "[{},{}]");
    }
}
