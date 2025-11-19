# Solidity JSON Writer

[![npm version][npm-version-src]][npm-version-href]
[![status][github-actions-src]][github-actions-href]

**A library to aid in the generation and construction of JSON for smart contract development.**

A lightweight, gas-optimized Solidity library for constructing RFC-7159 compliant JSON on-chain.

Useful for:
* On-chain ERC-721 / ERC-1155 metadata
* On-chain SVG + JSON
* Encoding structured responses for off-chain interpreters
* Deterministic JSON serialization inside smart contracts

## Features
* Fully RFC-7159 compliant JSON
* No external dependencies
* Supports arbitrary nesting of objects and arrays
* Full JSON string escaping
* Validates structure and depth

## Installation

```console
$ npm install solidity-json-writer
```

## Foundry Setup
Add remapping to `foundry.toml`:

```toml
remappings = [
  "solidity-json-writer/=node_modules/solidity-json-writer/src/"
]
```

## Usage Example

Below is a minimal ERC-721 that outputs a fully on-chain JSON metadata:

```solidity
pragma solidity ^0.8.20;

import "solidity-json-writer/JsonWriter.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { Base64 } "@openzeppelin/contracts/utils/Base64.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";

contract OnchainMetadataExample is ERC721 {
    using JsonWriter for JsonWriter.Json;
    
    constructor() ERC721("OnchainCreature", "OCC") {
        _mint(msg.sender, 1);
    }

    function tokenURI(uint256 tokenId) public pure override returns (string memory) {
        JsonWriter.Json memory json;

        json = json.writeStartObject()
            .writeStringProperty("name", string.concat("Onchain Creature #", Strings.toString(tokenId)))
            .writeStringProperty("description", "A fully onchain NFT stored in Base64 JSON.")
            .writeStringProperty("image", string.concat("data:image/svg+xml;base64,", generateImage()))
            .writeStartArray("attributes");
                json = json.writeStartObject()
                    .writeStringProperty("trait_type", "Base")
                    .writeStringProperty("value", "Starfish")
                .writeEndObject();
                json = json.writeStartObject()
                    .writeStringProperty("trait_type", "Level")
                    .writeUintProperty("value", 5)
                .writeEndObject();
                json = json.writeStartObject()
                    .writeStringProperty("trait_type", "Created By")
                    .writeAddressProperty("value", 0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045)
                .writeEndObject()
            .writeEndArray()
        .writeEndObject();

        return string.concat(
            "data:application/json;base64,", 
            Base64.encode(bytes(json.toString()))
        );
    }

    function generateImage() private pure returns (string memory) {
        return Base64.encode(bytes('<svg xmlns=\'http://www.w3.org/2000/svg\' viewBox=\'0 0 100 100\'><circle cx=\'50\' cy=\'50\' r=\'40\' fill=\'aqua\' /></svg>'));
    }
}
```

Resulting JSON:
```json
{
  "name": "Onchain Creature #1",
  "description": "A fully onchain NFT stored in Base64 JSON.",
  "image": "data:image/svg+xml;base64,...",
  "attributes": [{
    "trait_type": "Base",
    "value": "Starfish"
  }, {
    "trait_type": "Level",
    "value": 5
  }, {
    "trait_type": "Created By",
    "value": "0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045"
  }]
}
```

Note: Output is always compact/minified to minimize gas.

## Supported Types

| Solidity Type | JSON Type             |
| ------------- | --------------------- |
| `string`      | JSON string (escaped) |
| `bool`        | `true` / `false`      |
| `uint256`     | JSON number           |
| `int256`      | JSON number           |
| `address`     | `"0x...checksum"`     |
| `null`        | `null`                |


### ERC-721 Metadata Implementation

When using the library to generate JSON for ERC-721 metadata, there are a few things to take into account:

1. If the metadata's JSON does not contain [RFC-3986](https://datatracker.ietf.org/doc/html/rfc3986#section-2.2) reserved characters, `data:application/json,` should be prepended to that JSON.
2. If the metadata's JSON does contain reserved characters, prepend `data:application/json;base64,` and then encode the generated JSON as base64.

## License

JsonWriter is released under the [MIT License](LICENSE).

[npm-version-src]: https://img.shields.io/npm/v/solidity-json-writer?style=flat-square
[npm-version-href]: https://npmjs.com/package/solidity-json-writer

[npm-downloads-src]: https://img.shields.io/npm/dm/solidity-json-writer?style=flat-square
[npm-downloads-href]: https://npmjs.com/package/solidity-json-writer

[github-actions-src]: https://img.shields.io/github/actions/workflow/status/bmeredith/solidity-json-writer/test.yml?branch=main
[github-actions-href]: https://github.com/bmeredith/solidity-json-writer/actions?query=workflow%3ACI
