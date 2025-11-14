// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {JsonWriter} from "../src/JsonWriter.sol";

contract JsonWriterNullTest is Test {
    using JsonWriter for JsonWriter.Json;

    function test_writesNullValue() public pure {
        JsonWriter.Json memory json;
        json = json.writeNullValue();

        assertEq(json.toString(), "null");
    }

    function test_writesArrayWithSingleNullValue() public pure {
        JsonWriter.Json memory json;
        json = json.writeStartArray();
        json = json.writeNullValue();
        json = json.writeEndArray();

        assertEq(json.toString(), "[null]");
    }

    function test_writesArrayWithMultipleNullValues() public pure {
        JsonWriter.Json memory json;
        json = json.writeStartArray();
        json = json.writeNullValue();
        json = json.writeNullValue();
        json = json.writeEndArray();

        assertEq(json.toString(), "[null,null]");
    }

    function test_writesPropertyWithValueOfNull() public pure {
        JsonWriter.Json memory json;
        json = json.writeNullProperty("prop");

        assertEq(json.toString(), '"prop": null');
    }

    function test_writesObjectWithSinglePropertyAndNullValue() public pure {
        JsonWriter.Json memory json;
        json = json.writeStartObject();
        json = json.writeNullProperty("prop");
        json = json.writeEndObject();

        assertEq(json.toString(), '{"prop": null}');
    }

    function test_writesObjectWithMultiplePropertiesAndNullValues() public pure {
        JsonWriter.Json memory json;
        json = json.writeStartObject();
        json = json.writeNullProperty("prop1");
        json = json.writeNullProperty("prop2");
        json = json.writeEndObject();

        assertEq(json.toString(), '{"prop1": null,"prop2": null}');
    }
}
