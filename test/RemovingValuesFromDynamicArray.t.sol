// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import 'forge-std/Test.sol';
import {DynamicArray, LinkedList, Node} from '../contracts/DynamicArray.sol';

contract RemovingValuesFromDynamicArrayTest is Test {
  using DynamicArray for LinkedList;

  function testPopValueFromList() public {
    LinkedList memory list = DynamicArray.empty();
    list.push('a');
    list.push('b');
    list.push('c');
    assertEq(list.length, 3);
    assertEq(list.pop(), 'c');
    assertEq(list.length, 2);
    assertEq(list.pop(), 'b');
    assertEq(list.length, 1);
    assertEq(list.pop(), 'a');
    assertEq(list.length, 0);
  }

  function testFailPopValueFromEmptyList() public pure {
    LinkedList memory list = DynamicArray.empty();
    list.pop();
  }

  function testRemove() public {
    LinkedList memory list = DynamicArray.empty();
    list.push('a');
    list.push('b');
    list.push('c');
    assertEq(list.length, 3);

    list.remove(1);

    assertEq(list.contains('b'), false);
    assertEq(list.length, 2);

    assertEq(list.get(0), 'a');
    assertEq(list.get(1), 'c');
  }
}
