// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Test} from "forge-std/Test.sol";
import {ProvNFTFactory, ProvNFT} from "../src/ProvNFTFactory.sol";
import {DeployProvNFTFactory} from "../script/deployProvNFT.s.sol";

contract BasicNftFactoryTest is Test {
    DeployProvNFTFactory public deployProvNFTFactory;
    ProvNFTFactory public provNFTFactory;

    string public name = "ProvNFT";
    string public symbol = "PROV";
    uint256 public mintFee = 1000000000000000;
    address[] public payees = [
        0x7bE0e2BA81E9805F834Ee5661693241b3DC3034E,
        0x111882696d2eCD112FB55C6829C1dad04d44397b,
        0xE33cb5b4B828C775122FB90F7Dcc7c750b4aee3f
    ];

    address public constant USER = address(1);
    uint256 public constant SEND_VALUE = 0.1 ether;
    uint256 public constant STARTING_USER_BALANCE = 10 ether;
    uint256 public constant GAS_PRICE = 1;

    // Util function to calculate shares array
    function splitSharesEvenly() public view returns (uint[] memory) {
        uint[] memory sharesArray = new uint[](payees.length);
        for (uint i = 0; i < payees.length; i++) {
            sharesArray[i] = 1;
        }
        return sharesArray;
    }

    // Util function to convert string to keccak256 hash
    function convertToHash(
        string memory string_1,
        string memory string_2
    ) public pure returns (bytes32, bytes32) {
        bytes32 h_1 = keccak256(abi.encodePacked(string_1));
        bytes32 h_2 = keccak256(abi.encodePacked(string_2));

        return (h_1, h_2);
    }

    // Set up the tests by deploying a new DeployProvNFTFactory
    function setUp() public {
        deployProvNFTFactory = new DeployProvNFTFactory();
        provNFTFactory = deployProvNFTFactory.run();
    }

    function testDeployNftFromFactory() public {
        provNFTFactory.createBasicNft(
            name,
            symbol,
            payees,
            splitSharesEvenly(),
            mintFee
        );

        ProvNFT[] memory deployedContracts = provNFTFactory
            .getDeployedContracts();

        assert(deployedContracts.length == 1);
    }

    function testNameAndSymbolIsCorrect() public {
        // String comparison in Solidity is tricky. We can't just compare
        string memory expectedName = "TestNft";
        string memory expectedSymbol = "TEST";

        provNFTFactory.createBasicNft(
            expectedName,
            expectedSymbol,
            payees,
            splitSharesEvenly(),
            mintFee
        );

        ProvNFT[] memory deployedContracts = provNFTFactory
            .getDeployedContracts();

        // Get first deployed contract
        ProvNFT provNFT = deployedContracts[0];

        string memory actualName = provNFT.name();
        string memory actualSymbol = provNFT.symbol();

        bytes32 h_expectedName;
        bytes32 h_actualName;
        (h_expectedName, h_actualName) = convertToHash(
            expectedName,
            actualName
        );

        bytes32 h_expectedSymbol;
        bytes32 h_actualSymbol;
        (h_expectedSymbol, h_actualSymbol) = convertToHash(
            expectedSymbol,
            actualSymbol
        );

        assert(
            h_expectedName == h_actualName && h_expectedSymbol == h_actualSymbol
        );
    }

    function testMintFeeIsCorrect() public {
        provNFTFactory.createBasicNft(
            name,
            symbol,
            payees,
            splitSharesEvenly(),
            mintFee
        );

        ProvNFT[] memory deployedContracts = provNFTFactory
            .getDeployedContracts();

        // Get first deployed contract
        ProvNFT provNFT = deployedContracts[0];

        uint256 actualMintFee = provNFT.mintPrice();

        assert(mintFee == actualMintFee);
    }

    function testPayeesAreCorrect() public {
        provNFTFactory.createBasicNft(
            name,
            symbol,
            payees,
            splitSharesEvenly(),
            mintFee
        );

        ProvNFT[] memory deployedContracts = provNFTFactory
            .getDeployedContracts();

        // Get first deployed contract
        ProvNFT provNFT = deployedContracts[0];

        for (uint i = 0; i < payees.length; i++) {
            assert(payees[i] == provNFT.owners(i));
        }
    }

    function testSplitSharesEvenly() public {
        uint256[] memory sharesArray = splitSharesEvenly();

        provNFTFactory.createBasicNft(
            name,
            symbol,
            payees,
            sharesArray,
            mintFee
        );

        ProvNFT[] memory deployedContracts = provNFTFactory
            .getDeployedContracts();

        // Get first deployed contract
        ProvNFT provNFT = deployedContracts[0];

        for (uint i = 0; i < payees.length; i++) {
            assert(provNFT.shares(payees[i]) == sharesArray[i]);
        }
    }

    function testReleaseFundsEvenly() public {
        // Set up prank and deal some Ether to USER
        hoax(USER, STARTING_USER_BALANCE);

        // Create a BasicNFT
        provNFTFactory.createBasicNft(
            name,
            symbol,
            payees,
            splitSharesEvenly(),
            mintFee
        );

        ProvNFT[] memory deployedContracts = provNFTFactory
            .getDeployedContracts();

        // Get first deployed contract
        ProvNFT provNFT = deployedContracts[0];

        // Fund the contract
        vm.prank(USER);
        address(provNFT).call{value: SEND_VALUE}("");

        // Record initial balances of all payees
        uint256[] memory initialBalances = new uint256[](payees.length);
        for (uint i = 0; i < payees.length; i++) {
            initialBalances[i] = payees[i].balance;
        }

        // Release the funds
        for (uint i = 0; i < payees.length; i++) {
            provNFT.release(payable(payees[i]));
        }

        // Check if funds were released equally among payees
        uint256 share = SEND_VALUE / payees.length;
        for (uint i = 0; i < payees.length; i++) {
            assertEq(payees[i].balance, initialBalances[i] + share);
        }
    }
}
