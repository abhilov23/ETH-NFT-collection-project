//SPDX-License-Identifier:MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployBasicNft} from "../script/DeployBasicNft.s.sol";
import {BasicNFT} from "../src/BasicNFT.sol";


contract BasicNftTest is Test{
    DeployBasicNft public deployer;
    BasicNFT public basicNft;

    function setUp() public{
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    function testNameIsCorrect() public view{
        string memory expectedName = "Doggy";
        string memory actualName = basicNft.name();
        //comparing two strings by encoding them
        assert(keccak256(abi.encodePacked(expectedName)) == keccak256(abi.encodePacked(actualName)));
    }
}