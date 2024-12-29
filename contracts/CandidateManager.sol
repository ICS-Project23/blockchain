// contracts/Candidate.sol
// SPDX-License-Identifier: UNLICENSED

/*
    * @dev This contract manages the candidates for the voting system.
*/
pragma solidity ^0.8.0;

contract CandidateManager {
    struct Candidate {
        uint id;
        string name;
    }

    mapping(uint => Candidate) public candidates;
    uint public candidatesCount;

    event CandidateAdded(uint indexed candidateId, string name);

    function addCandidate(string memory _name) public {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name);
        emit CandidateAdded(candidatesCount, _name);
    }

    function getCandidate(uint _candidateId) public view returns (uint, string memory) {
        Candidate memory candidate = candidates[_candidateId];
        return (candidate.id, candidate.name);
    }
    function getAllCandidates() public view returns (Candidate[] memory) {
        Candidate[] memory _candidates = new Candidate[](candidatesCount);
        for (uint i = 1; i <= candidatesCount; i++) {
            _candidates[i - 1] = candidates[i];
        }
        return _candidates;
    }
}