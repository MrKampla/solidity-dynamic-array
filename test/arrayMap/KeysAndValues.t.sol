// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import 'forge-std/Test.sol';
import {ArrayMap, Map} from 'contracts/ArrayMap.sol';

contract KeysAndValuesTest is Test {
  using ArrayMap for Map;

  function testEntries() public {
    Map memory map = ArrayMap.empty();

    map.set('a', 'b');
    map.set('c', 'd');
    map.set('e', 'f');

    assertEq(map.size(), 3);

    (bytes[] memory keys, bytes[] memory values) = map.entries();

    assertEq(string(keys[0]), string('a'));
    assertEq(string(keys[1]), string('c'));
    assertEq(string(keys[2]), string('e'));
    assertEq(string(values[0]), string('b'));
    assertEq(string(values[1]), string('d'));
    assertEq(string(values[2]), string('f'));
  }

  function testKeys() public {
    Map memory map = ArrayMap.empty();

    map.set('a', 'b');
    map.set('c', 'd');
    map.set('e', 'f');

    assertEq(map.size(), 3);

    bytes[] memory keys = map.getKeys();

    assertEq(string(keys[0]), string('a'));
    assertEq(string(keys[1]), string('c'));
    assertEq(string(keys[2]), string('e'));
  }

  function testValues() public {
    Map memory map = ArrayMap.empty();

    map.set('a', 'b');
    map.set('c', 'd');
    map.set('e', 'f');

    assertEq(map.size(), 3);

    bytes[] memory values = map.getValues();

    assertEq(string(values[0]), string('b'));
    assertEq(string(values[1]), string('d'));
    assertEq(string(values[2]), string('f'));
  }
}
