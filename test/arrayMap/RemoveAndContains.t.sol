// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import 'forge-std/Test.sol';
import {ArrayMap, Map} from 'contracts/ArrayMap.sol';

contract RemoveAndContainsTest is Test {
  using ArrayMap for Map;

  function testRemoveAndContainsKey() public {
    Map memory map = ArrayMap.empty();

    map.set('a', 'b');
    map.set('c', 'd');
    map.set('e', 'f');

    assertEq(map.size(), 3);
    assertEq(map.contains('c'), true);

    map.remove('c');

    assertEq(map.size(), 2);
    assertEq(map.contains('c'), false);
    assertEq(map.get('a'), 'b');
    assertEq(map.get('e'), 'f');
  }

  function testClear() public {
    Map memory map = ArrayMap.empty();

    map.set('a', 'b');
    map.set('c', 'd');
    map.set('e', 'f');

    assertEq(map.size(), 3);
    assertEq(map.contains('c'), true);

    map.clear();

    assertEq(map.size(), 0);
    assertEq(map.contains('c'), false);
  }
}
