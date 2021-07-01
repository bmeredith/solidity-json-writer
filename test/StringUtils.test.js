const { expect } = require('chai');

describe('StringUtils', function () {

  beforeEach(async function () {
    const StringUtilsMock = await ethers.getContractFactory('StringUtilsMock');
    stringUtils = await StringUtilsMock.deploy();
  });

  describe('addressToString', function () {
    const tests = [
      { arg: '0x0000000000000000000000000000000000000000', expected: '0x0000000000000000000000000000000000000000' },
      { arg: '0x1111111111111111111111111111111111111111', expected: '0x1111111111111111111111111111111111111111' },
      { arg: '0x6b175474e89094c44da98b954eedeac495271d0f', expected: '0x6b175474e89094c44da98b954eedeac495271d0f' },
      { arg: '0xffffffffffffffffffffffffffffffffffffffff', expected: '0xffffffffffffffffffffffffffffffffffffffff' }
    ];

    tests.forEach(({ arg, expected }) => {
      it(`converts address of '${arg}' to string`, async function () {
        const result = await stringUtils.addressToString(arg);
        expect(result).to.equal(expected);
      });
    });
  });
});