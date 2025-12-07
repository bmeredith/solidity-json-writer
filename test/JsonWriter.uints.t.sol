// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {JsonWriter} from "../src/JsonWriter.sol";

contract JsonWriterUintTest is Test {
    using JsonWriter for JsonWriter.Json;

    struct UintTestCase {
        uint256 arg;
        string expected;
    }

    function fixtureValues() public pure returns (UintTestCase[] memory) {
        UintTestCase[] memory entries = new UintTestCase[](3);
        entries[0] = UintTestCase({ arg: 0, expected: "0" });
        entries[1] = UintTestCase({ arg: 1, expected: "1" });
        entries[2] = UintTestCase({
            arg: 115792089237316195423570985008687907853269984665640564039457584007913129639935,
            expected: "115792089237316195423570985008687907853269984665640564039457584007913129639935"
        });

        return entries;
    }

    function table_writesUintValueOf(UintTestCase memory values) public pure {
        JsonWriter.Json memory json;
        string memory output = json
            .writeUintValue(values.arg)
            .toString();

        assertEq(output, values.expected);
    }

    function test_writesArrayWithSingleUintValue() public pure {
        JsonWriter.Json memory json;
        string memory output = json
            .writeStartArray()
                .writeUintValue(1)
            .writeEndArray()
            .toString();

        assertEq(output, "[1]");
    }

    function test_writesArrayWithMultipleUintValues() public pure {
        JsonWriter.Json memory json;
        string memory output = json
            .writeStartArray()
                .writeUintValue(1)
                .writeUintValue(2)
            .writeEndArray()
            .toString();

        assertEq(output, "[1,2]");
    }

    function fixtureProperties() public pure returns (UintTestCase[] memory) {
        UintTestCase[] memory entries = new UintTestCase[](3);
        entries[0] = UintTestCase({ arg: 0, expected: '"prop":0'});
        entries[1] = UintTestCase({ arg: 1, expected: '"prop":1'});
        entries[2] = UintTestCase({
            arg: 115792089237316195423570985008687907853269984665640564039457584007913129639935,
            expected: '"prop":115792089237316195423570985008687907853269984665640564039457584007913129639935'
        });

        return entries;
    }

    function table_writesUintPropertyOf(UintTestCase memory properties) public pure {
        JsonWriter.Json memory json;
        string memory output = json
            .writeUintProperty("prop", properties.arg)
            .toString();

        assertEq(output, properties.expected);
    }

    function test_writesObjectWithSingleUintPropertyAndValue() public pure {
        JsonWriter.Json memory json;
        string memory output = json
            .writeStartObject()
                .writeUintProperty("prop", 1)
            .writeEndObject()
            .toString();

        assertEq(output, '{"prop":1}');
    }

    function test_writesObjectWithMultipleUintPropertiesAndValues() public pure {
        JsonWriter.Json memory json;
        string memory output = json
            .writeStartObject()
                .writeIntProperty("prop1", 1)
                .writeIntProperty("prop2", 2)
            .writeEndObject()
            .toString();

        assertEq(output, '{"prop1":1,"prop2":2}');
    }
}
