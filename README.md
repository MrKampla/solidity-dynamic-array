# <center> Solidity dynamic array </center>

## _Resizable in-memory array for Solidity._

[![alt License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](#)

## Description

Have you ever wanted to create a resizable, in-memory Solidity array? If you answered “yes”, then this library is for you.
In order to create an in-memory Solidity Array, you have to specify its length upfront in order for the compiler to allocate enough memory. With solidity-dynamic-array package, you can use DynamicArray library together with LinkedList struct in order to fully utilize dynamic, resizable arrays.

## Install

`npm i solidity-dynamic-array`
or
`yarn add solidity-dynamic-array`

## Usage

```solidity
pragma solidity ^0.8.16;

import { DynamicArray, LinkedList, Node } from 'solidity-dynamic-array/contracts/DynamicArray.sol';

contract MyContract {
  // don't forget about "using" statement!
  using DynamicArray for LinkedList;

  function createDynamicInMemoryArray() public pure {
    // create empty list, you can also create a list based on array values - look up `from`, `fromStorage`
    // and `fromCalldata` methods
    LinkedList memory list = DynamicArray.empty();

    // add as many elements as you want!
    list.push('a');
    list.push('b');
    list.push('c');
    // length will be dynamically calculated
    require(list.length == 3);
    // you can also remove elements
    list.pop();
    require(list.length == 2);
  }

  struct MyStruct {
    uint256 myUint;
    string myString;
  }

  // LinkedList can also store structs!
  function storeStructInDynamicInMemoryArray() public pure {
    LinkedList memory list = DynamicArray.empty();
    // list only accepts bytes values so don't forget to encode your struct before storing it in the list
    list.push(abi.encode(MyStruct(1337, 'example')));

    // when retreiving a struct from list, don't forget to decode the item
    MyStruct memory decodedStruct = abi.decode(list.get(0), (MyStruct));

    require(decodedStruct.myUint == 1337);
    require(keccak256(abi.encodePacked(decodedStruct.myString)) == keccak256('example'));
  }
}
```

## DynamicArray Library

A library for managing dynamic in-memory arrays of bytes. This can hold any basic type or struct. Due to lack of
generics in Solidity, this library uses a workaround to manage dynamic arrays of different types. Under the hood it
is storing an arbitrary amount of bytes so in order to store a struct, it has to be encoded before storing (using abi.encode)
and decoded after it is retreived from the list (using abi.decode). This library is meant to be used with the LinkedList
struct. For brevity, it is recommended to add a 'using' statement to your contract: `using DynamicArray for LinkedList;`

## Structs

### Node

Node is an element stored inside the linked list. Value is stored as bytes, so it can be any basic type or struct, it just has to be encoded before storing and decoded after retrieved from the list. The node also contains references to the previous and next element in the list. Node[] functions as a pointer, if it's empty list, it's null. If it has one element, it's the pointer to the next node.

```solidity
struct Node {
  bytes value;
  struct Node[] previous;
  struct Node[] next;
}
```

### LinkedList

LinkedList is a dynamic array of Nodes. It contains the length of the list and a pointer to the head of the list. If the list is empty, head is an empty array.

```solidity
struct LinkedList {
  uint256 length;
  struct Node[] head;
}
```

## methods

**empty**

```solidity
function empty() internal pure returns (struct LinkedList)
```

Creates an empty LinkedList

| Name | Type              | Description               |
| ---- | ----------------- | ------------------------- |
| [0]  | struct LinkedList | list The empty LinkedList |

**from**

```solidity
function from(bytes[] values) internal pure returns (struct LinkedList)
```

Creates a LinkedList from an in-memory array of bytes

| Name   | Type    | Description                                      |
| ------ | ------- | ------------------------------------------------ |
| values | bytes[] | The array of bytes to create the LinkedList from |

| Name | Type              | Description                                         |
| ---- | ----------------- | --------------------------------------------------- |
| [0]  | struct LinkedList | list The LinkedList created from the array of bytes |

**fromStorage**

```solidity
function fromStorage(bytes[] values) internal view returns (struct LinkedList)
```

Creates a LinkedList from an array of bytes from storage

| Name   | Type    | Description                                      |
| ------ | ------- | ------------------------------------------------ |
| values | bytes[] | The array of bytes to create the LinkedList from |

| Name | Type              | Description                                         |
| ---- | ----------------- | --------------------------------------------------- |
| [0]  | struct LinkedList | list The LinkedList created from the array of bytes |

**fromCalldata**

```solidity
function fromCalldata(bytes[] values) internal pure returns (struct LinkedList)
```

Creates a LinkedList from an array of bytes from calldata

| Name   | Type    | Description                                      |
| ------ | ------- | ------------------------------------------------ |
| values | bytes[] | The array of bytes to create the LinkedList from |

| Name | Type              | Description                                         |
| ---- | ----------------- | --------------------------------------------------- |
| [0]  | struct LinkedList | list The LinkedList created from the array of bytes |

**push**

```solidity
function push(struct LinkedList list, bytes value) internal pure
```

Pushes a new value to the end of the list

| Name  | Type              | Description                   |
| ----- | ----------------- | ----------------------------- |
| list  | struct LinkedList | The list to push the value to |
| value | bytes             | The value to push to the list |

**pop**

```solidity
function pop(struct LinkedList list) internal pure returns (bytes)
```

Removes the last value from the list

| Name | Type              | Description                    |
| ---- | ----------------- | ------------------------------ |
| list | struct LinkedList | The list to pop the value from |

| Name | Type  | Description                          |
| ---- | ----- | ------------------------------------ |
| [0]  | bytes | value The value popped from the list |

**getNode**

```solidity
function getNode(struct LinkedList list, uint256 index) internal pure returns (struct Node)
```

retreives the Node element at the specified index without removing it

| Name  | Type              | Description                        |
| ----- | ----------------- | ---------------------------------- |
| list  | struct LinkedList | The list to retreive the Node from |
| index | uint256           | The index of the Node to retreive  |

**get**

```solidity
function get(struct LinkedList list, uint256 index) internal pure returns (bytes)
```

retreives the value at the specified index without removing it

| Name  | Type              | Description                         |
| ----- | ----------------- | ----------------------------------- |
| list  | struct LinkedList | The list to retreive the value from |
| index | uint256           | The index of the value to retreive  |

**set**

```solidity
function set(struct LinkedList list, uint256 index, bytes value) internal pure
```

Sets the value at the specified index

| Name  | Type              | Description                   |
| ----- | ----------------- | ----------------------------- |
| list  | struct LinkedList | The list to set the value in  |
| index | uint256           | The index of the value to set |
| value | bytes             | The value to set              |

**insert**

```solidity
function insert(struct LinkedList list, uint256 index, bytes value) internal pure
```

Inserts a new value at the specified index

| Name  | Type              | Description                      |
| ----- | ----------------- | -------------------------------- |
| list  | struct LinkedList | The list to insert the value in  |
| index | uint256           | The index to insert the value at |
| value | bytes             | The value to insert              |

**insertAll**

```solidity
function insertAll(struct LinkedList list, uint256 index, bytes[] values) internal pure
```

inserts an array of values at the specified index

| Name   | Type              | Description                       |
| ------ | ----------------- | --------------------------------- |
| list   | struct LinkedList | The list to insert the values in  |
| index  | uint256           | The index to insert the values at |
| values | bytes[]           | The values to insert              |

**appendAll**

```solidity
function appendAll(struct LinkedList list, bytes[] values) internal pure
```

Appends an array of values to the end of the list

_This is equivalent to insertAll(list, list.length, values)_

| Name   | Type              | Description                      |
| ------ | ----------------- | -------------------------------- |
| list   | struct LinkedList | The list to append the values to |
| values | bytes[]           | The values to append             |

**addFirst**

```solidity
function addFirst(struct LinkedList list, bytes value) internal pure
```

Adds a value to the beginning of the list

_This is equivalent to insert(list, 0, value)_

| Name  | Type              | Description                  |
| ----- | ----------------- | ---------------------------- |
| list  | struct LinkedList | The list to add the value to |
| value | bytes             | The value to add             |

**addLast**

```solidity
function addLast(struct LinkedList list, bytes value) internal pure
```

Adds a value to the end of the list

_This is equivalent to insert(list, list.length, value)_

| Name  | Type              | Description                  |
| ----- | ----------------- | ---------------------------- |
| list  | struct LinkedList | The list to add the value to |
| value | bytes             | The value to add             |

**getFirstElement**

```solidity
function getFirstElement(struct LinkedList list) internal pure returns (bytes)
```

Gets the first value in the list without removing it

_This is equivalent to get(list, 0)_

| Name | Type              | Description                    |
| ---- | ----------------- | ------------------------------ |
| list | struct LinkedList | The list to get the value from |

**getLastElement**

```solidity
function getLastElement(struct LinkedList list) internal pure returns (bytes)
```

Gets the last value in the list without removing it

_This is equivalent to get(list, list.length - 1)_

| Name | Type              | Description                    |
| ---- | ----------------- | ------------------------------ |
| list | struct LinkedList | The list to get the value from |

**indexOf**

```solidity
function indexOf(struct LinkedList list, bytes value) internal pure returns (int256)
```

gets the index of the first occurance of the specified value

| Name  | Type              | Description             |
| ----- | ----------------- | ----------------------- |
| list  | struct LinkedList | The list to search      |
| value | bytes             | The value to search for |

| Name | Type   | Description                                                                                    |
| ---- | ------ | ---------------------------------------------------------------------------------------------- |
| [0]  | int256 | the index of the first occurance of the specified value, or -1 if the value is not in the list |

**lastIndexOf**

```solidity
function lastIndexOf(struct LinkedList list, bytes value) internal pure returns (int256)
```

gets the index of the last occurance of the specified value

| Name  | Type              | Description             |
| ----- | ----------------- | ----------------------- |
| list  | struct LinkedList | The list to search      |
| value | bytes             | The value to search for |

| Name | Type   | Description                                                                                   |
| ---- | ------ | --------------------------------------------------------------------------------------------- |
| [0]  | int256 | the index of the last occurance of the specified value, or -1 if the value is not in the list |

**contains**

```solidity
function contains(struct LinkedList list, bytes value) internal pure returns (bool)
```

Checks if the list contains the specified value

| Name  | Type              | Description             |
| ----- | ----------------- | ----------------------- |
| list  | struct LinkedList | The list to search      |
| value | bytes             | The value to search for |

| Name | Type | Description                                                    |
| ---- | ---- | -------------------------------------------------------------- |
| [0]  | bool | true if the list contains the specified value, false otherwise |

**remove**

```solidity
function remove(struct LinkedList list, uint256 index) internal pure
```

Removes the first occurance of the specified value

| Name  | Type              | Description                       |
| ----- | ----------------- | --------------------------------- |
| list  | struct LinkedList | The list to remove the value from |
| index | uint256           | The index of the value to remove  |

**toArray**

```solidity
function toArray(struct LinkedList list) internal pure returns (bytes[])
```

creates a solidity array from the linked list

| Name | Type              | Description         |
| ---- | ----------------- | ------------------- |
| list | struct LinkedList | the list to convert |

## Author

👤 **Kamil Planer**

- Github: [@MrKampla](https://github.com/MrKampla)
- LinkedIn: [@https://www.linkedin.com/in/kamil-planer/](https://www.linkedin.com/in/kamil-planer/)

Contributions, issues and feature requests are welcome!

Give a ⭐️ if this project helped you!
