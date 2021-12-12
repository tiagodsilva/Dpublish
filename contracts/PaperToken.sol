// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PaperToken is ERC721, ERC721URIStorage, Ownable {
    constructor() ERC721("PaperToken", "PTK") {}
	
    string[] public manuscripts; 
    mapping (string => bool) isSubmitted; 
    mapping (uint => address) submittedManuscripts; 

    function _baseURI() internal pure override returns (string memory) {
        return "https://dpublish.org";
    }

    function safeMint(address to, uint256 tokenId) public onlyOwner {
        _safeMint(to, tokenId);
    }

    function mint(string memory idmanuscript) public {
	require(!isSubmitted[idmanuscript], 
		"Manuscript already submitted! Wait for a review."); 

	manuscripts.push(idmanuscript); 
	uint _id = manuscripts.length; 
	isSubmitted[idmanuscript] = true; 
	submittedManuscripts[_id] = msg.sender; 
	_mint(msg.sender, _id); 
    } 

    // The user can get a refund for extracting the paper 
	
    function burn(string memory idmanuscript) public {
	    require(isSubmitted[idmanuscript], 
		    "You must burn a manuscript that exists!"); 
	
    } 
    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
}
