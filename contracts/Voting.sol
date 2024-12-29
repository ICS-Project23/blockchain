
// contracts/Voting.sol
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./CandidateManager.sol";

contract Voting {
    CandidateManager public candidateManager;
    mapping(address => bool) public voters;
    mapping(uint => uint) public votes;

    event Voted(address indexed voter, uint indexed candidateId);

    constructor(address _candidateManagerAddress) {
        candidateManager = CandidateManager(_candidateManagerAddress);
    }

    function vote(uint _candidateId) public {
        require(!voters[msg.sender], "You have already voted");
        require(_candidateId > 0 && _candidateId <= candidateManager.candidatesCount(), "Invalid candidate");

        voters[msg.sender] = true;
        votes[_candidateId]++;

        emit Voted(msg.sender, _candidateId);
    }

    function getCandidate(uint _candidateId) public view returns (uint, string memory, uint) {
        (uint id, string memory name) = candidateManager.getCandidate(_candidateId);
        uint voteCount = votes[_candidateId];
        return (id, name, voteCount);
    }
    function getResult() public view returns (uint, string memory, uint) {
        uint maxVotes = 0;
        uint maxVotesCandidateId = 0;
        for (uint i = 1; i <= candidateManager.candidatesCount(); i++) {
            if (votes[i] > maxVotes) {
                maxVotes = votes[i];
                maxVotesCandidateId = i;
            }
        }
        (uint id, string memory name) = candidateManager.getCandidate(maxVotesCandidateId);
        return (id, name, maxVotes);
    }
}

