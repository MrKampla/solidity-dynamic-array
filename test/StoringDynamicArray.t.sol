// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import 'forge-std/Test.sol';
import {DynamicArray, LinkedList, Node} from '../contracts/DynamicArray.sol';

contract StoringDynamicArrayTest is Test {
  using DynamicArray for LinkedList;

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

  bytes[] public bytesArrayInStorage;

  function testStoringArrayInStorage() public {
    LinkedList memory list = DynamicArray.empty();
    list.push('a');
    list.push('b');
    list.push('c');
    assertEq(list.length, 3);
    assertEq(list.get(0), 'a');
    assertEq(list.get(1), 'b');
    assertEq(list.get(2), 'c');

    bytesArrayInStorage = list.toArray();
  }
}
