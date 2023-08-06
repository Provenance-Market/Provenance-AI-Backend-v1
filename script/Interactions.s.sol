// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {ProvNFTFactory} from "../src/ProvNFTFactory.sol";
import {ProvNFT} from "../src/ProvNFT.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFactoryAndMintNft is Script {
    HelperConfig helperConfig = new HelperConfig();
    address[] public payees = helperConfig.getAllPayees();
    string public EXAMPLE_URI = helperConfig.EXAMPLE_URI();
    uint256 public mintFee = helperConfig.mintFee();

    function run() external {
        address mostRecentlyDeployedBasicNft = DevOpsTools
            .get_most_recent_deployment("ProvNFTFactory", block.chainid);
        mintNftOnContract(mostRecentlyDeployedBasicNft);
    }

    function mintNftOnContract(address basicNftAddress) public {
        vm.startBroadcast();
        ProvNFTFactory(basicNftAddress).createBasicNft(
            "TEST OPENSEA",
            "TOS",
            payees,
            helperConfig.splitSharesEvenly(),
            mintFee
        );
        //Need to index out latest deployment, not first
        ProvNFT provNFT = ProvNFTFactory(basicNftAddress).deployedContracts(0);
        provNFT.mint{value: mintFee}(EXAMPLE_URI);
        vm.stopBroadcast();
    }
}
