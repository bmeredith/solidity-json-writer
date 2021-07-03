const { expect } = require('chai');

describe('JsonWriter', function () {

  beforeEach(async function () {
    const JsonWriterMock = await ethers.getContractFactory('JsonWriterMock');
    jsonWriter = await JsonWriterMock.deploy();
  });

  function createJsonObject() {
    return {
      depthBitTracker: 0,
      value: ''
    };
  }

  describe('arrays', function () {
    it('creates empty array for an initial JSON string', async function () {
      let json = createJsonObject();
      json = await jsonWriter.writeStartArray(json);
      json = await jsonWriter.writeEndArray(json);

      expect(json.value).to.equal('[]');
    });

    it('creates array within an array', async function () {
      let json = createJsonObject();
      json = await jsonWriter.writeStartArray(json);
      json = await jsonWriter.writeStartArray(json);
      json = await jsonWriter.writeEndArray(json);
      json = await jsonWriter.writeEndArray(json);

      expect(json.value).to.equal('[[]]');
    });

    it('creates multiple arrays within an array', async function () {
      let json = createJsonObject();
      json = await jsonWriter.writeStartArray(json);
      json = await jsonWriter.writeStartArray(json);
      json = await jsonWriter.writeEndArray(json);
      json = await jsonWriter.writeStartArray(json);
      json = await jsonWriter.writeEndArray(json);
      json = await jsonWriter.writeEndArray(json);

      expect(json.value).to.equal('[[],[]]');
    });

    it('creates array with a nested object', async function () {
      let json = createJsonObject();
      json = await jsonWriter.writeStartArray(json);
      json = await jsonWriter.writeStartObject(json);
      json = await jsonWriter.writeEndObject(json);
      json = await jsonWriter.writeEndArray(json);

      expect(json.value).to.equal('[{}]');
    });

    it('creates array with multiple nested objects', async function () {
      let json = createJsonObject();
      json = await jsonWriter.writeStartArray(json);
      json = await jsonWriter.writeStartObject(json);
      json = await jsonWriter.writeEndObject(json);
      json = await jsonWriter.writeStartObject(json);
      json = await jsonWriter.writeEndObject(json);
      json = await jsonWriter.writeEndArray(json);

      expect(json.value).to.equal('[{},{}]');
    });
  });

  describe('objects', function () {
    it('creates empty object for an initial JSON string', async function () {
      let json = createJsonObject();
      json = await jsonWriter.writeStartObject(json);
      json = await jsonWriter.writeEndObject(json);

      expect(json.value).to.equal('{}');
    });

    it('creates object with an array property', async function () {
      let json = createJsonObject();
      json = await jsonWriter.writeStartObject(json);
      json = await jsonWriter.writeStartArrayProperty(json, 'prop');
      json = await jsonWriter.writeEndArray(json);
      json = await jsonWriter.writeEndObject(json);

      expect(json.value).to.equal('{"prop": []}');
    });
  });

  describe('addresses', function () {
    describe('properties', function () {
      const tests = [
        { arg: '0x0000000000000000000000000000000000000000', expected: '{"prop": "0x0000000000000000000000000000000000000000"}' },
        { arg: '0x1111111111111111111111111111111111111111', expected: '{"prop": "0x1111111111111111111111111111111111111111"}' },
        { arg: '0x6b175474e89094c44da98b954eedeac495271d0f', expected: '{"prop": "0x6b175474e89094c44da98b954eedeac495271d0f"}' },
        { arg: '0xffffffffffffffffffffffffffffffffffffffff', expected: '{"prop": "0xffffffffffffffffffffffffffffffffffffffff"}' }
      ];

      tests.forEach(({ arg, expected }) => {
        it(`writes address property of ${arg}`, async function () {
          let json = createJsonObject();
          json = await jsonWriter.writeStartObject(json);
          json = await jsonWriter.writeAddressProperty(json, 'prop', arg);
          json = await jsonWriter.writeEndObject(json);

          expect(json.value).to.equal(expected);
        });
      });

      it('creates object with a single property and value', async function () {
        let json = createJsonObject();
        json = await jsonWriter.writeStartObject(json);
        json = await jsonWriter.writeAddressProperty(json, 'prop', '0x1111111111111111111111111111111111111111');
        json = await jsonWriter.writeEndObject(json);

        expect(json.value).to.equal('{"prop": "0x1111111111111111111111111111111111111111"}');
      });

      it('creates object with multiple properties and values', async function () {
        let json = createJsonObject();
        json = await jsonWriter.writeStartObject(json);
        json = await jsonWriter.writeAddressProperty(json, 'prop1', '0x1111111111111111111111111111111111111111');
        json = await jsonWriter.writeAddressProperty(json, 'prop2', '0x2222222222222222222222222222222222222222');
        json = await jsonWriter.writeEndObject(json);

        expect(json.value).to.equal('{"prop1": "0x1111111111111111111111111111111111111111","prop2": "0x2222222222222222222222222222222222222222"}');
      });
    });

    describe('values', function () {
      const tests = [
        { arg: '0x0000000000000000000000000000000000000000', expected: '"0x0000000000000000000000000000000000000000"' },
        { arg: '0x1111111111111111111111111111111111111111', expected: '"0x1111111111111111111111111111111111111111"' },
        { arg: '0x6b175474e89094c44da98b954eedeac495271d0f', expected: '"0x6b175474e89094c44da98b954eedeac495271d0f"' },
        { arg: '0xffffffffffffffffffffffffffffffffffffffff', expected: '"0xffffffffffffffffffffffffffffffffffffffff"' }
      ];

      tests.forEach(({ arg, expected }) => {
        it(`writes address value of ${arg}`, async function () {
          let json = createJsonObject();
          json = await jsonWriter.writeAddressValue(json, arg);

          expect(json.value).to.equal(expected);
        });
      });

      it('creates array with a single value', async function () {
        let json = createJsonObject();
        json = await jsonWriter.writeStartArray(json);
        json = await jsonWriter.writeAddressValue(json, '0x1111111111111111111111111111111111111111');
        json = await jsonWriter.writeEndArray(json);

        expect(json.value).to.equal('["0x1111111111111111111111111111111111111111"]');
      });

      it('creates array with multiple values', async function () {
        let json = createJsonObject();
        json = await jsonWriter.writeStartArray(json);
        json = await jsonWriter.writeAddressValue(json, '0x1111111111111111111111111111111111111111');
        json = await jsonWriter.writeAddressValue(json, '0x1111111111111111111111111111111111111111');
        json = await jsonWriter.writeEndArray(json);

        expect(json.value).to.equal('["0x1111111111111111111111111111111111111111","0x1111111111111111111111111111111111111111"]');
      });
    });
  });

  describe('booleans', function () {

    it('writes boolean property of \'true\'', async function () {
      let json = createJsonObject();
      json = await jsonWriter.writeBooleanProperty(json, 'prop', true);

      expect(json.value).to.equal('"prop": true');
    });

    it('writes boolean property of \'false\'', async function () {
      let json = createJsonObject();
      json = await jsonWriter.writeBooleanProperty(json, 'prop', false);

      expect(json.value).to.equal('"prop": false');
    });

    it('writes boolean value of \'true\'', async function () {
      let json = createJsonObject();
      json = await jsonWriter.writeBooleanValue(json, true);

      expect(json.value).to.equal('true');
    });

    it('writes boolean value of \'false\'', async function () {
      let json = createJsonObject();
      json = await jsonWriter.writeBooleanValue(json, false);

      expect(json.value).to.equal('false');
    });

    it('creates array with a single value', async function () {
      let json = createJsonObject();
      json = await jsonWriter.writeStartArray(json);
      json = await jsonWriter.writeBooleanValue(json, true);
      json = await jsonWriter.writeEndArray(json);

      expect(json.value).to.equal('[true]');
    });

    it('creates array with multiple values', async function () {
      let json = createJsonObject();
      json = await jsonWriter.writeStartArray(json);
      json = await jsonWriter.writeBooleanValue(json, true);
      json = await jsonWriter.writeBooleanValue(json, true);
      json = await jsonWriter.writeEndArray(json);

      expect(json.value).to.equal('[true,true]');
    });

    it('creates object with a single property and value', async function () {
      let json = createJsonObject();
      json = await jsonWriter.writeStartObject(json);
      json = await jsonWriter.writeBooleanProperty(json, 'prop', true);
      json = await jsonWriter.writeEndObject(json);

      expect(json.value).to.equal('{"prop": true}');
    });

    it('creates object with multiple properties and values', async function () {
      let json = createJsonObject();
      json = await jsonWriter.writeStartObject(json);
      json = await jsonWriter.writeBooleanProperty(json, 'prop1', true);
      json = await jsonWriter.writeBooleanProperty(json, 'prop2', true);
      json = await jsonWriter.writeEndObject(json);

      expect(json.value).to.equal('{"prop1": true,"prop2": true}');
    });
  });

  describe('ints', function () {
    describe('properties', function () {
      const tests = [
        { arg: -1, expected: '"prop": -1' },
        { arg: 0, expected: '"prop": 0' },
        { arg: 1, expected: '"prop": 1' },
        {
          arg: '-57896044618658097711785492504343953926634992332820282019728792003956564819968',
          expected: '"prop": -57896044618658097711785492504343953926634992332820282019728792003956564819968'
        },
        {
          arg: '57896044618658097711785492504343953926634992332820282019728792003956564819967',
          expected: '"prop": 57896044618658097711785492504343953926634992332820282019728792003956564819967'
        }
      ];

      tests.forEach(({ arg, expected }) => {
        it(`writes int property of ${arg}`, async function () {
          let json = createJsonObject();
          json = await jsonWriter.writeIntProperty(json, 'prop', arg);

          expect(json.value).to.equal(expected);
        });
      });

      it('creates object with a single property and value', async function () {
        let json = createJsonObject();
        json = await jsonWriter.writeStartObject(json);
        json = await jsonWriter.writeIntProperty(json, 'prop', 1);
        json = await jsonWriter.writeEndObject(json);

        expect(json.value).to.equal('{"prop": 1}');
      });

      it('creates object with multiple properties and values', async function () {
        let json = createJsonObject();
        json = await jsonWriter.writeStartObject(json);
        json = await jsonWriter.writeIntProperty(json, 'prop1', -1);
        json = await jsonWriter.writeIntProperty(json, 'prop2', 1);
        json = await jsonWriter.writeEndObject(json);

        expect(json.value).to.equal('{"prop1": -1,"prop2": 1}');
      });
    });

    describe('values', function () {
      const tests = [
        { arg: -1, expected: '-1' },
        { arg: 0, expected: '0' },
        { arg: 1, expected: '1' },
        {
          arg: '-57896044618658097711785492504343953926634992332820282019728792003956564819968',
          expected: '-57896044618658097711785492504343953926634992332820282019728792003956564819968'
        },
        {
          arg: '57896044618658097711785492504343953926634992332820282019728792003956564819967',
          expected: '57896044618658097711785492504343953926634992332820282019728792003956564819967'
        }
      ];

      tests.forEach(({ arg, expected }) => {
        it(`writes int value of ${arg}`, async function () {
          let json = createJsonObject();
          json = await jsonWriter.writeIntValue(json, arg);

          expect(json.value).to.equal(expected);
        });
      });

      it('creates array with a single value', async function () {
        let json = createJsonObject();
        json = await jsonWriter.writeStartArray(json);
        json = await jsonWriter.writeIntValue(json, 1);
        json = await jsonWriter.writeEndArray(json);

        expect(json.value).to.equal('[1]');
      });

      it('creates array with multiple values', async function () {
        let json = createJsonObject();
        json = await jsonWriter.writeStartArray(json);
        json = await jsonWriter.writeIntValue(json, -1);
        json = await jsonWriter.writeIntValue(json, 1);
        json = await jsonWriter.writeEndArray(json);

        expect(json.value).to.equal('[-1,1]');
      });
    });
  });

  describe('nulls', function () {
    describe('properties', function () {
      it('writes property with value of null', async function () {
        let json = createJsonObject();
        json = await jsonWriter.writeNullProperty(json, 'prop');

        expect(json.value).to.equal('"prop": null');
      });

      it('creates object with a single property and value', async function () {
        let json = createJsonObject();
        json = await jsonWriter.writeStartObject(json);
        json = await jsonWriter.writeNullProperty(json, 'prop');
        json = await jsonWriter.writeEndObject(json);

        expect(json.value).to.equal('{"prop": null}');
      });

      it('creates object with multiple properties and values', async function () {
        let json = createJsonObject();
        json = await jsonWriter.writeStartObject(json);
        json = await jsonWriter.writeNullProperty(json, 'prop1');
        json = await jsonWriter.writeNullProperty(json, 'prop2');
        json = await jsonWriter.writeEndObject(json);

        expect(json.value).to.equal('{"prop1": null,"prop2": null}');
      });
    });

    describe('values', function () {
      it('writes null value', async function () {
        let json = createJsonObject();
        json = await jsonWriter.writeNullValue(json);

        expect(json.value).to.equal('null');
      });

      it('creates array with a single value', async function () {
        let json = createJsonObject();
        json = await jsonWriter.writeStartArray(json);
        json = await jsonWriter.writeNullValue(json);
        json = await jsonWriter.writeEndArray(json);

        expect(json.value).to.equal('[null]');
      });

      it('creates array with multiple values', async function () {
        let json = createJsonObject();
        json = await jsonWriter.writeStartArray(json);
        json = await jsonWriter.writeNullValue(json);
        json = await jsonWriter.writeNullValue(json);
        json = await jsonWriter.writeEndArray(json);

        expect(json.value).to.equal('[null,null]');
      });
    });
  });

  describe('strings', function () {
    describe('properties', function () {
      const tests = [
        { arg: '', expected: '"prop": ""' },
        { arg: 'test', expected: '"prop": "test"' },
        { arg: '1234', expected: '"prop": "1234"' }
      ];

      tests.forEach(({ arg, expected }) => {
        it(`writes string property of '${arg}'`, async function () {
          let json = createJsonObject();
          json = await jsonWriter.writeStringProperty(json, 'prop', arg);

          expect(json.value).to.equal(expected);
        });
      });

      it('creates object with a single property and value', async function () {
        let json = createJsonObject();
        json = await jsonWriter.writeStartObject(json);
        json = await jsonWriter.writeStringProperty(json, 'prop', 'value');
        json = await jsonWriter.writeEndObject(json);

        expect(json.value).to.equal('{"prop": "value"}');
      });

      it('creates object with multiple properties and values', async function () {
        let json = createJsonObject();
        json = await jsonWriter.writeStartObject(json);
        json = await jsonWriter.writeStringProperty(json, 'prop1', 'value1');
        json = await jsonWriter.writeStringProperty(json, 'prop2', 'value2');
        json = await jsonWriter.writeEndObject(json);

        expect(json.value).to.equal('{"prop1": "value1","prop2": "value2"}');
      });
    });

    describe('values', function () {
      const tests = [
        { arg: '', expected: '""' },
        { arg: 'test', expected: '"test"' },
        { arg: '1234', expected: '"1234"' },
      ];

      tests.forEach(({ arg, expected }) => {
        it(`writes string value of '${arg}'`, async function () {
          let json = createJsonObject();
          json = await jsonWriter.writeStringValue(json, arg);

          expect(json.value).to.equal(expected);
        });
      });

      it('creates array with a single value', async function () {
        let json = createJsonObject();
        json = await jsonWriter.writeStartArray(json);
        json = await jsonWriter.writeStringValue(json, 'test');
        json = await jsonWriter.writeEndArray(json);

        expect(json.value).to.equal('["test"]');
      });

      it('creates array with multiple values', async function () {
        let json = createJsonObject();
        json = await jsonWriter.writeStartArray(json);
        json = await jsonWriter.writeStringValue(json, 'test');
        json = await jsonWriter.writeStringValue(json, 'test');
        json = await jsonWriter.writeEndArray(json);

        expect(json.value).to.equal('["test","test"]');
      });
    });

    describe('JSON escape characters', function () {
      const tests = [
        { arg: '\\', argName: 'backslash', expected: '"\\\\"' },
        { arg: '\b', argName: 'backspace', expected: '"\\b"' },
        { arg: '\r', argName: 'carriage return', expected: '"\\r"' },
        { arg: '"', argName: 'double quote', expected: '"\\""' },
        { arg: '\f', argName: 'form feed', expected: '"\\f"' },
        { arg: '/', argName: 'front slash', expected: '"\\/"' },
        { arg: '\t', argName: 'horizontal tab', expected: '"\\t"' },
        { arg: '\n', argName: 'newline', expected: '"\\n"' }
      ];
      
      tests.forEach(({ arg, argName, expected }) => {
        it(`escapes the '${argName}' character`, async function () {
          let json = createJsonObject();
          json = await jsonWriter.writeStringValue(json, arg);
          expect(json.value).to.equal(expected);
        });
      });
    });
  });

  describe('uints', function () {
    describe('properties', function () {
      const tests = [
        { arg: 0, expected: '"prop": 0' },
        { arg: 1, expected: '"prop": 1' },
        {
          arg: '115792089237316195423570985008687907853269984665640564039457584007913129639935',
          expected: '"prop": 115792089237316195423570985008687907853269984665640564039457584007913129639935'
        }
      ];

      tests.forEach(({ arg, expected }) => {
        it(`writes uint property of ${arg}`, async function () {
          let json = createJsonObject();
          json = await jsonWriter.writeUintProperty(json, 'prop', arg);

          expect(json.value).to.equal(expected);
        });
      });

      it('creates object with a single property and value', async function () {
        let json = createJsonObject();
        json = await jsonWriter.writeStartObject(json);
        json = await jsonWriter.writeUintProperty(json, 'prop', 1);
        json = await jsonWriter.writeEndObject(json);

        expect(json.value).to.equal('{"prop": 1}');
      });

      it('creates object with multiple properties and values', async function () {
        let json = createJsonObject();
        json = await jsonWriter.writeStartObject(json);
        json = await jsonWriter.writeUintProperty(json, 'prop1', 1);
        json = await jsonWriter.writeUintProperty(json, 'prop2', 2);
        json = await jsonWriter.writeEndObject(json);

        expect(json.value).to.equal('{"prop1": 1,"prop2": 2}');
      });
    });

    describe('values', function () {
      const tests = [
        { arg: 0, expected: '0' },
        { arg: 1, expected: '1' },
        {
          arg: '115792089237316195423570985008687907853269984665640564039457584007913129639935',
          expected: '115792089237316195423570985008687907853269984665640564039457584007913129639935'
        }
      ];

      tests.forEach(({ arg, expected }) => {
        it(`writes uint value of ${arg}`, async function () {
          let json = createJsonObject();
          json = await jsonWriter.writeUintValue(json, arg);

          expect(json.value).to.equal(expected);
        });
      });

      it('creates array with a single value', async function () {
        let json = createJsonObject();
        json = await jsonWriter.writeStartArray(json);
        json = await jsonWriter.writeUintValue(json, 1);
        json = await jsonWriter.writeEndArray(json);

        expect(json.value).to.equal('[1]');
      });

      it('creates array with multiple values', async function () {
        let json = createJsonObject();
        json = await jsonWriter.writeStartArray(json);
        json = await jsonWriter.writeUintValue(json, 1);
        json = await jsonWriter.writeUintValue(json, 2);
        json = await jsonWriter.writeEndArray(json);

        expect(json.value).to.equal('[1,2]');
      });
    });

    describe('addressToString', function () {
      const tests = [
        { arg: '0x0000000000000000000000000000000000000000', expected: '0x0000000000000000000000000000000000000000' },
        { arg: '0x1111111111111111111111111111111111111111', expected: '0x1111111111111111111111111111111111111111' },
        { arg: '0x6b175474e89094c44da98b954eedeac495271d0f', expected: '0x6b175474e89094c44da98b954eedeac495271d0f' },
        { arg: '0xffffffffffffffffffffffffffffffffffffffff', expected: '0xffffffffffffffffffffffffffffffffffffffff' }
      ];
  
      tests.forEach(({ arg, expected }) => {
        it(`converts address of ${arg} to string`, async function () {
          const result = await jsonWriter.addressToString(arg);
          expect(result).to.equal(expected);
        });
      });
    });
  
    describe('intToString', function () {
      const tests = [
        { arg: 0, expected: '0' },
        { arg: -1, expected: '-1' },
        { arg: 1, expected: '1' },
        {
          arg: '-57896044618658097711785492504343953926634992332820282019728792003956564819968',
          expected: '-57896044618658097711785492504343953926634992332820282019728792003956564819968'
        },
        {
          arg: '57896044618658097711785492504343953926634992332820282019728792003956564819967',
          expected: '57896044618658097711785492504343953926634992332820282019728792003956564819967'
        }
      ];
  
      tests.forEach(({ arg, expected }) => {
        it(`converts int value of ${arg} to string`, async function () {
          const result = await jsonWriter.intToString(arg);
          expect(result).to.equal(expected);
        });
      });
    });
  
    describe('uintToString', function () {
      const tests = [
        { arg: 0, expected: '0' },
        { arg: 1, expected: '1' },
        {
          arg: '115792089237316195423570985008687907853269984665640564039457584007913129639935',
          expected: '115792089237316195423570985008687907853269984665640564039457584007913129639935'
        }
      ];
  
      tests.forEach(({ arg, expected }) => {
        it(`converts uint value of ${arg} to string`, async function () {
          const result = await jsonWriter.uintToString(arg);
          expect(result).to.equal(expected);
        });
      });
    });
  });
});