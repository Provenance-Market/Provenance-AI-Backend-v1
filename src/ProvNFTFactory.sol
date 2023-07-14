// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ProvNFT} from "./ProvNFT.sol";

contract ProvNFTFactory {
    ProvNFT[] public deployedContracts;

    function createBasicNft(
        string memory name,
        string memory symbol,
        address[] memory payees,
        uint256[] memory shares,
        uint256 mintFee
    ) public {
        ProvNFT newBasicNft = new ProvNFT(
            name,
            symbol,
            payees,
            shares,
            mintFee
        );
        deployedContracts.push(newBasicNft);
    }

    function getDeployedContracts() public view returns (ProvNFT[] memory) {
        return deployedContracts;
    }
}
