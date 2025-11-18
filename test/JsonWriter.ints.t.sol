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
        entries[0] = IntTestCase({ arg: -1, expected: "-1" });
        entries[1] = IntTestCase({ arg: 0, expected: "0" });
        entries[2] = IntTestCase({ arg: 1, expected: "1" });
        entries[3] = IntTestCase({
            arg: -57896044618658097711785492504343953926634992332820282019728792003956564819968,
            expected: "-57896044618658097711785492504343953926634992332820282019728792003956564819968"
        });
        entries[4] = IntTestCase({
            arg: 57896044618658097711785492504343953926634992332820282019728792003956564819967,
            expected: "57896044618658097711785492504343953926634992332820282019728792003956564819967"
        });

        return entries;
    }

    function table_writesIntValueOf(IntTestCase memory values) public pure {
        JsonWriter.Json memory json;
        string memory output = json
            .writeIntValue(values.arg)
            .toString();

        assertEq(output, values.expected);
    }

    function test_writesArrayWithSingleIntValue() public pure {
        JsonWriter.Json memory json;
        string memory output = json
            .writeStartArray()
                .writeIntValue(-1)
            .writeEndArray()
            .toString();

        assertEq(output, "[-1]");
    }

    function test_writesArrayWithMultipleIntValues() public pure {
        JsonWriter.Json memory json;
        string memory output = json
            .writeStartArray()
                .writeIntValue(-1)
                .writeIntValue(1)
            .writeEndArray()
            .toString();

        assertEq(output, "[-1,1]");
    }

    function fixtureProperties() public pure returns (IntTestCase[] memory) {
        IntTestCase[] memory entries = new IntTestCase[](5);
        entries[0] = IntTestCase({ arg: -1, expected: '"prop": -1' });
        entries[1] = IntTestCase({ arg: 0, expected: '"prop": 0' });
        entries[2] = IntTestCase({ arg: 1, expected: '"prop": 1' });
        entries[3] = IntTestCase({
            arg: -57896044618658097711785492504343953926634992332820282019728792003956564819968,
            expected: '"prop": -57896044618658097711785492504343953926634992332820282019728792003956564819968'
        });
        entries[4] = IntTestCase({
            arg: 57896044618658097711785492504343953926634992332820282019728792003956564819967,
            expected: '"prop": 57896044618658097711785492504343953926634992332820282019728792003956564819967'
        });

        return entries;
    }

    function table_writesIntPropertyOf(IntTestCase memory properties) public pure {
        JsonWriter.Json memory json;
        string memory output = json
            .writeIntProperty("prop", properties.arg)
            .toString();

        assertEq(output, properties.expected);
    }

    function test_writesObjectWithSingleIntPropertyAndValue() public pure {
        JsonWriter.Json memory json;
        string memory output = json
            .writeStartObject()
                .writeIntProperty("prop", -1)
            .writeEndObject()
            .toString();

        assertEq(output, '{"prop": -1}');
    }

    function test_writesObjectWithMultipleIntPropertiesAndValues() public pure {
        JsonWriter.Json memory json;
        string memory output = json
            .writeStartObject()
                .writeIntProperty("prop1", -1)
                .writeIntProperty("prop2", 1)
            .writeEndObject()
            .toString();

        assertEq(output, '{"prop1": -1,"prop2": 1}');
    }
}
