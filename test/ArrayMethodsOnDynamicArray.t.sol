// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import 'forge-std/Test.sol';
import {DynamicArray, LinkedList, Node} from '../contracts/DynamicArray.sol';

contract ArrayMethodsOnDynamicArrayTest is Test {
  using DynamicArray for LinkedList;

  bytes[] public bytesArray;

  function _addValueToBytesArray(bytes memory item, uint256) internal {
    bytesArray.push(item);
  }

  function testForEach() public {
    bytes[] memory values = new bytes[](3);
    values[0] = 'a';
    values[1] = 'b';
    values[2] = 'c';

    bytesArray = new bytes[](0);

    LinkedList memory list = DynamicArray.from(values);
    list.forEach(_addValueToBytesArray);

    assertEq(bytesArray.length, values.length);
    for (uint256 i = 0; i < values.length; i++) {
      assertEq(bytesArray[i], values[i]);
    }
  }

  function testSome() public {
    bytes[] memory values = new bytes[](3);
    values[0] = 'x';
    values[1] = 'y';
    values[2] = 'z';

    LinkedList memory list = DynamicArray.from(values);

    assertEq(list.some(_isY), true);
    assertEq(list.some(_isA), false);
  }

  function testEvery() public {
    bytes[] memory values = new bytes[](2);
    values[0] = 'a';
    values[1] = 'y';

    LinkedList memory list = DynamicArray.from(values);

    assertEq(list.every(_isA), false);
    assertEq(list.every(_isY), false);
    assertEq(list.every(_isAorY), true);
  }

  function testSlice() public {
    bytes[] memory values = new bytes[](3);
    values[0] = 'a';
    values[1] = 'b';
    values[2] = 'c';

    LinkedList memory list = DynamicArray.from(values);

    LinkedList memory slice = list.slice(1, 2);

    list.push('d');

    assertEq(slice.length, 2);
    assertEq(slice.get(0), 'b');
    assertEq(slice.get(1), 'c');
  }

  function testDeepCopy() public {
    bytes[] memory values = new bytes[](3);
    values[0] = 'a';
    values[1] = 'b';
    values[2] = 'c';

    LinkedList memory list = DynamicArray.from(values);

    LinkedList memory copy = list.deepCopy();

    assertEq(copy.length, list.length);

    copy.push('d');
    copy.set(0, 'x');

    assertTrue(keccak256(copy.get(0)) != keccak256(list.get(0)));
    assertEq(copy.get(1), list.get(1));
    assertEq(copy.get(2), list.get(2));
    assertEq(copy.get(3), 'd');
    assertEq(list.length, 3);
  }

  function testMerge() public {
    bytes[] memory values = new bytes[](3);
    values[0] = 'a';
    values[1] = 'b';
    values[2] = 'c';

    LinkedList memory list = DynamicArray.from(values);

    LinkedList memory list2 = DynamicArray.from(values);

    list.merge(list2);

    // list2 can still be used withouth affecting the concatenated list
    list2.push('d');

    assertEq(list.length, 6);
    assertEq(list.get(0), 'a');
    assertEq(list.get(1), 'b');
    assertEq(list.get(2), 'c');
    assertEq(list.get(3), 'a');
    assertEq(list.get(4), 'b');
    assertEq(list.get(5), 'c');
  }

  function testConcat() public {
    bytes[] memory values = new bytes[](3);
    values[0] = 'a';
    values[1] = 'b';
    values[2] = 'c';

    LinkedList memory list = DynamicArray.from(values);

    LinkedList memory list2 = DynamicArray.from(values);

    LinkedList memory concatenatedList = list.concat(list2);

    // list2 can still be used withouth affecting the concatenated list
    list2.push('d');
    list.push('x');

    assertEq(concatenatedList.length, 6);
    assertEq(concatenatedList.get(0), 'a');
    assertEq(concatenatedList.get(1), 'b');
    assertEq(concatenatedList.get(2), 'c');
    assertEq(concatenatedList.get(3), 'a');
    assertEq(concatenatedList.get(4), 'b');
    assertEq(concatenatedList.get(5), 'c');
  }

  function testFilter() public {
    bytes[] memory values = new bytes[](3);
    values[0] = 'a';
    values[1] = 'b';
    values[2] = 'c';

    LinkedList memory list = DynamicArray.from(values);

    LinkedList memory filteredList = list.filter(_isA);

    assertEq(filteredList.length, 1);
    assertEq(filteredList.get(0), 'a');
  }

  function testEmptyFilter() public {
    bytes[] memory values = new bytes[](0);

    LinkedList memory list = DynamicArray.from(values);

    LinkedList memory filteredList = list.filter(_isA);

    assertEq(filteredList.length, 0);

    bytes[] memory emptyItems = new bytes[](3);

    LinkedList memory list2 = DynamicArray.from(emptyItems);

    LinkedList memory filteredEmptyItems = list2.filter(_isA);

    assertEq(filteredEmptyItems.length, 0);
  }

  function testMap() public {
    bytes[] memory values = new bytes[](3);
    values[0] = abi.encode(uint256(1));
    values[1] = abi.encode(uint256(2));
    values[2] = abi.encode(uint256(3));

    LinkedList memory list = DynamicArray.from(values);

    LinkedList memory mappedList = list.map(_double);

    assertEq(mappedList.length, 3);
    assertEq(abi.decode(mappedList.get(0), (uint256)), 2);
    assertEq(abi.decode(mappedList.get(1), (uint256)), 4);
    assertEq(abi.decode(mappedList.get(2), (uint256)), 6);
  }

  function testMapToUintArray() public {
    bytes[] memory values = new bytes[](3);
    values[0] = abi.encode(uint256(1));
    values[1] = abi.encode(uint256(2));
    values[2] = abi.encode(uint256(3));

    LinkedList memory list = DynamicArray.from(values);

    uint256[] memory arrayOfUints = list.mapToUintArray(_mapEncodedItemToUint);

    assertEq(arrayOfUints.length, 3);
    assertEq(arrayOfUints[0], 1);
    assertEq(arrayOfUints[1], 2);
    assertEq(arrayOfUints[2], 3);
  }

  function testMapToIntArray() public {
    bytes[] memory values = new bytes[](3);
    values[0] = abi.encode(uint256(1));
    values[1] = abi.encode(uint256(2));
    values[2] = abi.encode(uint256(3));

    LinkedList memory list = DynamicArray.from(values);

    int256[] memory arrayOfUints = list.mapToIntArray(_mapEncodedItemToInt);

    assertEq(arrayOfUints.length, 3);
    assertEq(arrayOfUints[0], 1);
    assertEq(arrayOfUints[1], 2);
    assertEq(arrayOfUints[2], 3);
  }

  function testMapToBooleanArray() public {
    bytes[] memory values = new bytes[](2);
    values[0] = abi.encode(true);
    values[1] = abi.encode(false);

    LinkedList memory list = DynamicArray.from(values);

    bool[] memory arrayOfUints = list.mapToBoolArray(_mapEncodedItemToBool);

    assertEq(arrayOfUints.length, 2);
    assertEq(arrayOfUints[0], true);
    assertEq(arrayOfUints[1], false);
  }

  function testMapToAddressArray() public {
    bytes[] memory values = new bytes[](2);
    values[0] = abi.encode(address(0x1));
    values[1] = abi.encode(address(0x2));

    LinkedList memory list = DynamicArray.from(values);

    address[] memory arrayOfUints = list.mapToAddressArray(_mapEncodedItemToAddress);

    assertEq(arrayOfUints.length, 2);
    assertEq(arrayOfUints[0], address(0x1));
    assertEq(arrayOfUints[1], address(0x2));
  }

  function testMapToStringArray() public {
    bytes[] memory values = new bytes[](2);
    values[0] = 'abc';
    values[1] = 'def';

    LinkedList memory list = DynamicArray.from(values);

    string[] memory arrayOfUints = list.mapToStringArray(_mapEncodedItemToString);

    assertEq(arrayOfUints.length, 2);
    assertEq(arrayOfUints[0], 'abc');
    assertEq(arrayOfUints[1], 'def');
  }

  function testReduce() public {
    bytes[] memory values = new bytes[](3);
    values[0] = abi.encode(uint256(1));
    values[1] = abi.encode(uint256(5));
    values[2] = abi.encode(uint256(3));

    LinkedList memory list = DynamicArray.from(values);

    uint256 sum = abi.decode(list.reduce(_sum, abi.encode(uint256(0))), (uint256));
    assertEq(sum, 9);
  }

  function testSort() public {
    bytes[] memory values = new bytes[](4);
    values[0] = abi.encode(uint256(6));
    values[1] = abi.encode(uint256(3));
    values[2] = abi.encode(uint256(8));
    values[3] = abi.encode(uint256(2));

    LinkedList memory list = DynamicArray.from(values);

    list.sort(_compare);

    assertEq(abi.decode(list.get(0), (uint256)), 2);
    assertEq(abi.decode(list.get(1), (uint256)), 3);
    assertEq(abi.decode(list.get(2), (uint256)), 6);
    assertEq(abi.decode(list.get(3), (uint256)), 8);
  }
}

