// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import {ERC721A} from "erc721a/ERC721A.sol";
import {Owned} from "solmate/auth/Owned.sol";

error BigBangNotStarted();
error UniverseExpansionLimit();
error RobotzCantMint();
error BlackHoleError();

contract Orbitalz is ERC721A, Owned {
    uint256 public immutable walletLimit = 3;
    uint256 public immutable orbitalzLimit = 10_000;
    bool public afterBigBang = false;

    constructor() ERC721A("Orbitalz", "ORBITALZ") Owned(msg.sender) {}

    function bigBang() external payable {
        if (!afterBigBang) revert BigBangNotStarted();
        if (msg.sender != tx.origin) revert RobotzCantMint();
        if (balanceOf(msg.sender) > 0) revert BlackHoleError();
        uint256 toMint = min(orbitalzLimit - _totalMinted(), walletLimit);
        if (toMint == 0) revert UniverseExpansionLimit();
        _mint(msg.sender, toMint);
    }

    function godBigBang(address god, uint256 _orbitalz) public onlyOwner {
        if (_orbitalz + _totalMinted() > orbitalzLimit) revert UniverseExpansionLimit();
        _mint(god, _orbitalz);
    }

    function setAfterBigBang(bool _afterBigBang) external onlyOwner {
        require(msg.sender == owner);
        afterBigBang = _afterBigBang;
    }

    function harvestStarDust() public onlyOwner {
        (bool success, ) = payable(owner).call{value: address(this).balance}("");
        require(success);
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }
}
