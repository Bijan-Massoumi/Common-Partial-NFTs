// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import "forge-std/Test.sol";
import "../../src/PaCoExample.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./TestERC20.sol";
import {AdvancedOrder, OrderParameters} from "../../src/SeaportStructs.sol";

abstract contract TestPacoToken is Test {
    PaCoExample paco;
    TestToken bondToken;
    uint256 oneETH = 10**18;

    address withdrawAddr = address(1137);
    address tokenWhale = 0xBecAa4aD36e5d134fD6979cc6780EB48aC5B5a93;
    address owner = address(1);
    address addr2 = address(2);
    address addr3 = address(3);
    uint256 startBlockTimestamp = 1642941822;
    // 20% annual rate
    uint16 feeRate = 2000;

    function setUp() public virtual {
        // launch contracts
        vm.warp(startBlockTimestamp);
        bondToken = new TestToken("TestToken", "TT");
        vm.prank(tokenWhale);
        bondToken.mint(oneETH * 1000000000);
        vm.startPrank(owner);
        paco = new PaCoExample(address(bondToken), withdrawAddr, feeRate);
        vm.stopPrank();

        // approve PaCo allowance for bond token
        vm.prank(tokenWhale);
        bondToken.approve(address(paco), oneETH * 10000);
        vm.prank(owner);
        bondToken.approve(address(paco), oneETH * 10000);
        vm.prank(addr2);
        bondToken.approve(address(paco), oneETH * 10000);

        // fund wallets
        vm.startPrank(tokenWhale);
        bondToken.transfer(owner, oneETH * 500);
        bondToken.transfer(addr2, oneETH * 500);
        vm.stopPrank();
    }

    function approveNewAddress(address addr) public {
        vm.startPrank(addr);
        bondToken.approve(address(paco), oneETH * 10000);
        vm.stopPrank();
    }
}
