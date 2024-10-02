// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract StoreContract is ERC20, ERC20Burnable, Ownable {
    constructor(
        address initialOwner
    ) ERC20("Degen", "DGN") Ownable(initialOwner) {}

    struct Store {
        address owner;
        uint256 itemId;
        uint256 price;
    }

    mapping(address => mapping(uint256 => Store)) store;

    event ItemAdded(address owner, uint256 itemId, uint256 price);
    event ItemRedeemed(address owner, uint256 itemId, uint256 price);

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function burn(uint256 _amount) public override {
        _burn(msg.sender, _amount);
    }

    function transfer(
        address _to,
        uint256 _amount
    ) public override returns (bool) {
        _transfer(msg.sender, _to, _amount);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _amount
    ) public override returns (bool) {
        _transfer(_from, _to, _amount);
        return true;
    }

    function tokenBalance() public view returns (uint256) {
        return balanceOf(msg.sender);
    }

    function addToStore(uint256 _itemId, uint256 _price) external {
        if (store[msg.sender][_itemId].itemId == _itemId) {
            revert("Item already in store");
        }

        transferFrom(msg.sender, address(this), _price);

        store[msg.sender][_itemId].owner = msg.sender;
        store[msg.sender][_itemId].itemId = _itemId;
        store[msg.sender][_itemId].price = _price;

        emit ItemAdded(msg.sender, _itemId, _price);
    }

    function redeemToken(uint256 _itemId) external {
        if (store[msg.sender][_itemId].itemId != _itemId) {
            revert("Item not in store");
        }

        transferFrom(
            address(this),
            msg.sender,
            store[msg.sender][_itemId].price
        );
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
