const { expect } = require('chai');

describe('JsonWriter', function() {

  beforeEach(async function () {
    const JsonWriterMock = await ethers.getContractFactory("JsonWriterMock");
    jsonWriter = await JsonWriterMock.deploy();
  });

  function createJsonObject() {
    return {
      depthBitTracker: 0,
      value: ''
    };
  }

  describe('arrays', function () {
    it('creates empty array for an initial JSON string correctly', async function () {
      let json = createJsonObject();

      json = await jsonWriter.writeStartArray(json);
      json = await jsonWriter.writeEndArray(json);

      expect(json.value).to.equal("[]");
    });
  });

  describe('objects', function() {
    it('creates empty object for an initial JSON string correctly', async function () {
      let json = createJsonObject();

      json = await jsonWriter.writeStartObject(json);
      json = await jsonWriter.writeEndObject(json);

      expect(json.value).to.equal("{}");
    });
  });
});