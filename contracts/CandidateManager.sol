// SPDX-License-Identifier: UNLICENSED
/*
    * @dev This contract manages the candidates for the voting system.
*/
pragma solidity ^0.8.0;
import "./Election.sol";
import "./Candidate.sol";

contract CandidateManager {

    struct Position {
        string name;
        string description;
    }

    mapping(uint => Candidate) private global_candidates;
    uint private candidatesCount;
    address private admin;
    Election private _election;


    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    constructor(address _electionAddress) {
        admin = msg.sender;
        _election = Election(_electionAddress);
    }


    event CandidateAdded(uint indexed candidateId, string name);
    function getCandidateCount() public view returns(uint){
        return candidatesCount;
    }
    function addCandidate(string memory _full_name, string memory _date_of_birth, string memory _cid, string memory _party, uint256 _position_id, uint256 _election_id) public onlyAdmin {
        candidatesCount++;
        global_candidates[candidatesCount] = Candidate(candidatesCount, _full_name, _date_of_birth, _cid, _party, _position_id, _election_id);
        emit CandidateAdded(candidatesCount, _full_name);
    }

    function getCandidate(uint _candidate_id, uint256 _election_id) public view returns (uint, string memory, string memory, string memory, string memory, string memory, string memory) {
        Candidate memory candidate = global_candidates[_candidate_id];
        if(candidate.election_id != _election_id){
            return (0, "", "", "", "", "", "");
        }
        (, string memory position_name, string memory position_description) = _election.getPosition(candidate.position_id, _election_id);
        return (candidate.id, candidate.full_names, candidate.party, candidate.cid, candidate.date_of_birth, position_name, position_description);
    }
    function getCandidatePosition(uint _candidate_id) public view returns (uint){
        Candidate memory candidate = global_candidates[_candidate_id];
        return candidate.position_id;
    }
    function getAllCandidates(uint _election_id) public view returns (Candidate[] memory) {
        uint index = 0;
        Candidate[] memory _candidates = new Candidate[](candidatesCount);
        for (uint i = 0; i < candidatesCount; i++) {
            if(global_candidates[i].election_id == _election_id){
                _candidates[index] = global_candidates[i]; 
                index++;
            }
        }
        return _candidates;
    }
    function getCandidatesCountByPosition(uint _position_id, uint256 _election_id) public view returns (uint){
        uint counter = 0;
        for (uint i = 0; i < candidatesCount; i++){
            Candidate memory c = global_candidates[i+1];
            if(c.position_id == _position_id && c.election_id == _election_id){
                counter ++;
            }
        }
        return counter;
    }
    function getCandidatesForPosition(uint256 _position__id, uint256 _election_id) public view returns (Candidate[] memory){
        Candidate[] memory _candidates = new Candidate[](candidatesCount);
        uint counter = 0;
        for(uint i = 0; i < candidatesCount; i++){
            Candidate memory c = global_candidates[i+1];
            if(c.position_id == _position__id && c.election_id == _election_id){
                _candidates[counter] = c;
                counter++;
            }
        }
        return _candidates;
    }
}