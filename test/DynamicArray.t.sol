// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import 'forge-std/Test.sol';
import {DynamicArray, LinkedList, Node} from '../contracts/DynamicArray.sol';

contract DynamicArrayTest is Test {
  using DynamicArray for LinkedList;

  function testCreateEmptyList() public {
    LinkedList memory list = DynamicArray.empty();
    assertEq(list.length, 0);
  }

  function testCreateListFromArrayOfValues() public {
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

  function testPushNewValueToList() public {
    LinkedList memory list = DynamicArray.empty();
    list.push('a');
    assertEq(list.length, 1);
    assertEq(list.getNode(0).value, 'a');
  }

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

  function testToArray() public {
    LinkedList memory list = DynamicArray.empty();
    list.push('a');
    list.push('b');
    list.push('c');
    assertEq(list.length, 3);
    bytes[] memory array = list.toArray();

    assertEq(array.length, 3);
    assertEq(array[0], 'a');
    assertEq(array[1], 'b');
    assertEq(array[2], 'c');
  }

  struct SimpleTestStruct {
    bytes value;
    uint256 number;
  }

  function testStoringAndRetreivingSimpleStructs() public {
    LinkedList memory list = DynamicArray.empty();
    SimpleTestStruct memory struct1 = SimpleTestStruct('a', 1);
    list.push(abi.encode(struct1));
    assertEq(list.length, 1);

    SimpleTestStruct memory decodedStruct1 = abi.decode(list.get(0), (SimpleTestStruct));

    assertEq(decodedStruct1.value, struct1.value);
    assertEq(decodedStruct1.number, struct1.number);
  }

  struct ComplexTestStruct {
    string[] strings;
    bool boolean;
    uint256[] numbers;
  }

  function testStoringAndRetreivingComplexStructs() public {
    LinkedList memory list = DynamicArray.empty();
    string[] memory strings = new string[](2);
    strings[0] = 'a';
    strings[1] = 'b';
    uint256[] memory numbers = new uint256[](2);
    numbers[0] = 1;
    numbers[1] = 2;
    ComplexTestStruct memory struct1 = ComplexTestStruct(strings, true, numbers);
    list.push(abi.encode(struct1));
    assertEq(list.length, 1);

    ComplexTestStruct memory decodedStruct1 = abi.decode(
      list.get(0),
      (ComplexTestStruct)
    );

    assertEq(decodedStruct1.strings.length, struct1.strings.length);
    assertEq(decodedStruct1.strings[0], struct1.strings[0]);
    assertEq(decodedStruct1.strings[1], struct1.strings[1]);
    assertEq(decodedStruct1.boolean, struct1.boolean);
    assertEq(decodedStruct1.numbers.length, struct1.numbers.length);
    assertEq(decodedStruct1.numbers[0], struct1.numbers[0]);
    assertEq(decodedStruct1.numbers[1], struct1.numbers[1]);
  }

  bytes[] public bytesArray;

  function testStoringArrayInStorage() public {
    LinkedList memory s_list = DynamicArray.empty();
    s_list.push('a');
    s_list.push('b');
    s_list.push('c');
    assertEq(s_list.length, 3);
    assertEq(s_list.get(0), 'a');
    assertEq(s_list.get(1), 'b');
    assertEq(s_list.get(2), 'c');

    bytesArray = s_list.toArray();
  }

  function testRetreivingArrayFromStorage() public {
    LinkedList memory s_list = DynamicArray.empty();
    s_list.push('a');
    s_list.push('b');
    s_list.push('c');
    assertEq(s_list.length, 3);
    assertEq(s_list.get(0), 'a');
    assertEq(s_list.get(1), 'b');
    assertEq(s_list.get(2), 'c');
    bytesArray = s_list.toArray();

    LinkedList memory list = DynamicArray.fromStorage(bytesArray);

    assertEq(list.length, 3);
    assertEq(list.get(0), 'a');
    assertEq(list.get(1), 'b');
    assertEq(list.get(2), 'c');
  }

  function testCreatingListFromCalldataArray(bytes[] calldata values) public {
    LinkedList memory list = DynamicArray.fromCalldata(values);
    assertEq(list.length, values.length);
    for (uint256 i = 0; i < values.length; i++) {
      assertEq(list.get(i), values[i]);
    }
  }
}
