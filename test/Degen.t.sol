// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {StoreContract} from "../src/Degen.sol";

contract DegenTest is Test {
    StoreContract public store;

    address owner = makeAddr("Owner");
    address user = makeAddr("User");

    function setUp() public {
        store = new StoreContract(owner);
        vm.startPrank(owner);
        store.mint(owner, 10000);
        store.approve(address(store), 10000);
        store.transfer(user, 100);
    }

    function test_Add_To_Store() public {
        vm.startPrank(user);
        store.addToStore(1, 100);

        // Retrieve the stored item using the correct struct type
        StoreContract.Store memory storedItem = store.getItemId(1);

        // Ensure that the values match the expected inputs
        assertEq(storedItem.owner, user);
        assertEq(storedItem.price, 100);
        assertEq(storedItem.itemId, 1);
    }

    function test_Adding_Old_Item_To_Store() public {
        vm.startPrank(user);
        store.addToStore(1, 100);
        vm.expectRevert();
        store.addToStore(1, 100);
    }

    function test_Redeem_Item_Not_In_Store() public {
        vm.startPrank(user);

        vm.expectRevert();
        store.redeemToken(1);
    }

    function test_Redeem_From_Store() public {
        test_Add_To_Store();
        store.redeemToken(1);
    }

    function test_Token_Transfer() public {
        vm.startPrank(owner);
        store.transferFrom(owner, user, 100);
        vm.stopPrank();
        vm.startPrank(user);
        assertEq(store.tokenBalance(), 200);
    }

    function test_Token_Burn() public {
        test_Token_Transfer();
        vm.stopPrank();
        vm.startPrank(user);
        store.burn(200);
        assertEq(store.tokenBalance(), 0);
    }
}
