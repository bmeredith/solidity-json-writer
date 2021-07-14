# Solidity JSON Writer

[![npm version][npm-version-src]][npm-version-href]
[![status][github-actions-src]][github-actions-href]

**A library to aid in the generation and construction of JSON for smart contract development.**

Use the library to generate RFC-7159 compliant JSON from within a smart contract.

### Requirements
* Solidity 0.8+

### Installation

```console
$ npm install solidity-json-writer
```

### Usage

Once installed, you can use the library by importing it:

```solidity
pragma solidity ^0.8.0;

import "solidity-json-writer/contracts/JsonWriter.sol";

contract ExampleContract {
    
    using JsonWriter for JsonWriter.Json;

    function generateJSON() external pure returns (string memory) {
        JsonWriter.Json memory writer;

        writer = writer.writeStartObject();
        writer = writer.writeStringProperty("Product", "PC");
        writer = writer.writeUintProperty("YearsOld", 5);
        writer = writer.writeIntProperty("LowestTemp", -30);
        writer = writer.writeStringProperty("CPU", "Intel");
        writer = writer.writeStartArray("Drives");
        writer = writer.writeStringValue("500 gigabyte SSD");
        writer = writer.writeStringValue("2 terabyte hard drive");
        writer = writer.writeEndArray();
        writer = writer.writeEndObject();

        return writer.value;
    }
}
```

Output:
```
{"Product": "PC","YearsOld": 5,"LowestTemp": -30,"CPU": "Intel","Drives": ["500 gigabyte SSD","2 terabyte hard drive"]}
```

Note: In order to optimize gas, the JSON generated within the smart contract is not pretty-printed. 

Pretty-printed output:
```
{
    "Product": "PC",
    "YearsOld": 5,
    "LowestTemp": -30,
    "CPU": "Intel",
    "Drives": [
	"500 gigabyte SSD", 
	"2 terabyte hard drive"
    ]
}
```

JsonWriter supports the following Solidity primitives:
* `address`
* `bool`
* `int`
* `string`
* `uint`

Although the concept of `null` does not exist within Solidity, JsonWriter is capable of generating properties and values of `null`.

The full API documentation for JsonWriter can be found in the [docs](docs/JsonWriter.md).

## License

JsonWriter is released under the [MIT License](LICENSE).

[npm-version-src]: https://img.shields.io/npm/v/solidity-json-writer?style=flat-square
[npm-version-href]: https://npmjs.com/package/solidity-json-writer

[npm-downloads-src]: https://img.shields.io/npm/dm/solidity-json-writer?style=flat-square
[npm-downloads-href]: https://npmjs.com/package/solidity-json-writer

[github-actions-src]: https://img.shields.io/github/workflow/status/bmeredith/solidity-json-writer/solidity-json-writer%20CI
[github-actions-href]: https://github.com/bmeredith/solidity-json-writer/actions?query=workflow%3Aci
