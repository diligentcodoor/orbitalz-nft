// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import {ERC721A} from "erc721a/ERC721A.sol";
import {Owned} from "solmate/auth/Owned.sol";

error BigBangNotStarted();
error UniverseExpansionLimit();
error RobotzCantMint();
error BlackHoleError();

contract Orbitalz is ERC721A, Owned {
    bool public afterBigBang = false;
    string public baseURI;
    uint256 public constant WALLET_LIMIT = 3;
    uint256 public constant TOTAL_SUPPLY = 10_000;

    constructor(string memory baseTokenURI) ERC721A("Orbitalz", "ORBITALZ") Owned(msg.sender) {
        baseURI = baseTokenURI;
    }

    function bigBang() external payable {
        if (!afterBigBang) {
            revert BigBangNotStarted();
        }
        if (msg.sender != tx.origin) {
            revert RobotzCantMint();
        }
        if (balanceOf(msg.sender) > 0) {
            revert BlackHoleError();
        }
        uint256 toMint = min(TOTAL_SUPPLY - _totalMinted(), WALLET_LIMIT);
        if (toMint == 0) {
            revert UniverseExpansionLimit();
        }
        _mint(msg.sender, toMint);
    }

    function godBigBang(address god, uint256 orbitalz) external onlyOwner {
        if (orbitalz + _totalMinted() > TOTAL_SUPPLY) {
            revert UniverseExpansionLimit();
        }
        _mint(god, orbitalz);
    }

    function setAfterBigBang(bool _afterBigBang) external onlyOwner {
        afterBigBang = _afterBigBang;
    }

    function harvestStarDust() external onlyOwner {
        (bool success,) = payable(owner).call{value: address(this).balance}("");
        require(success);
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }
}
