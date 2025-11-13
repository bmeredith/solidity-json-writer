// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {JsonWriter} from "../src/JsonWriter.sol";

contract JsonWriterIntTest is Test {
    using JsonWriter for JsonWriter.Json;

    struct IntTestCase {
        int256 arg;
        string expected;
    }

    function fixtureValues() public pure returns (IntTestCase[] memory) {
        IntTestCase[] memory entries = new IntTestCase[](5);
        entries[0] = IntTestCase(-1, "-1");
        entries[1] = IntTestCase(0, "0");
        entries[2] = IntTestCase(1, "1");
        entries[3] = IntTestCase(
            -57896044618658097711785492504343953926634992332820282019728792003956564819968,
            "-57896044618658097711785492504343953926634992332820282019728792003956564819968"
        );
        entries[4] = IntTestCase(
            57896044618658097711785492504343953926634992332820282019728792003956564819967,
            "57896044618658097711785492504343953926634992332820282019728792003956564819967"
        );

        return entries;
    }

    function table_writesIntValueOf(IntTestCase memory values) public pure {
        JsonWriter.Json memory json;
        json = json.writeIntValue(values.arg);

        assertEq(json.value, values.expected);
    }

    function test_writesArrayWithSingleIntValue() public pure {
        JsonWriter.Json memory json;
        json = json.writeStartArray();
        json = json.writeIntValue(-1);
        json = json.writeEndArray();

        assertEq(json.value, "[-1]");
    }

    function test_writesArrayWithMultipleIntValues() public pure {
        JsonWriter.Json memory json;
        json = json.writeStartArray();
        json = json.writeIntValue(-1);
        json = json.writeIntValue(1);
        json = json.writeEndArray();

        assertEq(json.value, "[-1,1]");
    }

    function fixtureProperties() public pure returns (IntTestCase[] memory) {
        IntTestCase[] memory entries = new IntTestCase[](5);
        entries[0] = IntTestCase(-1, '"prop": -1');
        entries[1] = IntTestCase(0, '"prop": 0');
        entries[2] = IntTestCase(1, '"prop": 1');
        entries[3] = IntTestCase(
            -57896044618658097711785492504343953926634992332820282019728792003956564819968,
            '"prop": -57896044618658097711785492504343953926634992332820282019728792003956564819968'
        );
        entries[4] = IntTestCase(
            57896044618658097711785492504343953926634992332820282019728792003956564819967,
            '"prop": 57896044618658097711785492504343953926634992332820282019728792003956564819967'
        );

        return entries;
    }

    function table_writesIntPropertyOf(IntTestCase memory properties) public pure {
        JsonWriter.Json memory json;
        json = json.writeIntProperty("prop", properties.arg);

        assertEq(json.value, properties.expected);
    }

    function test_writesObjectWithSingleIntPropertyAndValue() public pure {
        JsonWriter.Json memory json;
        json = json.writeStartObject();
        json = json.writeIntProperty("prop", -1);
        json = json.writeEndObject();

        assertEq(json.value, '{"prop": -1}');
    }

    function test_writesObjectWithMultipleIntPropertiesAndValues() public pure {
        JsonWriter.Json memory json;
        json = json.writeStartObject();
        json = json.writeIntProperty("prop1", -1);
        json = json.writeIntProperty("prop2", 1);
        json = json.writeEndObject();

        assertEq(json.value, '{"prop1": -1,"prop2": 1}');
    }
}
