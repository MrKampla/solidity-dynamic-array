// SPDX-License-Identifier: MIT
pragma solidity >=0.4.0;

/**
 * @notice Node is an element stored inside the linked list. Value is stored as bytes so it can be any basic
 * type or struct, it just has to be encoded before storing and decoded after retreived from the list.
 * Node also contains references to the previous and next element in list. Node[] funcitons as a pointer,
 * if it's empty list, it's null. If it has one element, it's the pointer to the next node.
 * @param value The value stored in the node
 * @param previous The previous node in the list
 * @param next The next node in the list
 */
struct Node {
  bytes value;
  Node[] previous;
  Node[] next;
}

/**
 * @notice LinkedList is a dynamic array of Nodes. It contains the length of the list and a pointer to the
 * head of the list. If the list is empty, head is an empty array.
 * @param length The length of the list
 * @param head The head of the list
 */
struct LinkedList {
  uint256 length;
  Node[] head;
}

/**
 * @notice This is a helper function to build a "pointer" to a Node. Technically, it is not a pointer but it functions as one.
 * It's used to set the previous and next
 * @param node The node to build a pointer to
 * @return nodePointer The pointer to the node passed as a parameter
 */
function buildNodePointer(Node memory node) pure returns (Node[] memory) {
  Node[] memory nodePointer = new Node[](1);
  nodePointer[0] = node;
  return nodePointer;
}

/**
 * @notice A library for managing dynamic in-memory arrays of bytes. This can hold any basic type or struct. Due to lack of
 * generics in Solidity, this library uses a workaround to manage dynamic arrays of different types. Under the hood it
 * is storing an arbitrary amount of bytes so in order to store a struct, it has to be encoded before storing (using abi.encode)
 * and decoded after it is retreived from the list (using abi.decode). This library is meant to be used with the LinkedList
 * struct. For breveity, it is recommended to add a 'using' statement to your contract: `using DynamicArray for LinkedList;`
 * @dev Under the hood it implements a linked list data structure.
 * @author @Mrkampla
 */
