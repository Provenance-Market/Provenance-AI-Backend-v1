// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Script} from "forge-std/Script.sol";
import {ProvNFTFactory} from "../src/ProvNFTFactory.sol";
import {ProvNFT} from "../src/ProvNFT.sol";

// Wont be using the deployProvNFT script below, see deployProvNFTFactory below
contract deployProvNFT is Script {
    // global variables for mintPrice == 0.1 ether
    string public name = "ProvNFT";
    string public symbol = "PROV";

    uint256 public mintFee = 1000000000000000; // 0.001 ether

    address[] public payees = [
        0x7bE0e2BA81E9805F834Ee5661693241b3DC3034E,
        0x111882696d2eCD112FB55C6829C1dad04d44397b,
        0xE33cb5b4B828C775122FB90F7Dcc7c750b4aee3f
    ];

    function splitSharesEvenly() public view returns (uint[] memory) {
        uint[] memory sharesArray = new uint[](payees.length);
        for (uint i = 0; i < payees.length; i++) {
            sharesArray[i] = 1;
        }
        return sharesArray;
    }

    function run() external returns (ProvNFT) {
        vm.startBroadcast();
        ProvNFT provNFT = new ProvNFT(
            name,
            symbol,
            payees,
            splitSharesEvenly(),
            mintFee
        );
        vm.stopBroadcast();
        return provNFT;
    }
}

// Rather deploy ProvNFT via the ProvNFTFactory
contract DeployProvNFTFactory is Script {
    function run() external returns (ProvNFTFactory) {
        vm.startBroadcast();
        ProvNFTFactory provNFTFactory = new ProvNFTFactory();
        vm.stopBroadcast();
        return provNFTFactory;
    }
}
