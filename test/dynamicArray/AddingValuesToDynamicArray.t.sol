// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import 'forge-std/Test.sol';
import {DynamicArray, LinkedList, Node} from 'contracts/DynamicArray.sol';

contract AddingValuesToDynamicArrayTest is Test {
  using DynamicArray for LinkedList;

  function testPushNewValueToList() public {
    LinkedList memory list = DynamicArray.empty();
    list.push('a');
    assertEq(list.length, 1);
    assertEq(list.getNode(0).value, 'a');
  }

  function testSetValue() public {
    LinkedList memory list = DynamicArray.empty();
    list.push('a');
    list.push('b');
    assertEq(list.length, 2);
    assertEq(list.get(0), 'a');
    assertEq(list.get(1), 'b');
    list.set(0, 'c');
    list.set(1, 'd');
    assertEq(list.get(0), 'c');
    assertEq(list.get(1), 'd');
  }

  function testInsertElement() public {
    LinkedList memory list = DynamicArray.empty();
    list.push('a');
    list.push('b');
    list.push('c');
    assertEq(list.length, 3);
    assertEq(list.get(0), 'a');
    assertEq(list.get(1), 'b');
    assertEq(list.get(2), 'c');
    list.insert(1, 'd');
    assertEq(list.length, 4);
    assertEq(list.get(0), 'a');
    assertEq(list.get(1), 'd');
    assertEq(list.get(2), 'b');
    assertEq(list.get(3), 'c');
  }

  function testInsertAll() public {
    LinkedList memory list = DynamicArray.empty();
    list.push('a');
    list.push('b');
    list.push('c');
    assertEq(list.length, 3);
    assertEq(list.get(0), 'a');
    assertEq(list.get(1), 'b');
    assertEq(list.get(2), 'c');
    bytes[] memory values = new bytes[](2);
    values[0] = 'd';
    values[1] = 'e';
    list.insertAll(1, values);
    assertEq(list.length, 5);
    assertEq(list.get(0), 'a');
    assertEq(list.get(1), 'd');
    assertEq(list.get(2), 'e');
    assertEq(list.get(3), 'b');
    assertEq(list.get(4), 'c');
  }
}
