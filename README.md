# JSON Writer

[![npm version][npm-version-src]][npm-version-href]

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

import "solidity-json-writer/JsonWriter.sol";

contract ExampleContract {
    
    using JsonWriter for JsonWriter.Json;

    function generateJSON() external pure returns (string memory) {
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
{"Years old": 5,"Lowest temp": -30,"CPU": "Intel","CPU": "Intel","Drives": ["500 gigabyte SSD","2 terabyte hard drive"]}
```

In order to optimize gas, the JSON outputted is not pretty-printed. 

Here is the resulting JSON, but pretty-printed:.
```
{
    "Years old": 5,
    "Lowest temp": -30,
    "CPU": "Intel",
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

Note: although the concept of `null` does not exist within Solidity, JsonWriter is capable of generating properties and values of `null`.

The full API documentation for JsonWriter can be found in the [docs](docs/JsonWriter.md).

## License

JsonWriter is released under the [MIT License](LICENSE).

[npm-version-src]: https://img.shields.io/npm/v/solidity-json-writer?style=flat-square
[npm-version-href]: https://npmjs.com/package/solidity-json-writer

[npm-downloads-src]: https://img.shields.io/npm/dm/solidity-json-writer?style=flat-square
[npm-downloads-href]: https://npmjs.com/package/solidity-json-writer
