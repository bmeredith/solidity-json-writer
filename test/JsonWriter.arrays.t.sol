// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {JsonWriter} from "../src/JsonWriter.sol";

contract JsonWriterArrayTest is Test {
    using JsonWriter for JsonWriter.Json;

    function test_writesEmptyArrayForInitialJSONString() public pure {
        JsonWriter.Json memory json;
        json = json.writeStartArray();
        json = json.writeEndArray();

        assertEq(json.toString(), "[]");
    }

    function test_writesArrayWithinArray() public pure {
        JsonWriter.Json memory json;
        json = json.writeStartArray();
        json = json.writeStartArray();
        json = json.writeEndArray();
        json = json.writeEndArray();

        assertEq(json.toString(), "[[]]");
    }

    function test_writesMultipleArraysWithinAnArray() public pure {
        JsonWriter.Json memory json;
        json = json.writeStartArray();
        json = json.writeStartArray();
        json = json.writeEndArray();
        json = json.writeStartArray();
        json = json.writeEndArray();
        json = json.writeEndArray();

        assertEq(json.toString(), "[[],[]]");
    }

    function test_writesArrayWithNestedObject() public pure {
        JsonWriter.Json memory json;
        json = json.writeStartArray();
        json = json.writeStartObject();
        json = json.writeEndObject();
        json = json.writeEndArray();

        assertEq(json.toString(), "[{}]");
    }

    function test_writesArrayWithMultipleNestedObjects() public pure {
        JsonWriter.Json memory json;
        json = json.writeStartArray();
        json = json.writeStartObject();
        json = json.writeEndObject();
        json = json.writeStartObject();
        json = json.writeEndObject();
        json = json.writeEndArray();

        assertEq(json.toString(), "[{},{}]");
    }
}