library DynamicArray {
  /**
   * @notice Creates an empty LinkedList
   * @return list The empty LinkedList
   */
  function empty() internal pure returns (LinkedList memory) {
    return LinkedList(0, new Node[](0));
  }

  /**
   * @notice Creates a LinkedList from an in-memory array of bytes
   * @param values The array of bytes to create the LinkedList from
   * @return list The LinkedList created from the array of bytes
   */
  function from(bytes[] memory values) internal pure returns (LinkedList memory) {
    LinkedList memory list = empty();
    for (uint256 i = 0; i < values.length; i++) {
      push(list, values[i]);
    }
    return list;
  }

  /**
   * @notice Creates a LinkedList from an array of bytes from storage
   * @param values The array of bytes to create the LinkedList from
   * @return list The LinkedList created from the array of bytes
   */
  function fromStorage(bytes[] storage values) internal view returns (LinkedList memory) {
    LinkedList memory list = empty();
    for (uint256 i = 0; i < values.length; i++) {
      push(list, values[i]);
    }
    return list;
  }

  /**
   * @notice Creates a LinkedList from an array of bytes from calldata
   * @param values The array of bytes to create the LinkedList from
   * @return list The LinkedList created from the array of bytes
   */
  function fromCalldata(
    bytes[] calldata values
  ) internal pure returns (LinkedList memory) {
    LinkedList memory list = empty();
    for (uint256 i = 0; i < values.length; i++) {
      push(list, values[i]);
    }
    return list;
  }

  /**
   * @notice Creates a list of numbers from 0 to end
   * @param end The number to end the sequence
   * @return newList The new list created from the sequence
   */
  function fromSequence(uint256 end) internal pure returns (LinkedList memory newList) {
    newList = empty();
    for (uint256 i = 0; i < end; i++) {
      push(newList, abi.encode(i));
    }
    return newList;
  }

  /**
   * @notice Creates a new list of numbers witch is a subset of the original list from specified part
   * @param list The list to create a subset from
   * @param start The index to start the subset (inclusive)
   * @param end The index to end the subset (exclusive)
   * @return newList the new list created from the subset
   */
  function fromSubrange(
    LinkedList memory list,
    uint256 start,
    uint256 end
  ) internal pure returns (LinkedList memory) {
    require(start <= end, 'Start must be less than or equal to end');
    require(end <= list.length, 'End must be less than or equal to list length');
    LinkedList memory newList = empty();
    for (uint256 i = start; i < end; i++) {
      push(newList, get(list, i));
    }
    return newList;
  }

  /**
   * @notice Pushes a new value to the end of the list
   * @param list The list to push the value to
   * @param value The value to push to the list
   */
  function push(LinkedList memory list, bytes memory value) internal pure {
    Node memory node = Node(value, new Node[](0), new Node[](0));
    if (list.length == 0) {
      Node[] memory head = new Node[](1);
      head[0] = node;
      list.head = head;
    } else {
      Node memory lastNode = getNode(list, list.length - 1);
      Node[] memory tail = buildNodePointer(node);
      lastNode.next = tail;
      Node[] memory previousNode = buildNodePointer(lastNode);
      node.previous = previousNode;
    }
    list.length++;
  }

  /**
   * @notice Removes the last value from the list. Reverts when there is no element to remove.
   * @param list The list to pop the value from
   * @return value The value popped from the list
   */
  function pop(LinkedList memory list) internal pure returns (bytes memory) {
    require(list.length > 0, 'List is empty');
    if (list.length == 1) {
      Node memory headNode = list.head[0];
      list.head = new Node[](0);
      list.length--;
      return headNode.value;
    }
    Node memory lastNode = getNode(list, list.length - 1);
    Node memory previousNode = lastNode.previous[0];
    Node[] memory tail = new Node[](0);
    previousNode.next = tail;
    list.length--;
    return lastNode.value;
  }

  /**
   * @notice Tries to pop the last value from list. If the list is empty, it returns false and does not revert.
   * @param list The list to pop the value from
   * @return success Whether the pop was successful
   * @return removedItem The value popped from the list
   */
  function tryPop(
    LinkedList memory list
  ) internal pure returns (bool success, bytes memory removedItem) {
    if (list.length == 0) {
      return (false, bytes(''));
    }
    return (true, pop(list));
  }

  /**
   * @notice Retreives the Node element at the specified index without removing it
   * @param list The list to retreive the Node from
   * @param index The index of the Node to retreive
   * @return node The Node at the specified index
   */
  function getNode(
    LinkedList memory list,
    uint256 index
  ) internal pure returns (Node memory) {
    require(index < list.length, 'Index out of bounds');
    Node memory node = list.head[0];
    for (uint256 i = 0; i < index; i++) {
      node = node.next[0];
    }
    return node;
  }

  /**
   * @notice Tries to retreive the Node element at the specified index without removing it. If the index
   * is out of bounds, it returns false and does not revert.
   * @param list The list to retreive the Node from
   * @param index The index of the Node to retreive
   * @return success Whether the call was successful
   * @return node The Node at the specified index
   */
  function tryGetNode(
    LinkedList memory list,
    uint256 index
  ) internal pure returns (bool success, Node memory) {
    if (index >= list.length) {
      return (false, Node(bytes(''), new Node[](0), new Node[](0)));
    }
    Node memory node = list.head[0];
    for (uint256 i = 0; i < index; i++) {
      node = node.next[0];
    }
    return (true, node);
  }

  /**
   * @notice Retreives the value at the specified index without removing it
   * @param list The list to retreive the value from
   * @param index The index of the value to retreive
   */
  function get(
    LinkedList memory list,
    uint256 index
  ) internal pure returns (bytes memory) {
    return getNode(list, index).value;
  }

  /**
   * @notice Tries to retreive the value at the specified index without removing it. If the index
   * is out of bounds, it returns false and does not revert.
   * @param list The list to retreive the value from
   * @param index The index of the value to retreive
   * @return success Whether the call was successful
   * @return value The value at the specified index
   */
  function tryGet(
    LinkedList memory list,
    uint256 index
  ) internal pure returns (bool success, bytes memory value) {
    Node memory node;
    (success, node) = tryGetNode(list, index);

    return (success, node.value);
  }

  /**
   * @notice Sets the value at the specified index
   * @param list The list to set the value in
   * @param index The index of the value to set
   * @param value The value to set
   */
  function set(LinkedList memory list, uint256 index, bytes memory value) internal pure {
    require(index < list.length, 'Index out of bounds');
    Node memory node = getNode(list, index);
    node.value = value;
  }

  /**
   * @notice Tries to set the value at the specified index. If the index is out of bounds, it returns
   * false and does not revert.
   * @param list The list to set the value in
   * @param index The index of the value to set
   * @param value The value to set
   * @return success Whether the call was successful
   */
  function trySet(
    LinkedList memory list,
    uint256 index,
    bytes memory value
  ) internal pure returns (bool success) {
    if (index >= list.length) {
      return false;
    }
    Node memory node = getNode(list, index);
    node.value = value;
  }

  /**
   * @notice Inserts a new value at the specified index
   * @param list The list to insert the value in
   * @param index The index to insert the value at
   * @param value The value to insert
   */
  function insert(
    LinkedList memory list,
    uint256 index,
    bytes memory value
  ) internal pure {
    require(index <= list.length, 'Index out of bounds');
    Node memory node = Node(value, new Node[](0), new Node[](0));
    if (index == 0) {
      Node memory oldHead = list.head[0];
      Node[] memory head = buildNodePointer(node);
      list.head = head;
      Node[] memory previousNode = buildNodePointer(oldHead);
      node.previous = previousNode;
    } else {
      Node memory previousNode = getNode(list, index - 1);
      Node memory nextNode = getNode(list, index);

      Node[] memory previousNodePointer = buildNodePointer(previousNode);
      node.previous = previousNodePointer;
      previousNode.next = buildNodePointer(node);

      Node[] memory nextNodePointer = buildNodePointer(nextNode);
      node.next = nextNodePointer;
      nextNode.previous = buildNodePointer(node);
    }
    list.length++;
  }

  /**
   * @notice Tries to insert a new value at the specified index. If the index is out of bounds, it
   * returns false and does not revert.
   * @param list The list to insert the value in
   * @param index The index to insert the value at
   * @param value The value to insert
   * @return success Whether the call was successful
   */
  function tryInsert(
    LinkedList memory list,
    uint256 index,
    bytes memory value
  ) internal pure returns (bool success) {
    if (index > list.length) {
      return false;
    }
    insert(list, index, value);
    return true;
  }

  /**
   * @notice Inserts an array of values at the specified index
   * @param list The list to insert the values in
   * @param index The index to insert the values at
   * @param values The values to insert
   */
  function insertAll(
    LinkedList memory list,
    uint256 index,
    bytes[] memory values
  ) internal pure {
    require(index <= list.length, 'Index out of bounds');
    for (uint256 i = 0; i < values.length; i++) {
      insert(list, index + i, values[i]);
    }
  }

  /**
   * @notice Tries to insert an array of values at the specified index. If the index is out of bounds,
   * it returns false and does not revert.
   * @param list The list to insert the values in
   * @param index The index to insert the values at
   * @param values The values to insert
   * @return success Whether the call was successful
   */
  function tryInsertAll(
    LinkedList memory list,
    uint256 index,
    bytes[] memory values
  ) internal pure returns (bool success) {
    if (index > list.length) {
      return false;
    }
    insertAll(list, index, values);
    return true;
  }

  /**
   * @notice Appends an array of values to the end of the list
   * @param list The list to append the values to
   * @param values The values to append
   * @dev This is equivalent to insertAll(list, list.length, values)
   */
  function appendAll(LinkedList memory list, bytes[] memory values) internal pure {
    insertAll(list, list.length, values);
  }

  /**
   * @notice Adds a value to the beginning of the list
   * @param list The list to add the value to
   * @param value The value to add
   * @dev This is equivalent to insert(list, 0, value)
   */
  function addFirst(LinkedList memory list, bytes memory value) internal pure {
    insert(list, 0, value);
  }

  /**
   * @notice Adds a value to the end of the list
   * @param list The list to add the value to
   * @param value The value to add
   * @dev This is equivalent to insert(list, list.length, value)
   */
  function addLast(LinkedList memory list, bytes memory value) internal pure {
    insert(list, list.length, value);
  }

  /**
   * @notice Gets the first value in the list without removing it
   * @param list The list to get the value from
   * @dev This is equivalent to get(list, 0)
   */
  function getFirstElement(LinkedList memory list) internal pure returns (bytes memory) {
    return get(list, 0);
  }

  /**
   * @notice Gets the last value in the list without removing it
   * @param list The list to get the value from
   * @dev This is equivalent to get(list, list.length - 1)
   */
  function getLastElement(LinkedList memory list) internal pure returns (bytes memory) {
    return get(list, list.length - 1);
  }

  /**
   * @notice Gets the index of the first occurance of the specified value
   * @param list The list to search
   * @param value The value to search for
   * @return the index of the first occurance of the specified value, or -1 if the value is not in the list
   */
  function indexOf(
    LinkedList memory list,
    bytes memory value
  ) internal pure returns (int256) {
    for (uint256 i = 0; i < list.length; i++) {
      if (keccak256(get(list, i)) == keccak256(value)) {
        return int256(i);
      }
    }
    return -1;
  }

  /**
   * @notice Gets the index of the last occurance of the specified value
   * @param list The list to search
   * @param value The value to search for
   * @return the index of the last occurance of the specified value, or -1 if the value is not in the list
   */
  function lastIndexOf(
    LinkedList memory list,
    bytes memory value
  ) internal pure returns (int256) {
    for (int256 i = int256(list.length) - 1; i >= 0; i--) {
      if (keccak256(get(list, uint256(i))) == keccak256(value)) {
        return i;
      }
    }
    return -1;
  }

  /**
   * @notice Finds the first occurance of the specified in the list
   * @param list The list to search
   * @param callback The callback to call for each element in the list
   * @return the first value from the list for which the callback returns true, or an empty bytes array
   * if the callback never returns true
   */
  function find(
    LinkedList memory list,
    function(bytes memory, uint256) pure returns (bool) callback
  ) internal pure returns (bytes memory) {
    for (uint256 i = 0; i < list.length; i++) {
      bytes memory value = get(list, i);
      if (callback(value, i)) {
        return value;
      }
    }
    return bytes('');
  }

  /**
   * @notice Checks if the list contains the specified value
   * @param list The list to search
   * @param value The value to search for
   * @return true if the list contains the specified value, false otherwise
   */
  function contains(
    LinkedList memory list,
    bytes memory value
  ) internal pure returns (bool) {
    return indexOf(list, value) != -1;
  }

  /**
   * @notice Removes the the element at the specified index
   * @param list The list to remove the value from
   * @param index The index of the value to remove
   */
  function remove(LinkedList memory list, uint256 index) internal pure {
    require(index < list.length, 'Index out of bounds');
    if (index == 0) {
      Node memory oldHead = list.head[0];
      Node memory newHead = oldHead.next[0];
      Node[] memory head = buildNodePointer(newHead);
      list.head = head;
    } else {
      Node memory previousNode = getNode(list, index - 1);
      Node memory nextNode = getNode(list, index + 1);

      Node[] memory previousNodePointer = buildNodePointer(previousNode);
      nextNode.previous = previousNodePointer;

      Node[] memory nextNodePointer = buildNodePointer(nextNode);
      previousNode.next = nextNodePointer;
    }
    list.length--;
  }

  /**
   * @notice Tries to removes the the element at the specified index. Returns false
   * if the index is out of bounds and does not revert.
   * @param list The list to remove the value from
   * @param index The index of the value to remove
   * @return success true if the element was removed, false otherwise
   */
  function tryRemove(
    LinkedList memory list,
    uint256 index
  ) internal pure returns (bool success) {
    if (index >= list.length) {
      return false;
    }
    remove(list, index);
    return true;
  }

  /**
   * @notice Creates a solidity array from the linked list
   * @param list the list to convert
   */
  function toArray(LinkedList memory list) internal pure returns (bytes[] memory values) {
    values = new bytes[](list.length);
    for (uint256 i = 0; i < list.length; i++) {
      values[i] = getNode(list, i).value;
    }
    return values;
  }

  /**
   * @notice Creates a solidity array of addresses from the linked list
   * @dev This function should only be called if the list contains addresses
   * @param list the list to convert
   * @return result the array of addresses
   */
  function asAddressArray(
    LinkedList memory list
  ) internal pure returns (address[] memory result) {
    result = new address[](list.length);
    for (uint256 i = 0; i < list.length; i++) {
      result[i] = abi.decode(getNode(list, i).value, (address));
    }
    return result;
  }

  /**
   * @notice Creates a solidity array of unsigned integers from the linked list
   * @dev This function should only be called if the list contains unsigned integers
   * @param list the list to convert
   * @return result the array of unsigned integers
   */
  function asUintArray(
    LinkedList memory list
  ) internal pure returns (uint256[] memory result) {
    result = new uint256[](list.length);
    for (uint256 i = 0; i < list.length; i++) {
      result[i] = abi.decode(getNode(list, i).value, (uint256));
    }
    return result;
  }

  /**
   * @notice Creates a solidity array of integers from the linked list
   * @dev This function should only be called if the list contains integers
   * @param list the list to convert
   * @return result the array of integers
   */
  function asIntArray(
    LinkedList memory list
  ) internal pure returns (int256[] memory result) {
    result = new int256[](list.length);
    for (uint256 i = 0; i < list.length; i++) {
      result[i] = abi.decode(getNode(list, i).value, (int256));
    }
    return result;
  }

  /**
   * @notice Creates a solidity array of boolean values from the linked list
   * @dev This function should only be called if the list contains boolean values
   * @param list the list to convert
   * @return result the array of boolean values
   */
  function asBoolArray(
    LinkedList memory list
  ) internal pure returns (bool[] memory result) {
    result = new bool[](list.length);
    for (uint256 i = 0; i < list.length; i++) {
      result[i] = abi.decode(getNode(list, i).value, (bool));
    }
    return result;
  }

  /**
   * @notice Creates a solidity array of strings from the linked list
   * @dev This function should only be called if the list contains strings
   * @param list the list to convert
   * @return result the array of strings
   */
  function asStringArray(
    LinkedList memory list
  ) internal pure returns (string[] memory result) {
    result = new string[](list.length);
    for (uint256 i = 0; i < list.length; i++) {
      result[i] = abi.decode(getNode(list, i).value, (string));
    }
    return result;
  }

  /**
   * @notice Creates a new list that only contains the elements between the specified range of the original list
   * @param list The list to slice
   * @param _from The index of the first element to include
   * @param _to The index of the last element to include
   * @return the sliced list
   */
  function slice(
    LinkedList memory list,
    uint256 _from,
    uint256 _to
  ) internal pure returns (LinkedList memory) {
    require(_from <= _to, 'Invalid slice range');
    require(_to <= list.length, 'Slice range out of bounds');

    LinkedList memory slicedList = deepCopy(list);

    if (_from == 0) {
      Node memory tail = getNode(slicedList, _to);
      tail.next = new Node[](0);
      slicedList.length = _to + 1;
    } else {
      Node memory newHead = getNode(slicedList, _from);
      Node memory newTail = getNode(slicedList, _to);

      Node[] memory newHeadPointer = buildNodePointer(newHead);
      slicedList.head = newHeadPointer;

      newTail.next = new Node[](0);
      slicedList.length = _to - _from + 1;
    }

    return slicedList;
  }

  /**
   * @notice Merges two lists together by appending the second list at the end of the first. The other list
   * will be deep copied so it can be safely modified after this operation without affecting the result list.
   * @param list The list to append to
   * @param _other The list to be copied and appended
   */
  function merge(LinkedList memory list, LinkedList memory _other) internal pure {
    LinkedList memory other = deepCopy(_other);
    if (list.length == 0) {
      list.head = other.head;
      list.length = other.length;
    } else if (other.length > 0) {
      Node memory lastNode = getNode(list, list.length - 1);
      Node memory otherHead = getNode(other, 0);

      Node[] memory otherHeadPointer = buildNodePointer(otherHead);
      lastNode.next = otherHeadPointer;

      Node[] memory lastNodePointer = buildNodePointer(lastNode);
      otherHead.previous = lastNodePointer;

      list.length += other.length;
    }
  }

  /**
   * @notice Creates a new list that is a result of concatenation of the lists passed as arguments. Both lists
   * will be deep copied so they can be safely modified after this operation without affecting the result list.
   * @param list The first list to concatenate
   * @param other The second list to concatenate
   * @return newList A new list that is a result of concatenation of the lists passed as arguments
   */
  function concat(
    LinkedList memory list,
    LinkedList memory other
  ) internal pure returns (LinkedList memory) {
    LinkedList memory newList = deepCopy(list);

    merge(newList, other);
    return newList;
  }

  /**
   * @notice Creates a deep copy of the list
   * @param list The list to copy
   * @return copiedList A copy of the original list
   */
  function deepCopy(
    LinkedList memory list
  ) internal pure returns (LinkedList memory copiedList) {
    LinkedList memory newList = empty();
    newList.head = new Node[](list.head.length);
    for (uint256 i = 0; i < list.length; i++) {
      push(newList, getNode(list, i).value);
    }
    return newList;
  }

  /**
   * @notice Iterates over the list and calls the callback function for each element in order to check
   * if the condition is met for at least one element. Callbacks are only executed until one of the callback
   * invocations returns true.
   * @param list The list to iterate over
   * @param callback The function to call for each element. It accepts the element and the index as parameters.
   */
  function some(
    LinkedList memory list,
    function(bytes memory, uint256) view returns (bool) callback
  ) internal view returns (bool) {
    for (uint256 i = 0; i < list.length; i++) {
      if (callback(getNode(list, i).value, i)) {
        return true;
      }
    }
    return false;
  }

  /**
   * @notice Iterates over the list and calls the callback function for each element in order to check
   * if the condition is met for all elements. Callbacks are only executed until one of the callback
   * invocations returns false.
   * @param list The list to iterate over
   * @param callback The function to call for each element. It accepts the element and the index as parameters.
   * @return true If the callback returns true for all elements, false otherwise
   */
  function every(
    LinkedList memory list,
    function(bytes memory, uint256) view returns (bool) callback
  ) internal view returns (bool) {
    for (uint256 i = 0; i < list.length; i++) {
      if (!callback(getNode(list, i).value, i)) {
        return false;
      }
    }
    return true;
  }

  /**
   * @notice Iterates over the list and calls the callback function for each element
   * @param list The list to iterate over
   * @param callback The function to call for each element. It accepts the element and the index as parameters
   */
  function forEach(
    LinkedList memory list,
    function(bytes memory, uint256) callback
  ) internal {
    for (uint256 i = 0; i < list.length; i++) {
      callback(getNode(list, i).value, i);
    }
  }

  /**
   * @notice Creates a new list with elements that are the result of calling the callback function for each element
   * @param list The list to iterate over
   * @param callback The function to call for each element. It accepts the element and the index as parameters
   * and returns a new item
   */
  function map(
    LinkedList memory list,
    function(bytes memory, uint256) view returns (bytes memory) callback
  ) internal view returns (LinkedList memory) {
    LinkedList memory mappedList = empty();
    for (uint256 i = 0; i < list.length; i++) {
      push(mappedList, callback(getNode(list, i).value, i));
    }
    return mappedList;
  }

  /**
   * @notice Creates a new array of uint256 that are the result of calling the callback function for each element
   * @param list The list to iterate over
   * @param callback The function to call for each element. It accepts the element and the index as parameters
   * and returns a new item
   * @return array A new array of uint256
   */
  function mapToUintArray(
    LinkedList memory list,
    function(bytes memory, uint256) view returns (uint) callback
  ) internal view returns (uint256[] memory) {
    uint256[] memory array = new uint256[](list.length);
    for (uint256 i = 0; i < list.length; i++) {
      array[i] = callback(getNode(list, i).value, i);
    }
    return array;
  }

  /**
   * @notice Creates a new array of int256 that are the result of calling the callback function for each element
   * @param list The list to iterate over
   * @param callback The function to call for each element. It accepts the element and the index as parameters
   * and returns a new item
   * @return array A new array of int256
   */
  function mapToIntArray(
    LinkedList memory list,
    function(bytes memory, uint) view returns (int) callback
  ) internal view returns (int[] memory) {
    int[] memory array = new int[](list.length);
    for (uint256 i = 0; i < list.length; i++) {
      array[i] = callback(getNode(list, i).value, i);
    }
    return array;
  }

  /**
   * @notice Creates a new array of boolean values that are the result of calling the callback function for each element
   * @param list The list to iterate over
   * @param callback The function to call for each element. It accepts the element and the index as parameters
   * and returns a new item
   * @return array A new array of boolean values
   */
  function mapToBoolArray(
    LinkedList memory list,
    function(bytes memory, uint256) view returns (bool) callback
  ) internal view returns (bool[] memory) {
    bool[] memory array = new bool[](list.length);
    for (uint256 i = 0; i < list.length; i++) {
      array[i] = callback(getNode(list, i).value, i);
    }

    return array;
  }

  /**
   * @notice Creates a new array of addresses that are the result of calling the callback function for each element
   * @param list The list to iterate over
   * @param callback The function to call for each element. It accepts the element and the index as parameters
   * and returns a new item
   * @return array A new array of addresses
   */
  function mapToAddressArray(
    LinkedList memory list,
    function(bytes memory, uint256) view returns (address) callback
  ) internal view returns (address[] memory) {
    address[] memory array = new address[](list.length);
    for (uint256 i = 0; i < list.length; i++) {
      array[i] = callback(getNode(list, i).value, i);
    }

    return array;
  }

  /**
   * @notice Creates a new array of string values that are the result of calling the callback function for each element
   * @param list The list to iterate over
   * @param callback The function to call for each element. It accepts the element and the index as parameters
   * and returns a new item
   * @return array A new array of string values
   */
  function mapToStringArray(
    LinkedList memory list,
    function(bytes memory, uint256) view returns (string memory) callback
  ) internal view returns (string[] memory) {
    string[] memory array = new string[](list.length);
    for (uint256 i = 0; i < list.length; i++) {
      array[i] = callback(getNode(list, i).value, i);
    }

    return array;
  }

  /**
   * @notice Filters the list and creates a new list with the elements that match the condition
   * @param list The list to filter
   * @param callback The function to check if element matches the condition. It accepts the element and the index as parameters.
   * @return filteredList A new list with the elements that match the condition
   */
  function filter(
    LinkedList memory list,
    function(bytes memory, uint256) view returns (bool) callback
  ) internal view returns (LinkedList memory) {
    LinkedList memory filteredList = empty();
    for (uint256 i = 0; i < list.length; i++) {
      if (callback(getNode(list, i).value, i)) {
        push(filteredList, getNode(list, i).value);
      }
    }
    return filteredList;
  }

  /**
   * @notice Reduces the list to a single value by calling the callback function for each element
   * @param list The list to reduce
   * @param callback The function to call for each element. It accepts the accumulator, the current element
   * and the index as parameters.
   * @param initialValue The initial value of the accumulator
   * @return accumulator The final value of the accumulator
   */
  function reduce(
    LinkedList memory list,
    function(bytes memory, bytes memory, uint256) view returns (bytes memory) callback,
    bytes memory initialValue
  ) internal view returns (bytes memory) {
    bytes memory accumulator = initialValue;
    for (uint256 i = 0; i < list.length; i++) {
      accumulator = callback(accumulator, getNode(list, i).value, i);
    }
    return accumulator;
  }

  /**
   * @notice Sorts the list using quicksort algorithm
   * @param list The list to sort
   * @param callback The function to compare two elements. It accepts two elements and returns:
   * -1 if the first element is smaller than the second element
   * 0 if the first element is equal to the second element
   * 1 if the first element is greater than the second element
   * @dev The input list is not copied, so the original list is modified
   */
  function sort(
    LinkedList memory list,
    function(bytes memory, bytes memory) view returns (int256) callback
  ) internal view {
    _quickSort(list, 0, int256(list.length - 1), callback);
  }

  function _quickSort(
    LinkedList memory list,
    int256 left,
    int256 right,
    function(bytes memory, bytes memory) view returns (int256) callback
  ) private view {
    int256 i = left;
    int256 j = right;
    if (i == j) return;
    Node memory pivot = getNode(list, uint256(left + (right - left) / 2));
    while (i <= j) {
      while (callback(getNode(list, uint256(i)).value, pivot.value) == -1) i++;
      while (callback(getNode(list, uint256(j)).value, pivot.value) == 1) j--;
      if (i <= j) {
        bytes memory iNodeValue = getNode(list, uint256(i)).value;
        bytes memory jNodeValue = getNode(list, uint256(j)).value;
        set(list, uint256(i), jNodeValue);
        set(list, uint256(j), iNodeValue);
        i++;
        j--;
      }
    }
    if (left < j) _quickSort(list, left, j, callback);
    if (i < right) _quickSort(list, i, right, callback);
  }
}
