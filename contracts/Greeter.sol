//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Greeter {
    mapping (address => uint256) public hello;
    uint cooldownTime = 1 minutes;

    struct Player {
        address player;
        uint readyTime;
    }

    Player[] public players;

    constructor() {
        console.log("Deploying a Greeter with greeting:");
    }

    function greet(address player) external {
        // require(hello[player] + 24 hours < block.timestamp, "Please wait a day");
        players.push(Player(player, uint(block.timestamp + cooldownTime)));
        uint id = players.length - 1;
        console.log("Hello there:", id);
        // triggerCooldownTime(player);
    }

    function isReady(Player storage _player) internal view returns(bool) {
        return (_player.readyTime <= block.timestamp);
    }

    function there(uint playerId) public view {
        Player storage player = players[playerId];
        require (isReady(player), "Please wait a while");
        console.log("hello there");
    }

}
