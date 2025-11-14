// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {JsonWriter} from "../src/JsonWriter.sol";

contract JsonWriterBooleanTest is Test {
    using JsonWriter for JsonWriter.Json;

    function test_writesBooleanValueOfTrue() public pure {
        JsonWriter.Json memory json;
        string memory output = json
            .writeBooleanValue(true)
            .toString();

        assertEq(output, "true");
    }

    function test_writesBooleanValueOfFalse() public pure {
        JsonWriter.Json memory json;
        string memory output = json
            .writeBooleanValue(false)
            .toString();

        assertEq(output, "false");
    }

    function test_writesArrayWithSingleBooleanValue() public pure {
        JsonWriter.Json memory json;
        string memory output = json
            .writeStartArray()
                .writeBooleanValue(true)
            .writeEndArray()
            .toString();

        assertEq(output, "[true]");
    }

    function test_writesArrayWithMultipleBooleanValues() public pure {
        JsonWriter.Json memory json;
        string memory output = json
            .writeStartArray()
                .writeBooleanValue(true)
                .writeBooleanValue(true)
            .writeEndArray()
            .toString();

        assertEq(output, "[true,true]");
    }

    function test_writesBooleanPropertyOfTrue() public pure {
        JsonWriter.Json memory json;
        string memory output = json
            .writeBooleanProperty("prop", true)
            .toString();

        assertEq(output, '"prop": true');
    }

    function test_writesBooleanPropertyOfFalse() public pure {
        JsonWriter.Json memory json;
        string memory output = json
            .writeBooleanProperty("prop", false)
            .toString();

        assertEq(output, '"prop": false');
    }

    function test_writesObjectWithSingleBooleanPropertyAndValue() public pure {
        JsonWriter.Json memory json;
        string memory output = json
            .writeStartObject()
                .writeBooleanProperty("prop", true)
            .writeEndObject()
            .toString();

        assertEq(output, '{"prop": true}');
    }

    function test_writesObjectyWithMultipleBooleanPropertiesAndValues() public pure {
        JsonWriter.Json memory json;
        string memory output = json
            .writeStartObject()
                .writeBooleanProperty("prop1", true)
                .writeBooleanProperty("prop2", true)
            .writeEndObject()
            .toString();

        assertEq(output, '{"prop1": true,"prop2": true}');
    }
}
