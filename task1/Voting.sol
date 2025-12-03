// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract Voting{
    mapping (string => uint) votes;
    mapping (address =>bool)  votingStatus;
    string[] candidates;
    constructor (string[] memory names){
      candidates=names;
    }
   
   function vote(string calldata name) public {
          require(!votingStatus[msg.sender],"the voter already voted");
          votes[name] ++;
          votingStatus[msg.sender] == true;
        
   }
   function getVotes (string calldata name)public  view   returns (uint) {
         return votes[name];
   }
   function resetVotes()public {
      uint len = candidates.length;
      for (uint i = 0;i < len ; i++){
        votes[candidates[i]]= 0;
      }
   }

     
}