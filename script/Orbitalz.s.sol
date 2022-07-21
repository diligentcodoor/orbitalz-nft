// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {Orbitalz} from "../src/Orbitalz.sol";

contract MyScript is Script {
    function run() external {
        vm.startBroadcast();

        Orbitalz orbitalz = new Orbitalz("ipfs://placeholder/");

        vm.stopBroadcast();
    }
}
