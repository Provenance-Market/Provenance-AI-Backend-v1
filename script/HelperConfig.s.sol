// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script {
    string public constant EXAMPLE_URI =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    uint256 public mintFee = 100000000000000; // 0.0001 ether

    address[] public payees = [
        0x7bE0e2BA81E9805F834Ee5661693241b3DC3034E,
        0x111882696d2eCD112FB55C6829C1dad04d44397b,
        0xE33cb5b4B828C775122FB90F7Dcc7c750b4aee3f
    ];

    function getAllPayees() external view returns (address[] memory) {
        return payees;
    }

    function splitSharesEvenly() public view returns (uint[] memory) {
        uint[] memory sharesArray = new uint[](payees.length);
        for (uint i = 0; i < payees.length; i++) {
            sharesArray[i] = 1;
        }
        return sharesArray;
    }
}
