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
  });

  describe('objects', function () {
    it('creates empty object for an initial JSON string', async function () {
      let json = createJsonObject();
      json = await jsonWriter.writeStartObject(json);
      json = await jsonWriter.writeEndObject(json);

      expect(json.value).to.equal('{}');
    });
  });

  describe('addresses', function () {
    describe('properties', function () {
      const tests = [
        { arg: '0x0000000000000000000000000000000000000000', expected: '{"prop": "0x0000000000000000000000000000000000000000"}' },
        { arg: '0x1111111111111111111111111111111111111111', expected: '{"prop": "0x1111111111111111111111111111111111111111"}' },
        { arg: '0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF', expected: '{"prop": "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"}' }
      ];

      tests.forEach(({ arg, expected }) => {
        it(`writes address property of ${arg}`, async function () {
          let json = createJsonObject();
          json = await jsonWriter.writeStartObject(json);
          json = await jsonWriter.writeStringProperty(json, 'prop', arg);
          json = await jsonWriter.writeEndObject(json);

          expect(json.value).to.equal(expected);
        });
      });
    });

    describe('values', function () {
      const tests = [
        { arg: '0x0000000000000000000000000000000000000000', expected: '"0x0000000000000000000000000000000000000000"' },
        { arg: '0x1111111111111111111111111111111111111111', expected: '"0x1111111111111111111111111111111111111111"' },
        { arg: '0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF', expected: '"0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"' }
      ];

      tests.forEach(({ arg, expected }) => {
        it(`writes address value of ${arg}`, async function () {
          let json = createJsonObject();
          json = await jsonWriter.writeStringValue(json, arg);

          expect(json.value).to.equal(expected);
        });
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
    });
  });

  describe('strings', function () {
    describe('properties', function () {
      const tests = [
        { arg: '', expected: '"prop": ""' },
        { arg: 'test', expected: '"prop": "test"' },
        { arg: '1234', expected: '"prop": "1234"' },
        { arg: '!@#$%^&*();<>?,.:\'"{}[]', expected: '"prop": "!@#$%^&*();<>?,.:\'"{}[]"' },
        { arg: '💯', expected: '"prop": "💯"' }
      ];

      tests.forEach(({ arg, expected }) => {
        it(`writes string property of '${arg}'`, async function () {
          let json = createJsonObject();
          json = await jsonWriter.writeStringProperty(json, 'prop', arg);

          expect(json.value).to.equal(expected);
        });
      });
    });

    describe('values', function () {
      const tests = [
        { arg: '', expected: '""' },
        { arg: 'test', expected: '"test"' },
        { arg: '1234', expected: '"1234"' },
        { arg: '!@#$%^&*();<>?,.:\'"{}[]', expected: '"!@#$%^&*();<>?,.:\'"{}[]"' },
        { arg: '💯', expected: '"💯"' }
      ];

      tests.forEach(({ arg, expected }) => {
        it(`writes string value of '${arg}'`, async function () {
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
    });
  });
});