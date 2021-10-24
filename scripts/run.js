const main = async () => {
    const lovecraftContractFactory = await hre.ethers.getContractFactory('LovecraftGame');
    const lovecraftContract = await lovecraftContractFactory.deploy(

    // Character Names
      ["ATTICUS FREEMAN",
      "MONTROSE FREEMAN",
      "HIPPOLYTA FREEMAN",
      "RUBY BAPTISTE",
      "DIANA FREEMAN",
      "GEORGE FREEMAN",
      "LETITIA LEWIS"
      ],

    // Character Images
      ["ipfs://QmZCvzf9ZeUesqdYs2NeeF3mkvTaavtbBzwhZbjwfKMsro/atticus.gif",
       "ipfs://QmZCvzf9ZeUesqdYs2NeeF3mkvTaavtbBzwhZbjwfKMsro/montrose.gif",
       "ipfs://QmZCvzf9ZeUesqdYs2NeeF3mkvTaavtbBzwhZbjwfKMsro/hippolyta.gif",
       "ipfs://QmZCvzf9ZeUesqdYs2NeeF3mkvTaavtbBzwhZbjwfKMsro/ruby.gif",
       "ipfs://QmZCvzf9ZeUesqdYs2NeeF3mkvTaavtbBzwhZbjwfKMsro/diana.gif",
       "ipfs://QmZCvzf9ZeUesqdYs2NeeF3mkvTaavtbBzwhZbjwfKMsro/george.gif",
       "ipfs://QmZCvzf9ZeUesqdYs2NeeF3mkvTaavtbBzwhZbjwfKMsro/letitia.gif"
      ],

    // Character Descriptions
      ["Atticus is a Korean war vet who loves pulp novels and has a magical bloodline.",
       "Montrose recently went missing. He has a lot of secrets.",
       "Hippolyta is an astronomer who can time travel with magic.",
       "Ruby is a singer and retail manager that can change her skin color with magic.",
       "Diana is a sci-fi loving comic artist that was cursed and now has a robotic arm.",
       "George is well-read, loves pulp novels, and dangerously takes on adventures.",
       "Letitia is a photographer and a formidable weilder of magic."
      ],

    // Character Health Points
      ["600",
       "400",
       "400",
       "400",
       "300",
       "350",
       "500"
      ],

    // Character Attack Damage
      ["300",
       "200",
       "200",
       "200",
       "150",
       "175",
       "250"
      ],

    // Character Stamina
      ["50",
       "100",
       "20",
       "35",
       "15",
       "40",
       "70"
      ],

    // Character Intellect
      ["80",
       "70",
       "60",
       "55",
       "45",
       "75",
       "65"
      ],

    // Character Luck
      ["10",
       "15",
       "30",
       "50",
       "70",
       "10",
       "40"
      ],

    // Character Spirit
      ["30",
       "40",
       "45",
       "50",
       "65",
       "20",
       "70"
      ],

    // Character Magic
      ["100",
       "30",
       "100",
       "100",
       "20",
       "20",
       "70"
      ]
    );
    
    await lovecraftContract.deployed();
    console.log("Contract deployed to:", lovecraftContract.address);

    let txn;
    txn = await lovecraftContract.mintCharacter(2);
    await txn.wait();


    // This will get the value of the NFTs URI.
    let returnedTokenUri = await lovecraftContract.tokenURI(1);
    console.log("Token URI:", returnedTokenUri);

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