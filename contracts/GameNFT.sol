// SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";


import { Base64 } from "./libraries/Base64.sol";

contract GameNFT is ERC721URIStorage, VRFConsumerBaseV2 {
    VRFCoordinatorV2Interface COORDINATOR;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint64 s_subscriptionId;
    address vrfCoordinator = 0x6168499c0cFfCaCD319c818142124B7A15E857ab;
    bytes32 s_keyHash = 0xd89b2bf150e3b9e13446986e571fb9cab24b13cea0a43ea20a6049a85cc807cc;
    uint32 callbackGasLimit = 40000;
    uint16 requestConfirmations = 3;
    uint32 numWords =  1;
    uint256 private constant ROLL_IN_PROGRESS = 42;

    address s_owner;
 
    event GuessInitiated(uint256 indexed requestId, address indexed guesser);
    event GuessResult(uint256 indexed requestId, uint256 indexed result);

    mapping(uint256 => address) private s_guesser;
    mapping(address => uint256) private s_results;
    mapping (address => uint256) public lastWavedAt;

    uint256 guessPrice = 0.001 ether;
    string svgPartOne = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='";
    string svgPartTwo = "'/><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    constructor(uint64 subscriptionId) VRFConsumerBaseV2(vrfCoordinator) ERC721("Game NFT", "GAME") payable {
        COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
        s_owner = msg.sender;
        s_subscriptionId = subscriptionId;
        console.log("Lawwee is here");
    }

    modifier onlyOwner() {
        require(msg.sender == s_owner);
        _;
    }

    function guessColor(address guesser) public payable onlyOwner returns (uint256 requestId) {
        require(lastWavedAt[msg.sender] > block.timestamp, "You need to wait a day");
        require(msg.value >= guessPrice, "You do not have enough ether");
        
        requestId = COORDINATOR.requestRandomWords(s_keyHash, s_subscriptionId, requestConfirmations, callbackGasLimit, numWords);

        s_guesser[requestId] = guesser;
        s_results[guesser] = ROLL_IN_PROGRESS;
        emit GuessInitiated(requestId, guesser);
    }

    function fulfillRandomWords(uint256 requestId , uint256[] memory randomWords) internal override {
        // transform the result to a number between 1 and 20 inclusively
        uint256 d20Value = (randomWords[0] % 20) + 1;
        s_results[s_guesser[requestId]] = d20Value;
        emit GuessResult(requestId, d20Value);
    }

    function compareTwoStrings(string memory s1, string memory s2) public pure returns (bool success) {
        return keccak256(abi.encodePacked(s1)) == keccak256(abi.encodePacked(s2));
    }

    function color(address player, string memory word) public view returns (string memory f_word, string memory s_word) {
        require(s_results[player] != 0, "Address not submitted");
        require(s_results[player] != ROLL_IN_PROGRESS, "Roll in progress");

        f_word = chooseColor(s_results[player]);
        s_word = word;

        return (f_word, s_word);
    }


    function chooseColor(uint256 id) private pure returns (string memory) {
        // array storing the list of colors 
        string[20] memory colorNames = [
            "Red",
            "Blue",
            "Green",
            "Yellow",
            "Black",
            "White",
            "Magenta",
            "Indigo",
            "Cyan",
            "Violet",
            "Purple",
            "Wine",
            "Brown",
            "Cream",
            "Burgundy",
            "Orange",
            "Gold",
            "Silver",
            "Grey",
            "Peach"
        ];
        return colorNames[id];
    }

    // function mintNFT(string memory fword, string memory sword, string memory tword) public {
    //     // require(lastWavedAt[msg.sender] + 24 hours < block.timestamp, "Wait a day");
    //     // require((lastWavedAt[msg.sender] + 24 hours < block.timestamp) && (lastWavedAt[msg.sender] + 744 hours < block.timestamp), "Wait a month");
    //     if ((lastWavedAt[msg.sender] + 24 hours < block.timestamp) && (lastWavedAt[msg.sender] + 744 hours < block.timestamp)) {
    //         console.log("Hello");
    //     } else if (lastWavedAt[msg.sender] + 24 hours < block.timestamp) {
    //         console.log("World");
    //     }

    //     lastWavedAt[msg.sender] = block.timestamp;

    //     uint256 newItemId = _tokenIds.current();

    //     string memory someColor = pickRandomColor(newItemId);

    //     string memory combinedWord = string(abi.encodePacked(fword, sword, tword));

    //     string memory finalSvg = string(abi.encodePacked(svgPartOne, someColor, svgPartTwo, combinedWord, "</text></svg>"));

    //     string memory json = Base64.encode(
    //         bytes(
    //             string(
    //                 abi.encodePacked(
    //                     '{"name": "',
    //                     combinedWord,
    //                     '", "description": "A highly acclaimed collection of squares", "image": "data:image/svg+xml;base64',
    //                     Base64.encode(bytes(finalSvg)),
    //                     '"}'
    //                 )
    //             )
    //         )
    //     );

    //     string memory finalTokenUri = string(
    //         abi.encodePacked("data:application/json;base64,", json)
    //     );

    //     console.log(
    //         string(
    //             abi.encodePacked(
    //                 "https://nftpreview.0xdev.codes/?code=",
    //                 finalTokenUri
    //             )
    //         )
    //     );

    //     uint256 prizeAmount = 1 ether;

    //     bool success = compareTwoStrings(someColor, tword);
    //     if (success == true) {
    //         require(prizeAmount <= address(this).balance, "You do not have enough ether to send");
    //         msg.sender.call{value: prizeAmount}("");
    //         console.log("Finally, Lawwee did it");
    //     } else {
    //         console.log("Still proof that he did it");
    //     }

    //     _safeMint(msg.sender, newItemId);
    //     _setTokenURI(newItemId, finalTokenUri);
    //     console.log("An NFT w/ ID %s has been minted to %s:", newItemId, msg.sender);

    //     _tokenIds.increment();
    // }

    // function random(string memory input) internal pure returns (uint256) {
    //     return uint256(keccak256(abi.encodePacked(input)));
    // }

    // function randomColor(string memory input) public view returns (uint256) {
    //     uint256 rand = random(string(abi.encodePacked("Color", input)));
    //     rand = rand % colors.length;
    //     return uint256(keccak256(abi.encodePacked(rand)));
    // }

    // function pickRandomColor(uint256 tokenId) public view returns (string memory) {
    //     uint256 rando = randomColor(string(abi.encodePacked("RanDomCOloR", Strings.toString(tokenId))));
    //     uint256 rand = (block.timestamp + block.difficulty + seed + rando) % 100;
    //     rand = rand % colors.length;
    //     return colors[rand];
    // }


}