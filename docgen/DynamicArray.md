# DynamicArray

A library for managing dynamic in-memory arrays of bytes. This can hold any basic type or struct. Due to lack of
generics in Solidity, this library uses a workaround to manage dynamic arrays of different types. Under the hood it
is storing an arbitrary amount of bytes so in order to store a struct, it has to be encoded before storing (using abi.encode)
and decoded after it is retreived from the list (using abi.decode). This library is meant to be used with the LinkedList
struct. For breveity, it is recommended to add a 'using' statement to your contract: `using DynamicArray for LinkedList;`

_Under the hood it implements a linked list data structure._

## empty

```solidity
function empty() internal pure returns (struct LinkedList)
```

Creates an empty LinkedList

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | struct LinkedList | list The empty LinkedList |

## from

```solidity
function from(bytes[] values) internal pure returns (struct LinkedList)
```

Creates a LinkedList from an in-memory array of bytes

| Name | Type | Description |
| ---- | ---- | ----------- |
| values | bytes[] | The array of bytes to create the LinkedList from |

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | struct LinkedList | list The LinkedList created from the array of bytes |

## fromStorage

```solidity
function fromStorage(bytes[] values) internal view returns (struct LinkedList)
```

Creates a LinkedList from an array of bytes from storage

| Name | Type | Description |
| ---- | ---- | ----------- |
| values | bytes[] | The array of bytes to create the LinkedList from |

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | struct LinkedList | list The LinkedList created from the array of bytes |

## fromCalldata

```solidity
function fromCalldata(bytes[] values) internal pure returns (struct LinkedList)
```

Creates a LinkedList from an array of bytes from calldata

| Name | Type | Description |
| ---- | ---- | ----------- |
| values | bytes[] | The array of bytes to create the LinkedList from |

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | struct LinkedList | list The LinkedList created from the array of bytes |

## fromSequence

```solidity
function fromSequence(uint256 end) internal pure returns (struct LinkedList newList)
```

Creates a list of numbers from 0 to end

| Name | Type | Description |
| ---- | ---- | ----------- |
| end | uint256 | The number to end the sequence |

| Name | Type | Description |
| ---- | ---- | ----------- |
| newList | struct LinkedList | The new list created from the sequence |

## fromSubrange

```solidity
function fromSubrange(struct LinkedList list, uint256 start, uint256 end) internal pure returns (struct LinkedList)
```

Creates a new list of numbers witch is a subset of the original list from specified part

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | The list to create a subset from |
| start | uint256 | The index to start the subset (inclusive) |
| end | uint256 | The index to end the subset (exclusive) |

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | struct LinkedList | newList the new list created from the subset |

## push

```solidity
function push(struct LinkedList list, bytes value) internal pure
```

Pushes a new value to the end of the list

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | The list to push the value to |
| value | bytes | The value to push to the list |

## pop

```solidity
function pop(struct LinkedList list) internal pure returns (bytes)
```

Removes the last value from the list. Reverts when there is no element to remove.

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | The list to pop the value from |

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bytes | value The value popped from the list |

## tryPop

```solidity
function tryPop(struct LinkedList list) internal pure returns (bool success, bytes removedItem)
```

Tries to pop the last value from list. If the list is empty, it returns false and does not revert.

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | The list to pop the value from |

| Name | Type | Description |
| ---- | ---- | ----------- |
| success | bool | Whether the pop was successful |
| removedItem | bytes | The value popped from the list |

## getNode

```solidity
function getNode(struct LinkedList list, uint256 index) internal pure returns (struct Node)
```

Retreives the Node element at the specified index without removing it

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | The list to retreive the Node from |
| index | uint256 | The index of the Node to retreive |

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | struct Node | node The Node at the specified index |

## tryGetNode

```solidity
function tryGetNode(struct LinkedList list, uint256 index) internal pure returns (bool success, struct Node)
```

Tries to retreive the Node element at the specified index without removing it. If the index
is out of bounds, it returns false and does not revert.

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | The list to retreive the Node from |
| index | uint256 | The index of the Node to retreive |

| Name | Type | Description |
| ---- | ---- | ----------- |
| success | bool | Whether the call was successful |
| [1] | struct Node | node The Node at the specified index |

## get

```solidity
function get(struct LinkedList list, uint256 index) internal pure returns (bytes)
```

Retreives the value at the specified index without removing it

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | The list to retreive the value from |
| index | uint256 | The index of the value to retreive |

## tryGet

```solidity
function tryGet(struct LinkedList list, uint256 index) internal pure returns (bool success, bytes value)
```

