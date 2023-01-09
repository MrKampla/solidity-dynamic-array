// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import 'forge-std/Test.sol';
import {DynamicArray, LinkedList, Node} from '../contracts/DynamicArray.sol';

contract FetchingValuesFromDynamicArrayTest is Test {
  using DynamicArray for LinkedList;

  function testGetNode() public {
    LinkedList memory list = DynamicArray.empty();
    list.push('a');
    list.push('b');
    assertEq(list.length, 2);
    Node memory node0 = list.getNode(0);
    assertEq(node0.value, 'a');
    assertEq(node0.previous.length, 0);
    assertEq(node0.next.length, 1);

    Node memory node1 = list.getNode(1);
    assertEq(node1.value, 'b');
    assertEq(node1.previous.length, 1);
    assertEq(node1.next.length, 0);
    assertEq(node0.next[0].value, node1.value);
    assertEq(node1.previous[0].value, node0.value);
  }

  function testFailGetNodeFromEmptyList() public pure {
    LinkedList memory list = DynamicArray.empty();
    list.getNode(0);
  }

  function testFailGetNodeOutOfBounds() public pure {
    LinkedList memory list = DynamicArray.empty();
    list.push('a');
    list.push('b');
    list.getNode(5);
  }

  function testGetValue() public {
    LinkedList memory list = DynamicArray.empty();
    list.push('a');
    list.push('b');
    assertEq(list.length, 2);
    assertEq(list.get(0), 'a');
    assertEq(list.get(1), 'b');
  }
}
