// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Degen} from "../src/Degen.sol";

contract DegenScript is Script {
    Degen public degen;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        degen = new Degen(msg.sender);

        console.log("Degen Contract Deployed to : ", address(degen));

        vm.stopBroadcast();
    }
}
