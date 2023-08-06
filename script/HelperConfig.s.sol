// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script {
    address[] public payees = [
        0x7bE0e2BA81E9805F834Ee5661693241b3DC3034E,
        0x111882696d2eCD112FB55C6829C1dad04d44397b,
        0xE33cb5b4B828C775122FB90F7Dcc7c750b4aee3f
    ];

    function getAllPayees() external view returns (address[] memory) {
        return payees;
    }
}