Tries to retreive the value at the specified index without removing it. If the index
is out of bounds, it returns false and does not revert.

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | The list to retreive the value from |
| index | uint256 | The index of the value to retreive |

| Name | Type | Description |
| ---- | ---- | ----------- |
| success | bool | Whether the call was successful |
| value | bytes | The value at the specified index |

## set

```solidity
function set(struct LinkedList list, uint256 index, bytes value) internal pure
```

Sets the value at the specified index

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | The list to set the value in |
| index | uint256 | The index of the value to set |
| value | bytes | The value to set |

## trySet

```solidity
function trySet(struct LinkedList list, uint256 index, bytes value) internal pure returns (bool success)
```

Tries to set the value at the specified index. If the index is out of bounds, it returns
false and does not revert.

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | The list to set the value in |
| index | uint256 | The index of the value to set |
| value | bytes | The value to set |

| Name | Type | Description |
| ---- | ---- | ----------- |
| success | bool | Whether the call was successful |

## insert

```solidity
function insert(struct LinkedList list, uint256 index, bytes value) internal pure
```

Inserts a new value at the specified index

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | The list to insert the value in |
| index | uint256 | The index to insert the value at |
| value | bytes | The value to insert |

## tryInsert

```solidity
function tryInsert(struct LinkedList list, uint256 index, bytes value) internal pure returns (bool success)
```

Tries to insert a new value at the specified index. If the index is out of bounds, it
returns false and does not revert.

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | The list to insert the value in |
| index | uint256 | The index to insert the value at |
| value | bytes | The value to insert |

| Name | Type | Description |
| ---- | ---- | ----------- |
| success | bool | Whether the call was successful |

## insertAll

```solidity
function insertAll(struct LinkedList list, uint256 index, bytes[] values) internal pure
```

Inserts an array of values at the specified index

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | The list to insert the values in |
| index | uint256 | The index to insert the values at |
| values | bytes[] | The values to insert |

## tryInsertAll

```solidity
function tryInsertAll(struct LinkedList list, uint256 index, bytes[] values) internal pure returns (bool success)
```

Tries to insert an array of values at the specified index. If the index is out of bounds,
it returns false and does not revert.

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | The list to insert the values in |
| index | uint256 | The index to insert the values at |
| values | bytes[] | The values to insert |

| Name | Type | Description |
| ---- | ---- | ----------- |
| success | bool | Whether the call was successful |

## appendAll

```solidity
function appendAll(struct LinkedList list, bytes[] values) internal pure
```

Appends an array of values to the end of the list

_This is equivalent to insertAll(list, list.length, values)_

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | The list to append the values to |
| values | bytes[] | The values to append |

## addFirst

```solidity
function addFirst(struct LinkedList list, bytes value) internal pure
```

Adds a value to the beginning of the list

_This is equivalent to insert(list, 0, value)_

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | The list to add the value to |
| value | bytes | The value to add |

## addLast

```solidity
function addLast(struct LinkedList list, bytes value) internal pure
```

Adds a value to the end of the list

_This is equivalent to insert(list, list.length, value)_

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | The list to add the value to |
| value | bytes | The value to add |

## getFirstElement

```solidity
function getFirstElement(struct LinkedList list) internal pure returns (bytes)
```

Gets the first value in the list without removing it

_This is equivalent to get(list, 0)_

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | The list to get the value from |

## getLastElement

```solidity
function getLastElement(struct LinkedList list) internal pure returns (bytes)
```

Gets the last value in the list without removing it

_This is equivalent to get(list, list.length - 1)_

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | The list to get the value from |

## indexOf

```solidity
function indexOf(struct LinkedList list, bytes value) internal pure returns (int256)
```

Gets the index of the first occurance of the specified value

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | The list to search |
| value | bytes | The value to search for |

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | int256 | the index of the first occurance of the specified value, or -1 if the value is not in the list |

## lastIndexOf

```solidity
function lastIndexOf(struct LinkedList list, bytes value) internal pure returns (int256)
```

Gets the index of the last occurance of the specified value

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | The list to search |
| value | bytes | The value to search for |

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | int256 | the index of the last occurance of the specified value, or -1 if the value is not in the list |

## find

```solidity
function find(struct LinkedList list, function (bytes,uint256) pure returns (bool) callback) internal pure returns (bytes)
```

Finds the first occurance of the specified in the list

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | The list to search |
| callback | function (bytes,uint256) pure returns (bool) | The callback to call for each element in the list |

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bytes | the first value from the list for which the callback returns true, or an empty bytes array if the callback never returns true |

## contains

