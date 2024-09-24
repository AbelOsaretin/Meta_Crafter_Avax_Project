// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Degen is ERC20, ERC20Burnable, Ownable {
    constructor(
        address initialOwner
    ) ERC20("Degen", "DGN") Ownable(initialOwner) {}

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }
}

contract StoreContract {
    Degen public degen;

    constructor(address _degen) {
        degen = Degen(_degen);
    }

    struct Store {
        address owner;
        uint256 itemId;
        uint256 price;
    }

    mapping(address => mapping(uint256 => Store)) store;

    event ItemAdded(address owner, uint256 itemId, uint256 price);
    event ItemRedeemed(address owner, uint256 itemId, uint256 price);

    function addToStore(uint256 _itemId, uint256 _price) external {
        if (store[msg.sender][_itemId].itemId == _itemId) {
            revert("Item already in store");
        }

        degen.transferFrom(msg.sender, address(this), _price);

        store[msg.sender][_itemId].owner = msg.sender;
        store[msg.sender][_itemId].itemId = _itemId;
        store[msg.sender][_itemId].price = _price;

        emit ItemAdded(msg.sender, _itemId, _price);
    }

    function redeemToken(uint256 _itemId) external {
        if (store[msg.sender][_itemId].itemId != _itemId) {
            revert("Item not in store");
        }

        degen.transfer(msg.sender, store[msg.sender][_itemId].price);
        delete store[msg.sender][_itemId];

        emit ItemRedeemed(
            msg.sender,
            _itemId,
            store[msg.sender][_itemId].price
        );
    }

    function getItemId(uint256 _itemId) external view returns (Store memory) {
        return store[msg.sender][_itemId];
    }
}
