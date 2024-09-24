// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Degen, StoreContract} from "../src/Degen.sol";

contract DegenTest is Test {
    Degen public degen;
    StoreContract public store;

    address owner = makeAddr("Owner");
    address user = makeAddr("User");

    function setUp() public {
        degen = new Degen(owner);
        store = new StoreContract(address(degen));
        vm.startPrank(owner);
        degen.mint(owner, 10000);
        degen.approve(address(store), 10000);
    }

    function test_Add_To_Store() public {
        vm.startPrank(owner);
        store.addToStore(1, 100);

        // Retrieve the stored item using the correct struct type
        StoreContract.Store memory storedItem = store.getItemId(1);

        // Ensure that the values match the expected inputs
        assertEq(storedItem.owner, owner);
        assertEq(storedItem.price, 100);
        assertEq(storedItem.itemId, 1);
    }

    function test_Adding_Old_Item_To_Store() public {
        vm.startPrank(owner);
        store.addToStore(1, 100);
        vm.expectRevert();
        store.addToStore(1, 100);
    }

    function test_Redeem_Item_Not_In_Store() public {
        vm.startPrank(owner);

        vm.expectRevert();
        store.redeemToken(1);
    }

    function test_Redeem_From_Store() public {
        test_Add_To_Store();
        store.redeemToken(1);
    }

    function test_Token_Transfer() public {
        vm.startPrank(owner);
        degen.transfer(user, 100);
        assertEq(degen.balanceOf(user), 100);
    }

    function test_Token_Burn() public {
        test_Token_Transfer();
        vm.stopPrank();
        vm.startPrank(user);
        degen.burn(100);
        assertEq(degen.balanceOf(user), 0);
    }
}
