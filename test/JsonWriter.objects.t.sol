// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {JsonWriter} from "../src/JsonWriter.sol";

contract JsonWriterObjectTest is Test {
    using JsonWriter for JsonWriter.Json;

    function test_writesEmptyObjectForInitialJSONString() public pure {
        JsonWriter.Json memory json;
        string memory output = json
            .writeStartObject()
            .writeEndObject()
            .toString();

        assertEq(output, "{}");
    }

    function test_writesObjectWithAnArrayProperty() public pure {
        JsonWriter.Json memory json;
        string memory output = json
            .writeStartObject()
                .writeStartArray("prop")
                .writeEndArray()
            .writeEndObject()
            .toString();

        assertEq(output, '{"prop": []}');
    }

    /// forge-config: default.allow_internal_expect_revert = true
    function test_revertOnExtraOpenBrace() public {
        JsonWriter.Json memory json;
        json = json.writeStartObject();

        vm.expectRevert(JsonWriter.UnbalancedJSON.selector);
        json.toString();
    }

    /// forge-config: default.allow_internal_expect_revert = true
    function test_revertOnExtraClosedBrace() public {
        JsonWriter.Json memory json;

        vm.expectRevert(JsonWriter.UnbalancedJSON.selector);
        json.writeEndObject();
    }
}
