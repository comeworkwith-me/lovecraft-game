// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;


import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./libraries/Base64.sol";

import "hardhat/console.sol";

contract LovecraftGame is ERC721, Ownable {

    struct CharacterAttributes {
        uint characterIndex;
        string name;
        string imageURI;
        string description;
        uint hp;
        uint maxHp;
        uint attackDamage;
        uint intellect;
        uint magic;
    }

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIDs;

    CharacterAttributes[] defaultCharacters;

    // Creates a mapping from an NFTs' tokenId to that NFTs' character attributes.
    mapping(uint256 => CharacterAttributes) public nftHolderAttributes;

    // An event to notify the user/player that the NFT has been minted.
    event CharacterMinted(address sender, uint256 tokenId, uint256 characterIndex);

    // An event to notify the user/player that the Shoggoth has been attacked.
    event AttackComplete(uint newShoggothHp, uint newPlayerHp);

    struct Shoggoth {
      string name;
      string imageURI;
      uint hp;
      uint maxHp;
      uint attackDamage;
    }

    Shoggoth public shoggoth;

    // Creates a mapping from an NFT holders' address to their NFT tokenId.
    mapping (address => uint256) public nftHolders;

    constructor(
        string[] memory characterNames,
        string[] memory characterImageURIs,
        string[] memory characterDescriptions,
        uint[] memory characterHp,
        uint[] memory characterAttackDmg,
        uint[] memory characterIntellect,
        uint[] memory characterMagic,
        string memory shoggothName,
        string memory shoggothImageURI,
        uint shoggothHp,
        uint shoggothAttackDamage
    ) 
        ERC721("LOVECRAFT", "LC")
    {
        shoggoth = Shoggoth({
          name: shoggothName,
          imageURI: shoggothImageURI,
          hp: shoggothHp,
          maxHp: shoggothHp,
          attackDamage: shoggothAttackDamage
        });

        console.log("Done initializing %s w/ HP %s, img %s", shoggoth.name, shoggoth.hp, shoggoth.imageURI);

        for(uint i = 0; i < characterNames.length; i += 1) {
        defaultCharacters.push(CharacterAttributes({
        characterIndex: i,
        name: characterNames[i],
        imageURI: characterImageURIs[i],
        description: characterDescriptions[i],
        hp: characterHp[i],
        maxHp: characterHp[i],
        attackDamage: characterAttackDmg[i],
        intellect: characterIntellect[i],
        magic: characterMagic[i]
      }));

        CharacterAttributes memory c = defaultCharacters[i];
        console.log("Done initializing %s w/ HP %s, img %s", c.name, c.hp, c.imageURI);
    }

        _tokenIDs.increment();
  }

  function tokenURI(uint256 _tokenId) public view override returns (string memory) {
  CharacterAttributes memory charAttributes = nftHolderAttributes[_tokenId];

  string memory strHp = Strings.toString(charAttributes.hp);
  string memory strMaxHp = Strings.toString(charAttributes.maxHp);
  string memory strAttackDamage = Strings.toString(charAttributes.attackDamage);
  string memory strIntellect = Strings.toString(charAttributes.intellect);
  string memory strMagic = Strings.toString(charAttributes.magic);

  string memory json = Base64.encode(
    bytes(
      string(
        abi.encodePacked(
          '{"name": "',
          charAttributes.name,
          ' -- NFT #: ',
          Strings.toString(_tokenId),
          '", "description": "',
          charAttributes.description, 
          '", "image": "ipfs://',
          charAttributes.imageURI,
          '", "attributes": [ { "trait_type": "Health Points", "value": ',strHp,', "max_value":',strMaxHp,'}, { "trait_type": "Attack Damage", "value": ',
          strAttackDamage,'}, { "display_type": "boost_percentage", "trait_type": "Intellect", "value": ',strIntellect,'}, { "display_type": "boost_percentage", "trait_type": "Magic", "value": ',strMagic,'} ]}'
        )
      )
    )
  );

  string memory output = string(
    abi.encodePacked("data:application/json;base64,", json)
  );
  
  return output;
}
  
  // This is the user function to mint character NFTs based on character selection.
  function mintCharacter(uint _characterIndex) external {
      uint256 newItemId = _tokenIDs.current();

      // This assigns the tokenIDs to the user's address.
      _safeMint(msg.sender, newItemId);

      // Creates a mapping from a users' NFT tokenId to that NFTs character attributes.
      nftHolderAttributes[newItemId] = CharacterAttributes({
          characterIndex: _characterIndex,
          name: defaultCharacters[_characterIndex].name,
          imageURI: defaultCharacters[_characterIndex].imageURI,
          description: defaultCharacters[_characterIndex].description,
          hp: defaultCharacters[_characterIndex].hp,
          maxHp: defaultCharacters[_characterIndex].maxHp,
          attackDamage: defaultCharacters[_characterIndex].attackDamage,
          intellect: defaultCharacters[_characterIndex].intellect,
          magic: defaultCharacters[_characterIndex].magic
      });

      console.log("Minted NFT w/ tokenId %s and characterIndex %s", newItemId, _characterIndex);

      // This displays NFT owners' addresses.
      nftHolders[msg.sender] = newItemId;

      _tokenIDs.increment();

      // This "fires" off the CharacterMinted event.
      emit CharacterMinted(msg.sender, newItemId, _characterIndex);
  }

  function attackShoggoth() public {
    uint256 nftTokenIdOfPlayer = nftHolders[msg.sender];
    CharacterAttributes storage player = nftHolderAttributes[nftTokenIdOfPlayer];
    console.log("\nPlayer w/ character %s about to attack. Has %s HP and %s AD", player.name, player.hp, player.attackDamage);
    console.log(" %s has %s HP and %s AD", shoggoth.name, shoggoth.hp, shoggoth.attackDamage);

    require (
      player.hp > 0,
      "Error: Your character must have health points to attack the Shoggoth."
    );

    require (
      shoggoth.hp > 0,
      "Error: The Shoggoth is dead."
    );

    if (shoggoth.hp < player.attackDamage) {
      shoggoth.hp = 0;
    } else {
      shoggoth.hp = shoggoth.hp - player.attackDamage;
    }

    if (player.hp < shoggoth.attackDamage) {
      player.hp = 0;
    } else {
      player.hp = player.hp - shoggoth.attackDamage;
    }

    // This "fires" the AttackComplete event and returns the Shoggoths' and Players'/Users' health points.
    emit AttackComplete(shoggoth.hp, player.hp);
  }

  // This function checks if the players/users have a character.
  function checkUserNFT() public view returns (CharacterAttributes memory) {
    uint256 userNftTokenId = nftHolders[msg.sender];
    if (userNftTokenId > 0) {
    return nftHolderAttributes[userNftTokenId];
  } else {
    CharacterAttributes memory emptyStruct;
    return emptyStruct;
   }
  }

  // This function is for the web app's "character select" screen.
  function getAllCharacters() public view returns (CharacterAttributes[] memory) {
  return defaultCharacters;
  }

  // This function is for the web app's "arena" screen.
  function getShoggoth() public view returns (Shoggoth memory) {
  return shoggoth;
}

}