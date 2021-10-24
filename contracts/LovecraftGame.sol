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
        uint stamina;
        uint intellect;
        uint luck;
        uint spirit;
        uint magic;
    }

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIDs;

    CharacterAttributes[] defaultCharacters;

    // Creates a mapping from an NFTs' tokenId to that NFTs' character attributes.
    mapping(uint256 => CharacterAttributes) public nftHolderAttributes;

    // Creates a mapping from an NFT holders' address to their NFT tokenId.
    mapping (address => uint256) public nftHolders;

    constructor(
        string[] memory characterNames,
        string[] memory characterImageURIs,
        string[] memory characterDescriptions,
        uint[] memory characterHp,
        uint[] memory characterAttackDmg,
        uint[] memory characterStamina,
        uint[] memory characterIntellect,
        uint[] memory characterLuck,
        uint[] memory characterSpirit,
        uint[] memory characterMagic
    ) 
        ERC721("LOVECRAFT", "LC")
    {
        for(uint i = 0; i < characterNames.length; i += 1) {
        defaultCharacters.push(CharacterAttributes({
        characterIndex: i,
        name: characterNames[i],
        imageURI: characterImageURIs[i],
        description: characterDescriptions[i],
        hp: characterHp[i],
        maxHp: characterHp[i],
        attackDamage: characterAttackDmg[i],
        stamina: characterStamina[i],
        intellect: characterIntellect[i],
        luck: characterLuck[i],
        spirit: characterSpirit[i],
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
  string memory strStamina = Strings.toString(charAttributes.stamina);
  string memory strIntellect = Strings.toString(charAttributes.intellect);
  string memory strLuck = Strings.toString(charAttributes.luck);
  string memory strSpirit = Strings.toString(charAttributes.spirit);
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
          '", "image": "',
          charAttributes.imageURI,
          '", "attributes": [ { "trait_type": "Health Points", "value": ',strHp,', "max_value":',strMaxHp,'}, { "trait_type": "Attack Damage", "value": ',
          strAttackDamage,'}, { "display_type": "boost_percentage", "trait_type": "Stamina", "value": ',strStamina,'}, { "display_type": "boost_percentage", "trait_type": "Intellect", "value": ',strIntellect,'}, { "display_type": "boost_percentage", "trait_type": "Luck", "value": ',strLuck,'}, { "display_type": "boost_percentage", "trait_type": "Spirit", "value": ',strSpirit,'}, { "display_type": "boost_percentage", "trait_type": "Magic", "value": ',strMagic,'} ]}'
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
          stamina: defaultCharacters[_characterIndex].stamina,
          intellect: defaultCharacters[_characterIndex].intellect,
          luck: defaultCharacters[_characterIndex].luck,
          spirit: defaultCharacters[_characterIndex].spirit,
          magic: defaultCharacters[_characterIndex].magic
      });

      console.log("Minted NFT w/ tokenId %s and characterIndex %s", newItemId, _characterIndex);

      // This displays NFT owners' addresses.
      nftHolders[msg.sender] = newItemId;

      _tokenIDs.increment();
  }
}