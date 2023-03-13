// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import 'forge-std/Test.sol';
import {DynamicArray, LinkedList, Node} from '../contracts/DynamicArray.sol';

contract CastingDynamicArrayToTypedArrayTest is Test {
  using DynamicArray for LinkedList;

  function testAsAddressArray() public {
    LinkedList memory list = DynamicArray.empty();
    list.push(abi.encode(address(0x1)));
    list.push(abi.encode(address(0x2)));
    list.push(abi.encode(address(0x3)));
    assertEq(list.length, 3);
    address[] memory addresses = list.asAddressArray();
    assertEq(addresses.length, 3);
    assertEq(addresses[0], address(0x1));
    assertEq(addresses[1], address(0x2));
    assertEq(addresses[2], address(0x3));
  }

  function testAsUintArray() public {
    LinkedList memory list = DynamicArray.empty();
    list.push(abi.encode(1));
    list.push(abi.encode(2));
    list.push(abi.encode(3));
    assertEq(list.length, 3);
    uint256[] memory addresses = list.asUintArray();
    assertEq(addresses.length, 3);
    assertEq(addresses[0], 1);
    assertEq(addresses[1], 2);
    assertEq(addresses[2], 3);
  }

  function testAsIntArray() public {
    LinkedList memory list = DynamicArray.empty();
    list.push(abi.encode(-1));
    list.push(abi.encode(-2));
    list.push(abi.encode(3));
    assertEq(list.length, 3);
    int256[] memory integers = list.asIntArray();
    assertEq(integers.length, 3);
    assertEq(integers[0], -1);
    assertEq(integers[1], -2);
    assertEq(integers[2], 3);
  }

  function testAsBoolArray() public {
    LinkedList memory list = DynamicArray.empty();
    list.push(abi.encode(true));
    list.push(abi.encode(false));
    assertEq(list.length, 2);
    bool[] memory booleans = list.asBoolArray();
    assertEq(booleans.length, 2);
    assertEq(booleans[0], true);
    assertEq(booleans[1], false);
  }

  function testAsStringArray() public {
    LinkedList memory list = DynamicArray.empty();
    list.push(abi.encode('example'));
    list.push(abi.encode('text'));
    list.push(abi.encode('strings'));
    assertEq(list.length, 3);
    string[] memory strings = list.asStringArray();
    assertEq(strings.length, 3);
    assertEq(strings[0], 'example');
    assertEq(strings[1], 'text');
    assertEq(strings[2], 'strings');
  }
}