```solidity
function contains(struct LinkedList list, bytes value) internal pure returns (bool)
```

Checks if the list contains the specified value

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | The list to search |
| value | bytes | The value to search for |

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | true if the list contains the specified value, false otherwise |

## remove

```solidity
function remove(struct LinkedList list, uint256 index) internal pure
```

Removes the the element at the specified index

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | The list to remove the value from |
| index | uint256 | The index of the value to remove |

## tryRemove

```solidity
function tryRemove(struct LinkedList list, uint256 index) internal pure returns (bool success)
```

Tries to removes the the element at the specified index. Returns false
if the index is out of bounds and does not revert.

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | The list to remove the value from |
| index | uint256 | The index of the value to remove |

| Name | Type | Description |
| ---- | ---- | ----------- |
| success | bool | true if the element was removed, false otherwise |

## toArray

```solidity
function toArray(struct LinkedList list) internal pure returns (bytes[] values)
```

Creates a solidity array from the linked list

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | the list to convert |

## asAddressArray

```solidity
function asAddressArray(struct LinkedList list) internal pure returns (address[] result)
```

Creates a solidity array of addresses from the linked list

_This function should only be called if the list contains addresses_

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | the list to convert |

| Name | Type | Description |
| ---- | ---- | ----------- |
| result | address[] | the array of addresses |

## asUintArray

```solidity
function asUintArray(struct LinkedList list) internal pure returns (uint256[] result)
```

Creates a solidity array of unsigned integers from the linked list

_This function should only be called if the list contains unsigned integers_

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | the list to convert |

| Name | Type | Description |
| ---- | ---- | ----------- |
| result | uint256[] | the array of unsigned integers |

## asIntArray

```solidity
function asIntArray(struct LinkedList list) internal pure returns (int256[] result)
```

Creates a solidity array of integers from the linked list

_This function should only be called if the list contains integers_

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | the list to convert |

| Name | Type | Description |
| ---- | ---- | ----------- |
| result | int256[] | the array of integers |

## asBoolArray

```solidity
function asBoolArray(struct LinkedList list) internal pure returns (bool[] result)
```

Creates a solidity array of boolean values from the linked list

_This function should only be called if the list contains boolean values_

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | the list to convert |

| Name | Type | Description |
| ---- | ---- | ----------- |
| result | bool[] | the array of boolean values |

## asStringArray

```solidity
function asStringArray(struct LinkedList list) internal pure returns (string[] result)
```

Creates a solidity array of strings from the linked list

_This function should only be called if the list contains strings_

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | the list to convert |

| Name | Type | Description |
| ---- | ---- | ----------- |
| result | string[] | the array of strings |

## slice

```solidity
function slice(struct LinkedList list, uint256 _from, uint256 _to) internal pure returns (struct LinkedList)
```

Creates a new list that only contains the elements between the specified range of the original list

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | The list to slice |
| _from | uint256 | The index of the first element to include |
| _to | uint256 | The index of the last element to include |

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | struct LinkedList | the sliced list |

## merge

```solidity
function merge(struct LinkedList list, struct LinkedList _other) internal pure
```

Merges two lists together by appending the second list at the end of the first. The other list
will be deep copied so it can be safely modified after this operation without affecting the result list.

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | The list to append to |
| _other | struct LinkedList | The list to be copied and appended |

## concat

```solidity
function concat(struct LinkedList list, struct LinkedList other) internal pure returns (struct LinkedList)
```

Creates a new list that is a result of concatenation of the lists passed as arguments. Both lists
will be deep copied so they can be safely modified after this operation without affecting the result list.

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | The first list to concatenate |
| other | struct LinkedList | The second list to concatenate |

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | struct LinkedList | newList A new list that is a result of concatenation of the lists passed as arguments |

## deepCopy

```solidity
function deepCopy(struct LinkedList list) internal pure returns (struct LinkedList copiedList)
```

Creates a deep copy of the list

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | The list to copy |

| Name | Type | Description |
| ---- | ---- | ----------- |
| copiedList | struct LinkedList | A copy of the original list |

## some

```solidity
function some(struct LinkedList list, function (bytes,uint256) view returns (bool) callback) internal view returns (bool)
```

Iterates over the list and calls the callback function for each element in order to check
if the condition is met for at least one element. Callbacks are only executed until one of the callback
invocations returns true.

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | The list to iterate over |
| callback | function (bytes,uint256) view returns (bool) | The function to call for each element. It accepts the element and the index as parameters. |

## every

```solidity
function every(struct LinkedList list, function (bytes,uint256) view returns (bool) callback) internal view returns (bool)
```

