// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

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
   * @notice Removes the last value from the list
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
   * @notice retreives the Node element at the specified index without removing it
   * @param list The list to retreive the Node from
   * @param index The index of the Node to retreive
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
   * @notice retreives the value at the specified index without removing it
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
   * @notice inserts an array of values at the specified index
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
   * @notice gets the index of the first occurance of the specified value
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
   * @notice gets the index of the last occurance of the specified value
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
   * @notice Removes the first occurance of the specified value
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
   * @notice creates a solidity array from the linked list
   * @param list the list to convert
   */
  function toArray(LinkedList memory list) internal pure returns (bytes[] memory) {
    bytes[] memory values = new bytes[](list.length);
    for (uint256 i = 0; i < list.length; i++) {
      values[i] = getNode(list, i).value;
    }
    return values;
  }
}
