
// contracts/Voting.sol
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./CandidateManager.sol";
import "./Election.sol";
import "./Candidate.sol";
contract Voting {
    Election public election;
    CandidateManager public candidateManager;
    mapping(address => mapping(uint => bool)) public voters; // Track votes per position
    mapping(uint => mapping(uint => uint)) private votes;

    event Voted(address indexed voter, uint indexed candidateId);

    constructor(address _candidateManagerAddress, address _electionAddress) {
        candidateManager = CandidateManager(_candidateManagerAddress);
        election = Election(_electionAddress);
    }

    event CandidateResultsEvent (
        uint id,
        string full_name,
        string party,
        uint vote_count
    );

    function vote(uint _candidate_id, uint256 _position_id, uint256 _election_id) public {
        require(election.isElectionActive(_election_id), "Election Not Started or Has Ended");
        require(!voters[msg.sender][_position_id], "You have already voted for this position");
        (uint id, , , , , , ) = candidateManager.getCandidate(_candidate_id, _election_id);
        require(id!=0 , "Invalid candidate");
        (uint candidate_position_id) = candidateManager.getCandidatePosition(_candidate_id);
        require(candidate_position_id == _position_id, "Candidate Not Vying for position");
        voters[msg.sender][_position_id] = true;
        votes[_position_id][_candidate_id]++;
        emit Voted(msg.sender, _candidate_id);
    }

    function getCandidatesForPosition(uint _position_id, uint256 _election_id) public view returns(Candidate[] memory){
        return candidateManager.getCandidatesForPosition(_position_id, _election_id);
    }

    function getResultsByPosition(uint _position_id, uint256 _election_id) public {
        Candidate[] memory vying_candidates = getCandidatesForPosition(_position_id, _election_id);
        for (uint i = 0; i < vying_candidates.length; i++) {
            (uint candidateId, string memory full_name, string memory party, , , , ) = candidateManager.getCandidate(vying_candidates[i].id, _position_id);
            emit CandidateResultsEvent(candidateId, full_name, party, votes[_position_id][candidateId]);
        }
    }

}