function _isY(bytes memory item, uint256) pure returns (bool) {
  return keccak256(item) == keccak256(bytes('y'));
}

function _isA(bytes memory item, uint256) pure returns (bool) {
  return keccak256(item) == keccak256(bytes('a'));
}

function _isAorY(bytes memory item, uint256) pure returns (bool) {
  return _isA(item, 0) || _isY(item, 0);
}

function _double(bytes memory item, uint256) pure returns (bytes memory) {
  uint256 x = abi.decode(item, (uint256));
  return abi.encode(x * 2);
}

function _mapEncodedItemToUint(bytes memory item, uint256) pure returns (uint256) {
  uint256 x = abi.decode(item, (uint256));
  return x;
}

function _mapEncodedItemToInt(bytes memory item, uint256) pure returns (int256) {
  int256 x = abi.decode(item, (int256));
  return x;
}

function _mapEncodedItemToBool(bytes memory item, uint256) pure returns (bool) {
  bool x = abi.decode(item, (bool));
  return x;
}

function _mapEncodedItemToAddress(bytes memory item, uint256) pure returns (address) {
  address x = abi.decode(item, (address));
  return x;
}

function _mapEncodedItemToString(
  bytes memory item,
  uint256
) pure returns (string memory) {
  return string(item);
}

function _sum(bytes memory acc, bytes memory item, uint256) pure returns (bytes memory) {
  uint256 x = abi.decode(item, (uint256));
  return abi.encode(abi.decode(acc, (uint256)) + x);
}

function _compare(bytes memory first, bytes memory second) pure returns (int256) {
  uint256 x = abi.decode(first, (uint256));
  uint256 y = abi.decode(second, (uint256));
  if (x < y) {
    return -1;
  } else if (x > y) {
    return 1;
  } else {
    return 0;
  }
}
