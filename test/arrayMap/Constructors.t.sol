// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import 'forge-std/Test.sol';
import {ArrayMap, Map} from 'contracts/ArrayMap.sol';

contract ConstructorsTest is Test {
  using ArrayMap for Map;

  function testEmpty() public {
    Map memory map = ArrayMap.empty();

    assertEq(map.size(), 0);
  }

  function testFromEntries() public {
    bytes[] memory keys = new bytes[](3);
    bytes[] memory values = new bytes[](3);
    keys[0] = bytes('a');
    keys[1] = bytes('c');
    keys[2] = bytes('e');
    values[0] = bytes('b');
    values[1] = bytes('d');
    values[2] = bytes('f');
    Map memory map = ArrayMap.fromEntries(keys, values);

    assertEq(map.size(), 3);
    assertEq(map.get('a'), 'b');
    assertEq(map.get('c'), 'd');
    assertEq(map.get('e'), 'f');
  }

  function testFromKeyValuePairs() public {
    bytes[][] memory entries = new bytes[][](3);
    entries[0] = new bytes[](2);
    entries[1] = new bytes[](2);
    entries[2] = new bytes[](2);
    (entries[0][0], entries[0][1]) = (bytes('a'), bytes('b'));
    (entries[1][0], entries[1][1]) = (bytes('c'), bytes('d'));
    (entries[2][0], entries[2][1]) = (bytes('e'), bytes('f'));

    Map memory map = ArrayMap.fromKeyValuePairs(entries);

    assertEq(map.size(), 3);
    assertEq(map.get('a'), 'b');
    assertEq(map.get('c'), 'd');
    assertEq(map.get('e'), 'f');
  }
}
