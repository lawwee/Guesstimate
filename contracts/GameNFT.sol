// SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import { Base64 } from "./libraries/Base64.sol";

contract GameNFT is ERC721URIStorage {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 private seed;

    string svgPartOne = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='";
    string svgPartTwo = "'/><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] colors = ["red"];

    mapping (address => uint256) public lastWavedAt;

    constructor() ERC721("Game NFT", "GAME") payable {
        console.log("Lawwee is here");

        seed = (block.timestamp + block.difficulty) % 100;
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function randomColor(string memory input) public view returns (uint256) {
        uint256 rand = random(string(abi.encodePacked("Color", input)));
        rand = rand % colors.length;
        return uint256(keccak256(abi.encodePacked(rand)));
    }

    function pickRandomColor(uint256 tokenId) public view returns (string memory) {
        uint256 rando = randomColor(string(abi.encodePacked("RanDomCOloR", Strings.toString(tokenId))));
        uint256 rand = (block.timestamp + block.difficulty + seed + rando) % 100;
        rand = rand % colors.length;
        return colors[rand];
    }

    function compareTwoStrings(string memory s1, string memory s2) public pure returns (bool success) {
        return keccak256(abi.encodePacked(s1)) == keccak256(abi.encodePacked(s2));
    }

    function mintNFT(string memory fword, string memory sword, string memory tword) public {
        // require(lastWavedAt[msg.sender] + 24 hours < block.timestamp, "Wait a day");
        // require((lastWavedAt[msg.sender] + 24 hours < block.timestamp) && (lastWavedAt[msg.sender] + 744 hours < block.timestamp), "Wait a month");
        if ((lastWavedAt[msg.sender] + 24 hours < block.timestamp) && (lastWavedAt[msg.sender] + 744 hours < block.timestamp)) {
            console.log("Hello");
        } else if (lastWavedAt[msg.sender] + 24 hours < block.timestamp) {
            console.log("World");
        }

        lastWavedAt[msg.sender] = block.timestamp;

        uint256 newItemId = _tokenIds.current();

        string memory someColor = pickRandomColor(newItemId);

        string memory combinedWord = string(abi.encodePacked(fword, sword, tword));

        string memory finalSvg = string(abi.encodePacked(svgPartOne, someColor, svgPartTwo, combinedWord, "</text></svg>"));

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        combinedWord,
                        '", "description": "A highly acclaimed collection of squares", "image": "data:image/svg+xml;base64',
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log(
            string(
                abi.encodePacked(
                    "https://nftpreview.0xdev.codes/?code=",
                    finalTokenUri
                )
            )
        );

        uint256 prizeAmount = 1 ether;

        bool success = compareTwoStrings(someColor, tword);
        if (success == true) {
            require(prizeAmount <= address(this).balance, "You do not have enough ether to send");
            msg.sender.call{value: prizeAmount}("");
            console.log("Finally, Lawwee did it");
        } else {
            console.log("Still proof that he did it");
        }

        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, finalTokenUri);
        console.log("An NFT w/ ID %s has been minted to %s:", newItemId, msg.sender);

        _tokenIds.increment();
    }

}