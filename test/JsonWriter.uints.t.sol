// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {JsonWriter} from "../src/JsonWriter.sol";

contract JsonWriterUintTest is Test {
    using JsonWriter for JsonWriter.Json;

    struct UintTestCase {
        uint arg;
        string expected;
    }

    function fixtureValues() public pure returns (UintTestCase[] memory) {
        UintTestCase[] memory entries = new UintTestCase[](3);
        entries[0] = UintTestCase(0, '0');
        entries[1] = UintTestCase(1, '1');
        entries[2] = UintTestCase(
            115792089237316195423570985008687907853269984665640564039457584007913129639935, 
            '115792089237316195423570985008687907853269984665640564039457584007913129639935'
        );

        return entries;
    }

    function table_writesUintValueOf(UintTestCase memory values) public pure {
        JsonWriter.Json memory json;
        json = json.writeUintValue(values.arg);

        assertEq(json.value, values.expected);
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

    function fixtureProperties() public pure returns (UintTestCase[] memory) {
        UintTestCase[] memory entries = new UintTestCase[](3);
        entries[0] = UintTestCase(0, '"prop": 0');
        entries[1] = UintTestCase(1, '"prop": 1');
        entries[2] = UintTestCase(
            115792089237316195423570985008687907853269984665640564039457584007913129639935, 
            '"prop": 115792089237316195423570985008687907853269984665640564039457584007913129639935'
        );

        return entries;
    }

    function table_writesUintPropertyOf(UintTestCase memory properties) public pure {
        JsonWriter.Json memory json;
        json = json.writeUintProperty('prop', properties.arg);

        assertEq(json.value, properties.expected);
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