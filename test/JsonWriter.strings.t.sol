// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {JsonWriter} from "../src/JsonWriter.sol";

contract JsonWriterStringTest is Test {
    using JsonWriter for JsonWriter.Json;

    struct StringTestCase {
        string arg;
        string expected;
    }

    function fixtureValues() public pure returns (StringTestCase[] memory) {
        StringTestCase[] memory entries = new StringTestCase[](3);
        entries[0] = StringTestCase("", '""');
        entries[1] = StringTestCase("test", '"test"');
        entries[2] = StringTestCase("1234", '"1234"');

        return entries;
    }

    function table_writesStringValueOf(StringTestCase memory values) public pure {
        JsonWriter.Json memory json;
        string memory output = json
            .writeStringValue(values.arg)
            .toString();

        assertEq(output, values.expected);
    }

    function test_writesArrayWithSingleStringValue() public pure {
        JsonWriter.Json memory json;
        string memory output = json
            .writeStartArray()
                .writeStringValue("test")
            .writeEndArray()
            .toString();

        assertEq(output, '["test"]');
    }

    function test_writesArrayWithMultipleStringValues() public pure {
        JsonWriter.Json memory json;
        string memory output = json
            .writeStartArray()
                .writeStringValue("test")
                .writeStringValue("test")
            .writeEndArray()
            .toString();

        assertEq(output, '["test","test"]');
    }

    function fixtureProperties() public pure returns (StringTestCase[] memory) {
        StringTestCase[] memory entries = new StringTestCase[](3);
        entries[0] = StringTestCase("", '"prop": ""');
        entries[1] = StringTestCase("test", '"prop": "test"');
        entries[2] = StringTestCase("1234", '"prop": "1234"');

        return entries;
    }

    function table_writesStringPropertyOf(StringTestCase memory properties) public pure {
        JsonWriter.Json memory json;
        string memory output = json
            .writeStringProperty("prop", properties.arg)
            .toString();

        assertEq(output, properties.expected);
    }

    function test_writesObjectWithSingleStringPropertyAndValue() public pure {
        JsonWriter.Json memory json;
        string memory output = json
            .writeStartObject()
                .writeStringProperty("prop", "value")
            .writeEndObject()
            .toString();

        assertEq(output, '{"prop": "value"}');
    }

    function test_writesObjectWithMultipleStringPropertiesAndValues() public pure {
        JsonWriter.Json memory json;
        string memory output = json
            .writeStartObject()
                .writeStringProperty("prop1", "value1")
                .writeStringProperty("prop2", "value2")
            .writeEndObject()
            .toString();

        assertEq(output, '{"prop1": "value1","prop2": "value2"}');
    }

    function fixtureEscapeChars() public pure returns (StringTestCase[] memory) {
        StringTestCase[] memory entries = new StringTestCase[](13);
        entries[0] = StringTestCase("\\", '"\\\\"');
        entries[1] = StringTestCase("\x08", '"\\b"');
        entries[2] = StringTestCase("\r", '"\\r"');
        entries[3] = StringTestCase('"', '"\\""');
        entries[4] = StringTestCase("\x0c", '"\\f"');
        entries[5] = StringTestCase("\t", '"\\t"');
        entries[6] = StringTestCase("\n", '"\\n"');
        entries[7] = StringTestCase("\x00", '"\\u0000"');
        entries[8] = StringTestCase("\x0b", '"\\u000b"');
        entries[9] = StringTestCase("\x1f", '"\\u001f"');
        entries[10] = StringTestCase("", '""');
        entries[11] = StringTestCase({
            arg: string(abi.encodePacked("a", "\n", "b", "\"", "c", "\x01", "d")),
            expected: '"a\\nb\\\"c\\u0001d"'
        });
        entries[12] = StringTestCase({
            arg: "Hello, world! 123 _-+=/",
            expected: '"Hello, world! 123 _-+=/"'
        });

        return entries;
    }

    function table_escapesChars(StringTestCase memory escapeChars) public pure {
        JsonWriter.Json memory json;
        string memory output = json
            .writeStringValue(escapeChars.arg)
            .toString();

        assertEq(output, escapeChars.expected);
    }

    function test_escapeAllControlChars() public pure { 
        bytes memory raw = new bytes(0x20);
        for (uint8 i=0; i < 0x20; i++) {
            raw[i] = bytes1(i);
        }

        JsonWriter.Json memory json;
        string memory output = json
            .writeStringValue(string(raw))
            .toString();
        bytes memory b = bytes(output);

        for (uint256 i=0; i < b.length; i++) {
            assertTrue(uint8(b[i]) >= 0x20, "Unescaped control char present");
        }
    }
}
