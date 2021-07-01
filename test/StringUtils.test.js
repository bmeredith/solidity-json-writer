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
      it(`converts address of ${arg} to string`, async function () {
        const result = await stringUtils.addressToString(arg);
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
        const result = await stringUtils.intToString(arg);
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
        const result = await stringUtils.uintToString(arg);
        expect(result).to.equal(expected);
      });
    });
  });
});