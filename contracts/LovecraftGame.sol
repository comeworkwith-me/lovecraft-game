// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract LovecraftGame is Ownable {
    constructor() {
        console.log("This is my game contract, flames!");
    }
}