# freeFunction

```solidity
freeFunction freeFunction(struct Node node) internal pure returns (struct Node[])
```

This is a helper function to build a "pointer" to a Node. Technically, it is not a pointer but it functions as one.
It's used to set the previous and next

| Name | Type | Description |
| ---- | ---- | ----------- |
| node | struct Node | The node to build a pointer to |

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | struct Node[] | nodePointer The pointer to the node passed as a parameter |

