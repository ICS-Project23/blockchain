
// contracts/Voting.sol
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./CandidateManager.sol";
import "./Election.sol";

contract Voting {
    Election public election;
    CandidateManager public candidateManager;
    mapping(address => bool) public voters;
    mapping(uint => mapping(uint => uint)) private votes;

    event Voted(address indexed voter, uint indexed candidateId);

    constructor(address _candidateManagerAddress, address _electionAddress) {
        candidateManager = CandidateManager(_candidateManagerAddress);
        election = Election(_electionAddress);
    }

    struct CandidateResult {
        uint id;
        string full_name;
        string party;
        uint vote_count;
    }

    function vote(uint _candidate_id, uint256 _position_id, uint256 _election_id) public {
        (bool status) = election.isElectionActive();
        require(!status, "Election Not Started or Has Ended");
        require(!voters[msg.sender], "You have already voted");
        (uint id, , , , , , ) = candidateManager.getCandidate(_candidate_id, _election_id);
        require(id!=0 , "Invalid candidate");
        (uint candidate_position_id) = candidateManager.getCandidatePosition(_candidate_id);
        require(candidate_position_id == _position_id, "Candidate Not Vying for position");
        voters[msg.sender] = true;
        votes[_position_id][_candidate_id]++;

        emit Voted(msg.sender, _candidate_id);
    }
    function getResultsByPosition(uint _position_id) public view returns (CandidateResult[] memory) {
        uint candidateCount = candidateManager.getCandidatesCountByPosition(_position_id);
        CandidateResult[] memory _candidate_results = new CandidateResult[](candidateCount);

        for (uint i = 0; i < candidateCount; i++) {
            (uint candidateId, string memory full_name , string memory party , , , , ) = candidateManager.getCandidate(i, _position_id);
            _candidate_results[i] = CandidateResult({
                id: candidateId,
                full_name: full_name,
                party: party,
                vote_count: votes[_position_id][candidateId]
            });
        }

        return _candidate_results;
    }
    
}