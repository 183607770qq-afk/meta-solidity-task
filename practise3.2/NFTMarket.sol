// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract NFTmarket{
    struct NFT{
        uint256 id;
        address owner;
        uint price;
        bool forSale;
    }
    uint256 idIncrementCount=0;
    mapping(uint256 => NFT) nfts;
    uint256[] public  onSaleList;
    uint256[] public  NFTList;
    event NFTCreated(uint256 indexed  id, address owner);
    event NFTListed(uint indexed id ,uint price);
    event NFTDowned(uint indexed id);
    event NFTSaled(uint256 id,address to,address from,uint256 price);
    function createNFT() public  returns (uint){
      uint256  id = idIncrementCount;
          nfts[id] = NFT({
            id:id,
            owner:msg.sender,
            price:0,
            forSale:false
          });
          NFTList.push(id);
          idIncrementCount++;
      return id;
    }
    function listNFT(uint256 _id,uint256 _price) public returns (bool){
        require(nfts[_id].owner == msg.sender, "Not the owner");
        require( nfts[_id].forSale==false ,"The NFT is already on sale");
        require(_price>0,"price must Greater than 0"); 
        nfts[_id].price = _price;
        nfts[_id].forSale = true;
        onSaleList.push(_id);
        emit NFTDowned(_id);
        return  nfts[_id].forSale ;
    }
    function  downNFT(uint256 _id) public  returns (bool){
        require(nfts[_id].owner == msg.sender, "Not the owner");
        require( nfts[_id].forSale=true ,"The NFT is already out of sale");
        nfts[_id].price = 0;
        nfts[_id].forSale=false;
                removeNFTOnSale(_id);

        emit NFTDowned(_id);
        return nfts[_id].forSale;
    }
    function buyNTF(uint256 _id) public payable  {
        NFT storage nft = nfts[_id];
           // 验证条件
        require(nft.owner != address(0), "NFT does not exist");
        require(nft.forSale, "NFT is not for sale");
        require(msg.sender != nft.owner, "Cannot buy your own NFT");
        require(msg.value == nft.price, "Incorrect payment amount");
        require(msg.value > 0, "Payment required");
        nft.owner = msg.sender;
        nft.price = 0;
        nft.forSale = false;
                removeNFTOnSale(nft.id);
        removeNFT(nft.id);
        payable(nft.owner).transfer(msg.value);
        emit NFTSaled(_id, msg.sender, nft.owner, nft.price);


    }
    function selectNFTsOnsale() public  view returns (uint[] memory){
        return onSaleList;
    }
    function getNTFs() public  view  returns (uint[] memory){
        return NFTList;
    }
    function removeNFTOnSale(uint _id) private {
        uint len =onSaleList.length;
        for (uint i = 0;i<len;i++){
             uint  nftId =onSaleList[i];
             if (nftId == _id){
                onSaleList[i] = onSaleList[len-1];
                onSaleList.pop();
                break ;
             }

        }
    }
      function removeNFT(uint _id) private {
        uint len =NFTList.length;
        for (uint i = 0;i<len;i++){
             uint  nftId =NFTList[i];
             if (nftId == _id){
                NFTList[i] = NFTList[len-1];
                NFTList.pop();
                break ;
             }

        }
    }
}