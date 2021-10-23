const main = async () => {
    const lovecraftContractFactory = await hre.ethers.getContractFactory('LovecraftGame');
    const lovecraftContract = await lovecraftContractFactory.deploy();
    await lovecraftContract.deployed();
    console.log("Contract deployed to:", lovecraftContract.address);
  };
  
  const runMain = async () => {
    try {
      await main();
      process.exit(0);
    } catch (error) {
      console.log(error);
      process.exit(1);
    }
  };
  
  runMain();