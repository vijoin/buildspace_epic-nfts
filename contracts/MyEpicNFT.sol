//SPDX-License-Identifier: GPL-3

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "hardhat/console.sol";

contract MyEpicNFT is ERC721URIStorage {
    
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";


    string[] firstWords = ["Actual", "Acid", "Ill", "Military", "Sharp"];
    string[] secondWords = ["Naive", "Apathetic", "Parched", "Tired", "Hurt"];
    string[] thirdWords = ["Outcome", "Employee", "Society", "Government", "Office"];

    constructor() ERC721 ("SquareNFT", "SQUARE") {
        console.log("This is my NFT contract. Yei!");
    }

    function pickRandomWord(uint256 tokenId, string memory salt, string[] memory words) public pure returns (string memory) {
        uint256 rand = random(string(abi.encodePacked(salt, Strings.toString(tokenId))));
        rand = rand % words.length;
        return words[rand];
    }

    function random (string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function makeAnEpicNFT() public {
        uint256 newItemId = _tokenIds.current();

        string memory first = pickRandomWord(newItemId, "FIRST_WORD", firstWords);
        string memory second = pickRandomWord(newItemId, "SECOND_WORD", secondWords);
        string memory third = pickRandomWord(newItemId, "THIRD_WORD", thirdWords);
        string memory combinedWord = string(abi.encodePacked(first, second, third));

        string memory finalSvg = string(abi.encodePacked(baseSvg, combinedWord, "</text></svg>"));

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                    '{"name": "',
                    combinedWord,
                    '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                    Base64.encode(bytes(finalSvg)),
                    '"}'
                    )
                )
            )

        );


        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n--------------------");
        console.log(finalTokenUri);
        console.log("--------------------\n");


        _safeMint(msg.sender, newItemId);

        _setTokenURI(
            newItemId, finalTokenUri);
        
        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
        _tokenIds.increment();
    }
}