// SPDX-License-Identifier: UNLICENSED
/*
    * @dev This contract manages the candidates for the voting system.
*/
pragma solidity ^0.8.0;
import "./Election.sol";

contract CandidateManager {
    struct Candidate {
        uint id;
        string full_names;
        string date_of_birth;
        string cid; // used to store an image of the candidate
        string party;
        uint256 position_id;
    }

    struct Position {
        string name;
        string description;
    }

    mapping(uint => Candidate) private global_candidates;
    uint private candidatesCount;
    address private admin;
    // address public election_address;
    Election private _election;


    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    constructor(address _electionAddress) {
        admin = msg.sender;
        _election = Election(_electionAddress);
        // election_address = address(_electionAddress);
    }


    event CandidateAdded(uint indexed candidateId, string name);
    function getCandidateCount() public view returns(uint){
        return candidatesCount;
    }
    function addCandidate(string memory _full_name, string memory _date_of_birth, string memory _cid, string memory _party, uint256 _position_id) public onlyAdmin {
        candidatesCount++;
        global_candidates[candidatesCount] = Candidate(candidatesCount, _full_name, _date_of_birth, _cid, _party, _position_id);
        emit CandidateAdded(candidatesCount, _full_name);
    }

    function getCandidate(uint _candidate_id, uint256 _election_id) public view returns (uint, string memory, string memory, string memory, string memory, string memory, string memory) {
        Candidate memory candidate = global_candidates[_candidate_id];
        (, string memory position_name, string memory position_description) = _election.getPosition(candidate.position_id, _election_id);
        return (candidate.id, candidate.full_names, candidate.party, candidate.cid, candidate.date_of_birth, position_name, position_description);
    }
    function getCandidatePosition(uint _candidate_id) public view returns (uint){
        Candidate memory candidate = global_candidates[_candidate_id];
        return candidate.position_id;
    }
    function getAllCandidates() public view returns (Candidate[] memory) {
        Candidate[] memory _candidates = new Candidate[](candidatesCount);
        for (uint i = 0; i < candidatesCount; i++) { // changed from <= to <
            _candidates[i] = global_candidates[i + 1]; // adjust the index since Solidity uses zero-indexing
        }
        return _candidates;
    }
    function getCandidatesCountByPosition(uint _position_id) public view returns (uint){
        uint counter = 0;
        for (uint i = 0; i < candidatesCount; i++){
            Candidate memory c = global_candidates[i+1];
            if(c.position_id == _position_id){
                counter ++;
            }
        }
        return counter;
    }
    function getCandidatesForPosition(uint256 _position__id) public view returns (Candidate[] memory){
        Candidate[] memory _candidates = new Candidate[](candidatesCount);
        uint counter = 0;
        for(uint i = 0; i < candidatesCount; i++){
            Candidate memory c = global_candidates[i+1];
            if(c.position_id == _position__id){
                _candidates[counter] = c;
                counter++;
            }
        }
        return _candidates;
    }
}