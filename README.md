# Degen Solidity Project

## Overview

This project consists of two smart contracts:

1. **Degen** - A custom ERC20 token contract built using OpenZeppelin's ERC20, ERC20Burnable, and Ownable libraries. The contract allows the owner to mint tokens to specific addresses.
2. **StoreContract** - A contract that allows users to add items to their store by locking Degen tokens and redeem tokens back by removing items from the store.

---

## Contracts

### Degen (ERC20 Token Contract)

The `Degen` contract is an ERC20 token contract that allows the owner to mint tokens. It also includes the ability to burn tokens.

#### Key Features

- **Minting**: The owner of the contract can mint Degen tokens to specific addresses.
- **Burning**: Any holder of Degen tokens can burn their tokens using the `burn` functionality provided by OpenZeppelin's `ERC20Burnable`.

#### Constructor

```solidity
constructor(address initialOwner)
```

- `initialOwner`: The owner of the contract, who will have the minting rights.

#### Functions

1. **mint**
   ```solidity
   function mint(address to, uint256 amount) external onlyOwner
   ```
   - `to`: The address to which tokens will be minted.
   - `amount`: The number of tokens to be minted.
   - Only the owner can call this function.

---

### StoreContract (Item Store Using Degen Tokens)

The `StoreContract` allows users to add items to their store, where each item is associated with a specific price in Degen tokens. Users must lock the Degen tokens when they add an item, and they can redeem tokens by removing items from the store.

#### Key Features

- **Add Items to Store**: Users can add items to the store by locking Degen tokens.
- **Redeem Tokens**: Users can redeem the tokens by removing the items from the store.
- **Store Ownership**: Each item in the store is owned by the address that added it.

#### Struct: Store

```solidity
struct Store {
    address owner;
    uint256 itemId;
    uint256 price;
}
```

- `owner`: The address of the owner who added the item.
- `itemId`: The ID of the item.
- `price`: The price of the item, in Degen tokens.

#### Constructor

```solidity
constructor(address _degen)
```

- `_degen`: The address of the deployed Degen token contract.

#### Functions

1. **addToStore**

   ```solidity
   function addToStore(uint256 _itemId, uint256 _price) external
   ```

   - `itemId`: The unique ID of the item.
   - `price`: The price of the item, in Degen tokens.
   - This function allows users to add an item to the store. The price in Degen tokens is transferred from the user's wallet to the contract.
   - Emits the `ItemAdded` event.

2. **redeemToken**

   ```solidity
   function redeemToken(uint256 _itemId) external
   ```

   - `itemId`: The ID of the item to be redeemed.
   - This function allows users to remove an item from the store and redeem their staked Degen tokens.
   - Emits the `ItemRedeemed` event.

3. **getItemId**
   ```solidity
   function getItemId(uint256 _itemId) external view returns (Store memory)
   ```
   - `itemId`: The ID of the item to retrieve.
   - This function allows users to view details of an item in the store.

#### Events

1. **ItemAdded**
   ```solidity
   event ItemAdded(address owner, uint256 itemId, uint256 price)
   ```
   - Emitted when an item is successfully added to the store.
2. **ItemRedeemed**
   ```solidity
   event ItemRedeemed(address owner, uint256 itemId, uint256 price)
   ```
   - Emitted when an item is successfully redeemed from the store.

---

## How to Deploy

```shell
$ forge script script/Degen.s.sol:DegenScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

## License

This project is licensed under the MIT License.
