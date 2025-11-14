// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {JsonWriter} from "../src/JsonWriter.sol";

contract JsonWriterObjectTest is Test {
    using JsonWriter for JsonWriter.Json;

    function test_writesEmptyObjectForInitialJSONString() public pure {
        JsonWriter.Json memory json;
        json = json.writeStartObject();
        json = json.writeEndObject();

        assertEq(json.toString(), "{}");
    }

    function test_writesObjectWithAnArrayProperty() public pure {
        JsonWriter.Json memory json;
        json = json.writeStartObject();
        json = json.writeStartArray("prop");
        json = json.writeEndArray();
        json = json.writeEndObject();

        assertEq(json.toString(), '{"prop": []}');
    }
}
