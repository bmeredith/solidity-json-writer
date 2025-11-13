// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {JsonWriter} from "../src/JsonWriter.sol";

contract JsonWriterBooleanTest is Test {
    using JsonWriter for JsonWriter.Json;

    function test_writesBooleanValueOfTrue() public pure {
        JsonWriter.Json memory json;
        json = json.writeBooleanValue(true);

        assertEq(json.value, "true");
    }

    function test_writesBooleanValueOfFalse() public pure {
        JsonWriter.Json memory json;
        json = json.writeBooleanValue(false);

        assertEq(json.value, "false");
    }

    function test_writesArrayWithSingleBooleanValue() public pure {
        JsonWriter.Json memory json;
        json = json.writeStartArray();
        json = json.writeBooleanValue(true);
        json = json.writeEndArray();

        assertEq(json.value, "[true]");
    }

    function test_writesArrayWithMultipleBooleanValues() public pure {
        JsonWriter.Json memory json;
        json = json.writeStartArray();
        json = json.writeBooleanValue(true);
        json = json.writeBooleanValue(true);
        json = json.writeEndArray();

        assertEq(json.value, "[true,true]");
    }

    function test_writesBooleanPropertyOfTrue() public pure {
        JsonWriter.Json memory json;
        json = json.writeBooleanProperty("prop", true);

        assertEq(json.value, '"prop": true');
    }

    function test_writesBooleanPropertyOfFalse() public pure {
        JsonWriter.Json memory json;
        json = json.writeBooleanProperty("prop", false);

        assertEq(json.value, '"prop": false');
    }

    function test_writesObjectWithSingleBooleanPropertyAndValue() public pure {
        JsonWriter.Json memory json;
        json = json.writeStartObject();
        json = json.writeBooleanProperty("prop", true);
        json = json.writeEndObject();

        assertEq(json.value, '{"prop": true}');
    }

    function test_writesObjectyWithMultipleBooleanPropertiesAndValues() public pure {
        JsonWriter.Json memory json;
        json = json.writeStartObject();
        json = json.writeBooleanProperty("prop1", true);
        json = json.writeBooleanProperty("prop2", true);
        json = json.writeEndObject();

        assertEq(json.value, '{"prop1": true,"prop2": true}');
    }
}
