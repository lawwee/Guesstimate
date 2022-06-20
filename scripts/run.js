const main = async () => {
    const [ owner, randomuser] = await hre.ethers.getSigners()
    const gameContractFactory = await hre.ethers.getContractFactory("GameNFT");
    const gameContract = await gameContractFactory.deploy({
        value: hre.ethers.utils.parseEther("10"),
    });
    await gameContract.deployed();

    console.log("Contract has been deployed to:", gameContract.address); 

    let contractBalance = await hre.ethers.provider.getBalance(gameContract.address)
    console.log("Contract's address before is:", hre.ethers.utils.formatEther(contractBalance));

    let randomBalance = await hre.ethers.provider.getBalance(randomuser.address);
    console.log("Owner's address before txn is:", hre.ethers.utils.formatEther(randomBalance));

    let txn = await gameContract.connect(randomuser).mintNFT("hello", "lawwee", "green");
    await txn.wait();

    randomBalance = await hre.ethers.provider.getBalance(randomuser.address);
    console.log("Owner's address after txn is:", hre.ethers.utils.formatEther(randomBalance));

    contractBalance = await hre.ethers.provider.getBalance(gameContract.address)
    console.log("Contract's address after is:", hre.ethers.utils.formatEther(contractBalance));

    txn = await gameContract.connect(randomuser).mintNFT("hello", "lawwee", "red");
    await txn.wait();

    randomBalance = await hre.ethers.provider.getBalance(randomuser.address);
    console.log("Owner's address after txn is:", hre.ethers.utils.formatEther(randomBalance));

    contractBalance = await hre.ethers.provider.getBalance(gameContract.address)
    console.log("Contract's address after is:", hre.ethers.utils.formatEther(contractBalance));

}

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1)
    }
}

runMain();