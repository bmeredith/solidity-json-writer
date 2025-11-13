// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {JsonWriter} from "../src/JsonWriter.sol";

contract JsonWriterIntTest is Test {
    using JsonWriter for JsonWriter.Json;

    function test_writesIntValueOf() public pure {
        JsonWriter.Json memory json;

        assertEq(json.value, ' ');
    }

    function test_writesArrayWithSingleIntValue() public pure {
        JsonWriter.Json memory json;
        json = json.writeStartArray();
        json = json.writeIntValue(-1);
        json = json.writeEndArray();

        assertEq(json.value, '[-1]');
    }

    function test_writesArrayWithMultipleIntValues() public pure {
        JsonWriter.Json memory json;
        json = json.writeStartArray();
        json = json.writeIntValue(-1);
        json = json.writeIntValue(1);
        json = json.writeEndArray();

        assertEq(json.value, '[-1,1]');
    }

    function test_writesIntPropertyOf() public pure {
        JsonWriter.Json memory json;

        assertEq(json.value, ' ');
    }

    function test_writesObjectWithSingleIntPropertyAndValue() public pure {
        JsonWriter.Json memory json;
        json = json.writeStartObject();
        json = json.writeIntProperty('prop', -1);
        json = json.writeEndObject();

        assertEq(json.value, '{"prop": -1}');
    }

    function test_writesObjectWithMultipleIntPropertiesAndValues() public pure {
        JsonWriter.Json memory json;
        json = json.writeStartObject();
        json = json.writeIntProperty('prop1', -1);
        json = json.writeIntProperty('prop2', 1);
        json = json.writeEndObject();

        assertEq(json.value, '{"prop1": -1,"prop2": 1}');
    }
}