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
      ["QmSGjKj29HFstZKhFpNM5Sg8uZ4qmJTTsZ7D4jK1XnwZyF",
       "QmS3tRbAyvcmb9Jkt328xwYDDW257E9ftzYYwXEXQmjQiD",
       "QmcxTemwY8JtHb9oxC72LwyjGxcrmH2pWMkc8593TaBjm9",
       "QmSyb8qbhGeHGzZAvftPifXbDA4DHgn6nRS95YpneHG9aK",
       "QmQujCnEVo6ho2CtrkHkXU4yW2iyNJyheSLQxgeNxqQgfH",
       "Qme6UYuxPecah4oUNgvGMveKraAHsRjpQd4Mq1fj7ie6fz",
       "QmWCR14qRxQMeBm6bykPJScGPxuwRdH7CSTgdamJrNF1wi"
      ],

    // Character Descriptions
      ["Atticus is a Korean war vet who loves pulp novels. Disciplined, observant, and adventurous, his secret family legacy is a magical bloodline.",
       "Montrose is a confrontational, abravisive drunk with a lot of secrets. He's the father of Atticus Freeman.",
       "Hippolyta is an astronomer and writer. She holds the key to a time travel portal. She is the wife of George Freeman.",
       "Ruby is a singer. Determined and ambitious, she has a strong personality. Her sharp tongue earns a magical potion with the ability to change her skin color.",
       "Diana is a sci-fi loving comic artist. She is the daughter of Hippolyta and George Freeman. A curse led to her now robotic arm.",
       "George is well-read, loves pulp novels, and dangerously takes on adventures to help his community. He is the husband of Hippolyta Freeman.",
       "Letitia is a photographer and activist. Driven and unafraid of danger, she is a formidable weilder of magic."
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

    // Character Intellect
      ["80",
       "70",
       "60",
       "55",
       "45",
       "75",
       "65"
      ],

    // Character Magic
      ["100",
       "30",
       "100",
       "100",
       "20",
       "20",
       "70"
      ],

    // Shoggoth Name
      "Shoggoth",

    // Shoggoth Image
      "QmZGqHLzwMCCx82qngkWm8gKpcg4M7eT3z3AFBh9UuTrNv",

    // Shoggoth Health Points
      "8000",

    // Shoggoth Attack Damage
      "75"

    );
    
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