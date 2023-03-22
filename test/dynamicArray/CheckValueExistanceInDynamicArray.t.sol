// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import 'forge-std/Test.sol';
import {DynamicArray, LinkedList, Node} from 'contracts/DynamicArray.sol';

struct TestStruct {
  uint256 a;
  uint256 b;
}

contract CheckValueExistanceInDynamicArrayTest is Test {
  using DynamicArray for LinkedList;

  function testIndexOf() public {
    LinkedList memory list = DynamicArray.empty();
    list.push('a');
    list.push('b');
    list.push('c');
    list.push('b');
    assertEq(list.length, 4);
    assertEq(list.indexOf('a'), 0);
    assertEq(list.indexOf('b'), 1);
    assertEq(list.indexOf('c'), 2);
  }

  function testLastIndexOf() public {
    LinkedList memory list = DynamicArray.empty();
    list.push('a');
    list.push('b');
    list.push('c');
    list.push('b');
    assertEq(list.length, 4);
    assertEq(list.lastIndexOf('a'), 0);
    assertEq(list.lastIndexOf('b'), 3);
    assertEq(list.lastIndexOf('c'), 2);
  }

  function testFind() public {
    LinkedList memory list = DynamicArray.empty();
    list.push(abi.encode(TestStruct(3, 42)));
    list.push(abi.encode(TestStruct(1, 2)));
    list.push(abi.encode(TestStruct(17, 22)));
    assertEq(list.length, 3);
    assertEq(list.find(_findItemAEqualTo1), abi.encode(TestStruct(1, 2)));
  }

  function testContains() public {
    LinkedList memory list = DynamicArray.empty();
    list.push('a');
    list.push('b');
    list.push('c');
    assertEq(list.length, 3);
    assertEq(list.contains('a'), true);
    assertEq(list.contains('b'), true);
    assertEq(list.contains('c'), true);
    assertEq(list.contains('d'), false);
  }
}

function _findItemAEqualTo1(bytes memory item, uint256) pure returns (bool) {
  TestStruct memory s = abi.decode(item, (TestStruct));
  return s.a == 1;
}
