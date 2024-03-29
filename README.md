# Guesstimate

Technologies Used:
 * Solidity
 * Javascript
 * Hardhat
 * Remix IDE
 * Chainlink
 * Alchemy
 * Metamask

Guesstimate is a play to earn (P2E) guessing based Blockchain game platform.

The address of the Smart Contract is **0x383f329a27a9B491652Ff427b81Dfe2AF288Ad91** and can be found on the Goerli Testnet of the Ethereum network.

The main functionality of the platform is to allow users guess colors of their choice and earn ether(ETH) if guessed correctly. The game requires an amount of stake in ether(ETH) per guess to successfully operate, if guessed correctly, selected users win a certain amount and also get to receive a newly minted NFT as well, if not, the stake is lost and they are required to wait a period of time before guessing again. The Contract uses the Chainlink Oracle in determining its randomness, hence making it more secure. It also uses certain NFT imports from the [Openzeppelin](https://www.openzeppelin.com/) contract library.

Herein lies the functionalities available to all users on the platform.
  
  **There are certain technical terms that cannot be explained on here, please refer to [Chainlink Documentation](https://docs.chain.link/) for better understanding of them**
  
  * The **GuessPrice** for each guess has been set to _0.001 ether(ETH)_
    
  * The **GuessInitiated** Event - This event is triggered when a new player has chosen a color and guessed it against the contract. The details on each trigger are the _requestId_ and _guesser_. The "requestId" is the ID generated for each time the player guesses a color, making the Chainlink Oracle request an offchain request. The "guesser" is the address of the player who made the guess.
    
  * The **GuessResult** Event - This is triggered when the request made by the oracle has returned a given value or result. It shows off two parameters namely _requestId_ and _result_. The "requestId" is the ID generated to track each guess made (see GuessInitiated). The "result" represents the random number that has been introduced by the Chainlink Oracle.
    
  * The **guessColor()** Function - This is called when a player wants to guess a color, the function submits the player's name and readies it for guessing. It takes in one parameter in the form of _name_ which is a representation of the player's address. It has checks in place that prevents a player from guessing more than once a day, prevents any player who guessed correctly from guessing until after a One-month period from winning and also prevents the function from executing if the **GuessPrice** is not met.

  * The **color()** Function - This is where the actual guessing takes place. It takes in two parameters namely _name_ and _word_. The "name" represents the Player's name which should have been previously submitted, the "word" represents the color each Player wants to guess. It takes in the color guessed and compares against that of the Contract. There are checks in place that stops a Player whose address has not been submitted beforehand, and also has a little waiting time for the comparism to be made.

  * The **claimPrize()** Function - the function is to be called when a Player successfully guesses the right color, herein receiving ether(ETH) as a reward and a newlt minted NFT. It has security checks in place that stops a Player who has not guessed correctly, and also stops the transaction if there is not enough ether(ETH) in the Contract's balance.
