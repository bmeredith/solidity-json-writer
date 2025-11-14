// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {JsonWriter} from "../src/JsonWriter.sol";

contract JsonWriterNullTest is Test {
    using JsonWriter for JsonWriter.Json;

    function test_writesNullValue() public pure {
        JsonWriter.Json memory json;
        string memory output = json
            .writeNullValue()
            .toString();

        assertEq(output, "null");
    }

    function test_writesArrayWithSingleNullValue() public pure {
        JsonWriter.Json memory json;
        string memory output = json
            .writeStartArray()
                .writeNullValue()
            .writeEndArray()
            .toString();

        assertEq(output, "[null]");
    }

    function test_writesArrayWithMultipleNullValues() public pure {
        JsonWriter.Json memory json;
        string memory output = json
            .writeStartArray()
                .writeNullValue()
                .writeNullValue()
            .writeEndArray()
            .toString();

        assertEq(output, "[null,null]");
    }

    function test_writesPropertyWithValueOfNull() public pure {
        JsonWriter.Json memory json;
        string memory output = json
            .writeNullProperty("prop")
            .toString();

        assertEq(output, '"prop": null');
    }

    function test_writesObjectWithSinglePropertyAndNullValue() public pure {
        JsonWriter.Json memory json;
        string memory output = json
            .writeStartObject()
                .writeNullProperty("prop")
            .writeEndObject()
            .toString();

        assertEq(output, '{"prop": null}');
    }

    function test_writesObjectWithMultiplePropertiesAndNullValues() public pure {
        JsonWriter.Json memory json;
        string memory output = json
            .writeStartObject()
                .writeNullProperty("prop1")
                .writeNullProperty("prop2")
            .writeEndObject()
            .toString();

        assertEq(output, '{"prop1": null,"prop2": null}');
    }
}
