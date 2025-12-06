// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract BeggingContract {
    mapping (address=>uint) public  donations;
    address[] public donaters;
    address payable public  owner;
    uint256 deadline;
    
    constructor(uint256  duration) {
        owner = payable (msg.sender);
        deadline = block.timestamp + duration * 1 days;
    }
    modifier onlyOwner(){
        require(msg.sender == owner,"Not Owner");
        _;
    }
    modifier deadlineCheck(){
        require(block.timestamp < deadline,"deadline end");
        _;
    }

    event Donate(address donater, uint amount);
    function donate() public payable deadlineCheck{
          require(msg.value > 0,"Donation must be greatter than zero");
          donations[msg.sender] += msg.value;
          emit Donate(msg.sender, msg.value);
          for (uint i = 0 ; i < donaters.length; i++){
          if (donaters[i] == msg.sender){
               return;
          }
          }
          donaters.push(msg.sender);

    }
    function withdraw() public payable onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0 ,"Insufficent Balance");
             owner.transfer(address(this).balance); 
        //  owner.send(address(this).balance]);
        //   (bool success,) = owner.call{value:balance}("");

        //   return success;

     }
     function  getDonation(address addr) public view   returns (uint256) {
        require(addr != address(0),"Invalid Address");
        return donations[addr];
     }
     function getRank() public  view    returns (address[] memory){
        uint len = donaters.length;
        require(len > 0,"No Donater");
        address[] memory rankArr = new address[](len);
          for (uint i = 0 ; i < len; i++){
                rankArr[i] = donaters[i];
            }
        address[] memory rank = new address[](3);
         uint lenRank = rankArr.length;
        for (uint i = 0 ; i < lenRank; i++){
        for (uint j = 0 ; j < lenRank -i-1; j++){
               if (donations[rankArr[j]] < donations[rankArr[j +1]]){
                  address tem =rankArr[j];
                  rankArr[j] = rankArr[j +1];
                  rankArr[j+1]= tem;
               }
        }
        }

            if (rankArr.length <= 3){
                return rankArr;
            }else{
                 for (uint i = 0 ; i < 3; i++){
                rank[i] = rankArr[i];
            }
            }
          
 
        return  rank;
    
     }
    
}