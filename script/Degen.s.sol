// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Degen, StoreContract} from "../src/Degen.sol";

contract DegenScript is Script {
    Degen public degen;
    StoreContract public store;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        degen = new Degen(msg.sender);
        store = new StoreContract(address(degen));

        console.log("Degen Token Contract Deployed to : ", address(degen));
        console.log("Store Contract Deployed to : ", address(store));

        vm.stopBroadcast();
    }
}
