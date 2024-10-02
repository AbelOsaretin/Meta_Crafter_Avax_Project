// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {StoreContract} from "../src/Degen.sol";

contract DegenScript is Script {
    StoreContract public store;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        store = new StoreContract(msg.sender);

        console.log("Store Contract Deployed to : ", address(store));

        vm.stopBroadcast();
    }
}
