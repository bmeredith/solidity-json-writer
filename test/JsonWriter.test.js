const { expect } = require('chai');

describe('JsonWriter', function() {

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

  describe('objects', function() {
    it('creates empty object for an initial JSON string', async function () {
      let json = createJsonObject();
      json = await jsonWriter.writeStartObject(json);
      json = await jsonWriter.writeEndObject(json);

      expect(json.value).to.equal('{}');
    });
  });

  describe('addresses', function() {
    const tests = [
      {arg: '0x0000000000000000000000000000000000000000', expected: '"0x0000000000000000000000000000000000000000"'},
      {arg: '0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF', expected: '"0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"'}
    ];

    tests.forEach(({arg, expected}) => {
      it(`writes address value of ${arg}`, async function() {
        let json = createJsonObject();
        json = await jsonWriter.writeStringValue(json, arg);
        
        expect(json.value).to.equal(expected);
      });
    });
  });

  describe('booleans', function() {    
    it('writes true boolean value', async function () {
      let json = createJsonObject();
      json = await jsonWriter.writeBooleanValue(json, true);

      expect(json.value).to.equal('true');
    });
    
    it('writes false boolean value', async function () {
      let json = createJsonObject();
      json = await jsonWriter.writeBooleanValue(json, false);

      expect(json.value).to.equal('false');
    });
  });

  describe('ints', function() {
    const tests = [
      {arg: -1, expected: '-1'},
      {arg: 0, expected: '0'},
      {arg: 1, expected: '1'},
      {
        arg: '-57896044618658097711785492504343953926634992332820282019728792003956564819968', 
        expected: '-57896044618658097711785492504343953926634992332820282019728792003956564819968'
      },
      {
        arg: '57896044618658097711785492504343953926634992332820282019728792003956564819967', 
        expected: '57896044618658097711785492504343953926634992332820282019728792003956564819967'
      }
    ];

    tests.forEach(({arg, expected}) => {
      it(`writes int value of ${arg}`, async function() {
        let json = createJsonObject();
        json = await jsonWriter.writeIntValue(json, arg);

        expect(json.value).to.equal(expected);
      });
    });
  });

  describe('strings', function() {
    const tests = [
      {arg: '', expected: '""'},
      {arg: 'test', expected: '"test"'},
      {arg: '1234', expected: '"1234"'}
    ];

    tests.forEach(({arg, expected}) => {
      it(`writes string value of '${arg}'`, async function() {
        let json = createJsonObject();
        json = await jsonWriter.writeStringValue(json, arg);
        
        expect(json.value).to.equal(expected);
      });
    });
  });

  describe('uints', function() {
    const tests = [
      {arg: 0, expected: '0'},
      {arg: 1, expected: '1'},
      {
        arg: '115792089237316195423570985008687907853269984665640564039457584007913129639935', 
        expected: '115792089237316195423570985008687907853269984665640564039457584007913129639935'
      }
    ];

    tests.forEach(({arg, expected}) => {
      it(`writes uint value of ${arg}`, async function() {
        let json = createJsonObject();
        json = await jsonWriter.writeUintValue(json, arg);

        expect(json.value).to.equal(expected);
      });
    });
  });
});