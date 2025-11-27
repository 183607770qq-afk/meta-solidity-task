// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract VotingSystem{
      struct Proposal {
        string description;
        uint256 voteCount;
        uint256 deadline;
        bool executed;
        mapping(address => bool) voters;
    }
    mapping(uint256 => Proposal) public proposals;
    uint256 public proposalCount;
    function createProposal(string memory description,uint256 duration)public returns (uint256){
      require(bytes(description).length > 0, "Description required");
      require(duration > 0, "Duration must be positive");
      uint256 proposalId = proposalCount ++;
      Proposal storage p= proposals[proposalId];
      p.description = description;
      p.voteCount=0;
      p.deadline=block.timestamp+duration;
      p.executed =false;
      return proposalId;
    }
    function vote(uint256 proposalId) public {
        require(proposalId < proposalCount, "Proposal does not exist");
        
        Proposal storage p = proposals[proposalId];
        
        require(block.timestamp < p.deadline, "Voting has ended");
        require(!p.voters[msg.sender], "Already voted");
        
        p.voters[msg.sender] = true;
        p.voteCount++;
    }
     function hasVoted(
        uint256 proposalId,
        address voter
    ) public view returns (bool) {
        require(proposalId < proposalCount, "Proposal does not exist");
        return proposals[proposalId].voters[voter];
    }
    function getProposalInfo(uint256 proposalId) public view returns (
        string memory description,
        uint256 voteCount,
        uint256 deadline,
        bool executed
    ) {
        require(proposalId < proposalCount, "Proposal does not exist");
        
        Proposal storage p = proposals[proposalId];
        return (p.description, p.voteCount, p.deadline, p.executed);
    }
    
    function getWinningProposal() public view returns (uint256 winningProposalId) {
        uint256 maxVotes = 0;
        
        for(uint256 i = 0; i < proposalCount; i++) {
            if(proposals[i].voteCount > maxVotes) {
                maxVotes = proposals[i].voteCount;
                winningProposalId = i;
            }
        }
        
        return winningProposalId;
    }
}