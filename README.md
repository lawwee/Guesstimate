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

The address of the Smart Contract is 0xE48431765402fD1d27C650f2592FA3D23F9574fA and can be found on the Goerli Testnet of the Ethereum network.

The main functionality of the platform is to allow users guess colors of their choice and earn ether(ETH) if guessed correctly. The game requires an amount of stake in ether(ETH) per guess to successfully operate, if guessed correctly, selected users win a certain amount and also get to receive a newly minted NFT as well, if not, the stake is lost and they are required to wait a period of time before guessing again. The Contract uses the Chainlink Oracle in determining its randomness, hence making it more secure. It also uses certain NFT imports from the [Openzeppelin](https://www.openzeppelin.com/) contract library.

Herein lies the functionalities available to all users on the platform.
  
  **There are certain tecnical terms that cannot be explained on here, please refer to [Chainlink Documentation](https://docs.chain.link/) for better understanding of them**
