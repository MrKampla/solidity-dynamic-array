// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import 'forge-std/Test.sol';
import {DynamicArray, LinkedList, Node} from '../contracts/DynamicArray.sol';

contract CreateDynamicArrayTest is Test {
  using DynamicArray for LinkedList;

  function testCreateEmptyList() public {
    LinkedList memory list = DynamicArray.empty();
    assertEq(list.length, 0);
  }

  function testCreateListFromInMemoryArrayOfValues() public {
    bytes[] memory values = new bytes[](3);
    values[0] = 'a';
    values[1] = 'b';
    values[2] = 'c';
    LinkedList memory list = DynamicArray.from(values);
    assertEq(list.length, 3);
    assertEq(list.getNode(0).value, 'a');
    assertEq(list.getNode(1).value, 'b');
    assertEq(list.getNode(2).value, 'c');
  }

  function testCreatingListFromCalldataArray(bytes[] calldata values) public {
    LinkedList memory list = DynamicArray.fromCalldata(values);
    assertEq(list.length, values.length);
    for (uint256 i = 0; i < values.length; i++) {
      assertEq(list.get(i), values[i]);
    }
  }

  bytes[] public bytesArray;

  function testRetreivingArrayFromStorage() public {
    LinkedList memory list = DynamicArray.empty();
    list.push('a');
    list.push('b');
    list.push('c');
    assertEq(list.length, 3);
    assertEq(list.get(0), 'a');
    assertEq(list.get(1), 'b');
    assertEq(list.get(2), 'c');
    bytesArray = list.toArray();

    LinkedList memory listFromStorage = DynamicArray.fromStorage(bytesArray);

    assertEq(listFromStorage.length, 3);
    assertEq(listFromStorage.get(0), 'a');
    assertEq(listFromStorage.get(1), 'b');
    assertEq(listFromStorage.get(2), 'c');
  }

  function testFromSequence() public {
    LinkedList memory list = DynamicArray.fromSequence(3);
    assertEq(list.length, 3);
    assertEq(abi.decode(list.get(0), (uint256)), 0);
    assertEq(abi.decode(list.get(1), (uint256)), 1);
    assertEq(abi.decode(list.get(2), (uint256)), 2);
  }

  function testFromSubrange() public {
    LinkedList memory list = DynamicArray.fromSequence(5);
    LinkedList memory subrange = list.fromSubrange(1, 3);
    assertEq(subrange.length, 2);
    assertEq(abi.decode(subrange.get(0), (uint256)), 1);
    assertEq(abi.decode(subrange.get(1), (uint256)), 2);
  }
}
