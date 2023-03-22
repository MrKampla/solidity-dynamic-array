// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import 'forge-std/Test.sol';
import {ArrayMap, Map} from 'contracts/ArrayMap.sol';

contract SetAngGetTest is Test {
  using ArrayMap for Map;

  function testSetAndGetMapValue() public {
    Map memory map = ArrayMap.empty();

    map.set('a', 'b');
    assertEq(map.size(), 1);
    map.set('c', 'd');
    assertEq(map.size(), 2);

    assertEq(map.get('a'), 'b');
    assertEq(map.get('c'), 'd');

    (bytes[] memory keys, bytes[] memory values) = map.entries();
    assertEq(string(keys[0]), string('a'));
    assertEq(string(keys[1]), string('c'));
    assertEq(string(values[0]), string('b'));
    assertEq(string(values[1]), string('d'));
  }

  struct MyStruct {
    uint256 myUint;
    string myString;
  }

  function testSetAndGetStructValue() public {
    Map memory map = ArrayMap.empty();

    MyStruct memory myStruct1 = MyStruct(1, 'a');
    MyStruct memory myStruct2 = MyStruct(2, 'b');

    map.set('a', abi.encode(myStruct1));
    assertEq(map.size(), 1);
    map.set('c', abi.encode(myStruct2));
    assertEq(map.size(), 2);

    MyStruct memory myStruct3 = abi.decode(map.get('a'), (MyStruct));
    MyStruct memory myStruct4 = abi.decode(map.get('c'), (MyStruct));

    assertEq(myStruct3.myUint, 1);
    assertEq(myStruct3.myString, 'a');
    assertEq(myStruct4.myUint, 2);
    assertEq(myStruct4.myString, 'b');
  }
}
