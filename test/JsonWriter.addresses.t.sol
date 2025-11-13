// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {JsonWriter} from "../src/JsonWriter.sol";

contract JsonWriterAddressTest is Test {
    using JsonWriter for JsonWriter.Json;

    struct AddressTestCase {
        address arg;
        string expected;
    }

    function fixtureValues() public pure returns (AddressTestCase[] memory) {
        AddressTestCase[] memory entries = new AddressTestCase[](5);
        entries[0] = AddressTestCase(0x0000000000000000000000000000000000000000, '"0x0000000000000000000000000000000000000000"');
        entries[1] = AddressTestCase(0x1111111111111111111111111111111111111111, '"0x1111111111111111111111111111111111111111"');
        entries[2] = AddressTestCase(0x6B175474E89094C44Da98b954EedeAC495271d0F, '"0x6B175474E89094C44Da98b954EedeAC495271d0F"');
        entries[3] = AddressTestCase(0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF, '"0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF"');
        entries[4] = AddressTestCase(0x000000000000000000000000000000000000dEaD, '"0x000000000000000000000000000000000000dEaD"');

        return entries;
    }

    function table_writesAddressValueOf(AddressTestCase memory values) public pure {
        JsonWriter.Json memory json;
        json = json.writeAddressValue(values.arg);

        assertEq(json.value, values.expected);
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

    function fixtureProperties() public pure returns (AddressTestCase[] memory) {
        AddressTestCase[] memory entries = new AddressTestCase[](5);
        entries[0] = AddressTestCase(0x0000000000000000000000000000000000000000, '"prop": "0x0000000000000000000000000000000000000000"');
        entries[1] = AddressTestCase(0x1111111111111111111111111111111111111111, '"prop": "0x1111111111111111111111111111111111111111"');
        entries[2] = AddressTestCase(0x6B175474E89094C44Da98b954EedeAC495271d0F, '"prop": "0x6B175474E89094C44Da98b954EedeAC495271d0F"');
        entries[3] = AddressTestCase(0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF, '"prop": "0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF"');
        entries[4] = AddressTestCase(0x000000000000000000000000000000000000dEaD, '"prop": "0x000000000000000000000000000000000000dEaD"');

        return entries;
    }

    function table_writesAddressPropertyOf(AddressTestCase memory properties) public pure {
        JsonWriter.Json memory json;
        json = json.writeAddressProperty('prop', properties.arg);

        assertEq(json.value, properties.expected);
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