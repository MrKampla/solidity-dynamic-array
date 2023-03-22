// SPDX-License-Identifier: MIT
pragma solidity >=0.4.0;

import './DynamicArray.sol';

/**
 * @notice An associative array implemented using a dynamic array. It functions like a map or dictionary.
 * @dev A library for storing key-value pairs in a associative array. The keys and values are stored in a dynamic
 * in-memory array.
 * @param keys The keys of the map.
 * @param values The values of the map.
 */
struct Map {
  LinkedList keys;
  LinkedList values;
}

/**
 * @notice A library for storing key-value pairs in a associative array. The keys and values are stored in a dynamic
 * in-memory array. Because of that, the set and lookup times are O(n) where n is the number of elements in the map.
 * @dev Please note that this implementation is not optimized for big maps. Proceed with caution when using it with large
 * amounts of data and check the gas usage.
 * @author MrKampla
 */
library ArrayMap {
  using DynamicArray for LinkedList;

  /**
   * @notice Creates an empty map.
   * @return An empty map.
   */
  function empty() internal pure returns (Map memory) {
    return Map({keys: DynamicArray.empty(), values: DynamicArray.empty()});
  }

  /**
   * @notice Creates a map from an unbounded list of key-value pairs.
   * @param keyValuePairs A list of key-value pairs.
   * @return A map with the key-value pairs.
   */
  function fromKeyValuePairs(
    bytes[][] memory keyValuePairs
  ) internal pure returns (Map memory) {
    Map memory map = empty();
    for (uint i = 0; i < keyValuePairs.length; i++) {
      require(keyValuePairs[i].length == 2, 'Key-value pair must have two elements');
      set(map, keyValuePairs[i][0], keyValuePairs[i][1]);
    }
    return map;
  }

  /**
   * @notice Creates a map from two separate lists of keys and values.
   * @param keys A list of keys.
   * @param values A list of values.
   * @return A map with the key-value pairs.
   */
  function fromEntries(
    bytes[] memory keys,
    bytes[] memory values
  ) internal pure returns (Map memory) {
    require(keys.length == values.length, 'Keys and values must have the same length');
    Map memory map = empty();
    for (uint i = 0; i < keys.length; i++) {
      set(map, keys[i], values[i]);
    }
    return map;
  }

  /**
   * @notice Sets a key-value pair in the map. If the key already exists, the value is updated. Otherwise, a new key-value
   * pair is added.
   * @param map The map to update
   * @param key The key to set
   * @param value The value to set
   */
  function set(Map memory map, bytes memory key, bytes memory value) internal pure {
    int index = map.keys.indexOf(key);
    if (index != -1) {
      map.values.set(uint(index), value);
      return;
    }
    map.keys.push(key);
    map.values.push(value);
  }

  /**
   * @notice Gets the value associated with the key. If the key does not exist, the function reverts.
   * @param map The map to get the value from
   * @param key The key to get the value for
   * @return The value associated with the key
   */
  function get(Map memory map, bytes memory key) internal pure returns (bytes memory) {
    bytes memory result = tryGet(map, key);
    if (keccak256(result) == keccak256(bytes(''))) {
      revert('Key not found');
    }
    return result;
  }

  /**
   * @notice Gets the value associated with the key. If the key does not exist, the function returns an empty bytes value.
   * @param map The map to get the value from
   * @param key The key to get the value for
   * @return The value associated with the key
   */
  function tryGet(Map memory map, bytes memory key) internal pure returns (bytes memory) {
    int index = map.keys.indexOf(key);
    if (index != -1) {
      return map.values.get(uint(index));
    }
    return '';
  }

  /**
   * @notice Removes a key-value pair from the map. If the key does not exist, the function does nothing.
   * @param map The map to remove the key-value pair from
   * @param key The key to remove
   */
  function remove(Map memory map, bytes memory key) internal pure {
    int index = map.keys.indexOf(key);
    if (index != -1) {
      map.keys.remove(uint(index));
      map.values.remove(uint(index));
    }
  }

  /**
   * @notice Checks if the map contains a key.
   * @param map The map to check
   * @param key The key to check
   * @return True if the map contains the key, false otherwise
   */
  function contains(Map memory map, bytes memory key) internal pure returns (bool) {
    return map.keys.indexOf(key) != -1;
  }

  /**
   * @notice Gets the number of key-value pairs in the map.
   * @param map The map to get the size of
   * @return The number of key-value pairs in the map
   */
  function size(Map memory map) internal pure returns (uint) {
    return map.keys.length;
  }

  /**
   * @notice Gets the keys of the map.
   * @param map The map to get the keys from
   * @return The array of keys of the map
   */
  function getKeys(Map memory map) internal pure returns (bytes[] memory) {
    return map.keys.toArray();
  }

  /**
   * @notice Gets the values of the map.
   * @param map The map to get the values from
   * @return The array of values of the map
   */
  function getValues(Map memory map) internal pure returns (bytes[] memory) {
    return map.values.toArray();
  }

  /**
   * @notice Clears the map by removing all key-value pairs.
   * @param map The map to clear
   */
  function clear(Map memory map) internal pure {
    map.keys = DynamicArray.empty();
    map.values = DynamicArray.empty();
  }

  /**
   * @notice Gets the key-value pairs of the map.
   * @param map The map to get the key-value pairs from
   * @return _keys The array of keys of the map
   * @return _values The array of values of the map
   */
  function entries(
    Map memory map
  ) internal pure returns (bytes[] memory _keys, bytes[] memory _values) {
    return (map.keys.toArray(), map.values.toArray());
  }
}
