require("dotenv").config();

const main = async () => {
    const [deployer] = await hre.ethers.getSigners();
    const subId = process.env.SUBSCRIPTION_ID;

    console.log("Contract has been deployed by:", deployer.address);

    const guessContractFactory = await hre.ethers.getContractFactory("GameNFT");
    const guessContract = await guessContractFactory.deploy(subId);
    await guessContract.deployed();

    console.log("Current Contract address is:", guessContract.address);
    // 0x383f329a27a9B491652Ff427b81Dfe2AF288Ad91
};

const runMain = async () => {
    try {
      await main();
      process.exit(0); // exit Node process without error
    } catch (error) {
      console.log(error);
      process.exit(1); // exit Node process while indicating 'Uncaught Fatal Exception' error
    }
    // Read more about Node exit ('process.exit(num)') status codes here: https://stackoverflow.com/a/47163396/7974948
  };
  
runMain();    