// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {JsonWriter} from "../src/JsonWriter.sol";

contract JsonWriterUintTest is Test {
    using JsonWriter for JsonWriter.Json;

    function test_writesUintValueOf() public pure {
        JsonWriter.Json memory json;

        assertEq(json.value, ' ');
    }

    function test_writesArrayWithSingleUintValue() public pure {
        JsonWriter.Json memory json;
        json = json.writeStartArray();
        json = json.writeUintValue(1);
        json = json.writeEndArray();

        assertEq(json.value, '[1]');
    }

    function test_writesArrayWithMultipleUintValues() public pure {
        JsonWriter.Json memory json;
        json = json.writeStartArray();
        json = json.writeUintValue(1);
        json = json.writeUintValue(2);
        json = json.writeEndArray();

        assertEq(json.value, '[1,2]');
    }

    function test_writesUintPropertyOf() public pure {
        JsonWriter.Json memory json;

        assertEq(json.value, ' ');
    }

    function test_writesObjectWithSingleUintPropertyAndValue() public pure {
        JsonWriter.Json memory json;
        json = json.writeStartObject();
        json = json.writeUintProperty('prop', 1);
        json = json.writeEndObject();

        assertEq(json.value, '{"prop": 1}');
    }

    function test_writesObjectWithMultipleUintPropertiesAndValues() public pure {
        JsonWriter.Json memory json;
        json = json.writeStartObject();
        json = json.writeIntProperty('prop1', 1);
        json = json.writeIntProperty('prop2', 2);
        json = json.writeEndObject();

        assertEq(json.value, '{"prop1": 1,"prop2": 2}');
    }
}