Iterates over the list and calls the callback function for each element in order to check
if the condition is met for all elements. Callbacks are only executed until one of the callback
invocations returns false.

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | The list to iterate over |
| callback | function (bytes,uint256) view returns (bool) | The function to call for each element. It accepts the element and the index as parameters. |

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | true If the callback returns true for all elements, false otherwise |

## forEach

```solidity
function forEach(struct LinkedList list, function (bytes,uint256) callback) internal
```

Iterates over the list and calls the callback function for each element

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | The list to iterate over |
| callback | function (bytes,uint256) | The function to call for each element. It accepts the element and the index as parameters |

## map

```solidity
function map(struct LinkedList list, function (bytes,uint256) view returns (bytes) callback) internal view returns (struct LinkedList)
```

Creates a new list with elements that are the result of calling the callback function for each element

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | The list to iterate over |
| callback | function (bytes,uint256) view returns (bytes) | The function to call for each element. It accepts the element and the index as parameters and returns a new item |

## mapToUintArray

```solidity
function mapToUintArray(struct LinkedList list, function (bytes,uint256) view returns (uint256) callback) internal view returns (uint256[])
```

Creates a new array of uint256 that are the result of calling the callback function for each element

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | The list to iterate over |
| callback | function (bytes,uint256) view returns (uint256) | The function to call for each element. It accepts the element and the index as parameters and returns a new item |

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256[] | array A new array of uint256 |

## mapToIntArray

```solidity
function mapToIntArray(struct LinkedList list, function (bytes,uint256) view returns (int256) callback) internal view returns (int256[])
```

Creates a new array of int256 that are the result of calling the callback function for each element

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | The list to iterate over |
| callback | function (bytes,uint256) view returns (int256) | The function to call for each element. It accepts the element and the index as parameters and returns a new item |

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | int256[] | array A new array of int256 |

## mapToBoolArray

```solidity
function mapToBoolArray(struct LinkedList list, function (bytes,uint256) view returns (bool) callback) internal view returns (bool[])
```

Creates a new array of boolean values that are the result of calling the callback function for each element

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | The list to iterate over |
| callback | function (bytes,uint256) view returns (bool) | The function to call for each element. It accepts the element and the index as parameters and returns a new item |

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool[] | array A new array of boolean values |

## mapToAddressArray

```solidity
function mapToAddressArray(struct LinkedList list, function (bytes,uint256) view returns (address) callback) internal view returns (address[])
```

Creates a new array of addresses that are the result of calling the callback function for each element

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | The list to iterate over |
| callback | function (bytes,uint256) view returns (address) | The function to call for each element. It accepts the element and the index as parameters and returns a new item |

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | address[] | array A new array of addresses |

## mapToStringArray

```solidity
function mapToStringArray(struct LinkedList list, function (bytes,uint256) view returns (string) callback) internal view returns (string[])
```

Creates a new array of string values that are the result of calling the callback function for each element

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | The list to iterate over |
| callback | function (bytes,uint256) view returns (string) | The function to call for each element. It accepts the element and the index as parameters and returns a new item |

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | string[] | array A new array of string values |

## filter

```solidity
function filter(struct LinkedList list, function (bytes,uint256) view returns (bool) callback) internal view returns (struct LinkedList)
```

Filters the list and creates a new list with the elements that match the condition

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | The list to filter |
| callback | function (bytes,uint256) view returns (bool) | The function to check if element matches the condition. It accepts the element and the index as parameters. |

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | struct LinkedList | filteredList A new list with the elements that match the condition |

## reduce

```solidity
function reduce(struct LinkedList list, function (bytes,bytes,uint256) view returns (bytes) callback, bytes initialValue) internal view returns (bytes)
```

Reduces the list to a single value by calling the callback function for each element

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | The list to reduce |
| callback | function (bytes,bytes,uint256) view returns (bytes) | The function to call for each element. It accepts the accumulator, the current element and the index as parameters. |
| initialValue | bytes | The initial value of the accumulator |

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bytes | accumulator The final value of the accumulator |

## sort

```solidity
function sort(struct LinkedList list, function (bytes,bytes) view returns (int256) callback) internal view
```

Sorts the list using quicksort algorithm

_The input list is not copied, so the original list is modified_

| Name | Type | Description |
| ---- | ---- | ----------- |
| list | struct LinkedList | The list to sort |
| callback | function (bytes,bytes) view returns (int256) | The function to compare two elements. It accepts two elements and returns: -1 if the first element is smaller than the second element 0 if the first element is equal to the second element 1 if the first element is greater than the second element |

