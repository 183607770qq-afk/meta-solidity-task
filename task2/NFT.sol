// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
contract NFT is Ownable,ERC721URIStorage{
    uint256 private _nextTokenId;
    uint256 private constant MAX_SUPPLY =10000;
    constructor(string memory  name,string memory symbol) ERC721(name,symbol) Ownable(msg.sender){}
    function mintNFT(address to ,string memory tokenURI)public onlyOwner  returns (uint256){
        require(_nextTokenId < MAX_SUPPLY , "MAX_SUPPLY reached");
        uint tokenId = _nextTokenId;
        _nextTokenId ++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId,tokenURI);
        return tokenId;
    }
    function totolSupply() public  view returns (uint256){
        return _nextTokenId;
    }

}