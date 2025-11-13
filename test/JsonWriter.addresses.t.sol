// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {JsonWriter} from "../src/JsonWriter.sol";

contract JsonWriterAddressTest is Test {
    using JsonWriter for JsonWriter.Json;

    function test_writesAddressValueOf() public pure {
        JsonWriter.Json memory json;

        assertEq(json.value, ' ');
    }

    function test_writesArrayWithSingleAddressValue() public pure {
        JsonWriter.Json memory json;
        json = json.writeStartArray();
        json = json.writeAddressValue(0x1111111111111111111111111111111111111111);
        json = json.writeEndArray();

        assertEq(json.value, '["0x1111111111111111111111111111111111111111"]');
    }

    function test_writesArrayWithMultipleAddressValues() public pure {
        JsonWriter.Json memory json;
        json = json.writeStartArray();
        json = json.writeAddressValue(0x1111111111111111111111111111111111111111);
        json = json.writeAddressValue(0x2222222222222222222222222222222222222222);
        json = json.writeEndArray();

        assertEq(json.value, '["0x1111111111111111111111111111111111111111","0x2222222222222222222222222222222222222222"]');
    }

    function test_writesAddressPropertyOf() public pure {
        JsonWriter.Json memory json;

        assertEq(json.value, ' ');
    }

    function test_writesObjectWithSingleAddressPropertyAndValue() public pure {
        JsonWriter.Json memory json;
        json = json.writeStartObject();
        json = json.writeAddressProperty('prop', 0x1111111111111111111111111111111111111111);
        json = json.writeEndObject();

        assertEq(json.value, '{"prop": "0x1111111111111111111111111111111111111111"}');
    }

    function test_writesObjectWithMultipleAddressPropertiesAndValues() public pure {
        JsonWriter.Json memory json;
        json = json.writeStartObject();
        json = json.writeAddressProperty('prop1', 0x1111111111111111111111111111111111111111);
        json = json.writeAddressProperty('prop2', 0x2222222222222222222222222222222222222222);
        json = json.writeEndObject();

        assertEq(json.value, '{"prop1": "0x1111111111111111111111111111111111111111","prop2": "0x2222222222222222222222222222222222222222"}');
    }
}