// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract VotingSystem{
    enum  Vote{Yes,No,Abstain}
     mapping (address => Vote)  public  votes;
     mapping (address => bool)  public  hasVoted;
    uint public  yesCount;
    uint public  noCount;
    uint public  abstainCount;
    function vote(Vote _vote) public {
        if (!hasVoted[msg.sender]){
        
              votes[msg.sender] = _vote;
              hasVoted[msg.sender] = true;
              if (Vote.Yes == _vote){
                yesCount++;
              }
                 if (Vote.No == _vote){
                noCount++;
              }
                 if (Vote.Abstain == _vote){
                abstainCount++;
              }
        }
    }
    function getMyVote() public  view  returns (Vote){
        require(hasVoted[msg.sender],"You haven't voted");
        return votes[msg.sender];
    }
}