// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Election {
    struct Position {
        uint256 id;
        string name;
        string description;
    }

    struct ElectionDetails {
        string name;
        uint256 startTime;
        uint256 endTime;
        mapping(uint256 => Position) positions;
        uint256 positionsCount;
        bool isActive;
    }

    mapping(uint256 => ElectionDetails) elections;
    uint256 electionCount;
    address public admin;
    bool public electionStatus;

    event PositionAdded(
        uint256 indexed positionId,
        string name,
        string description
    );
    event ElectionCreated(string name, uint256 startTime, uint256 endTime);
    event ElectionStarted();
    event ElectionEnded();

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function createElection(
        string memory _name,
        uint256 _startTime,
        uint256 _endTime
    ) public onlyAdmin {
        require(!electionStatus, "Election has already started");
        electionCount++;
        ElectionDetails storage election = elections[electionCount]; // Use storage to modify the state variable
        election.name = _name;
        election.startTime = _startTime;
        election.endTime = _endTime;
        election.isActive = false;
        emit ElectionCreated(_name, _startTime, _endTime);
    }

    function addPosition(
        string memory _name,
        string memory _description,
        uint256 _electionId
    ) public onlyAdmin {
        require(!electionStatus, "Election has already started");
        ElectionDetails storage election = elections[_electionId];
        election.positionsCount++;
        election.positions[election.positionsCount] = Position(
            election.positionsCount,
            _name,
            _description
        );
        emit PositionAdded(election.positionsCount, _name, _description);
    }

    function getPosition(uint256 _positionId, uint256 _electionId)
        public
        view
        returns (
            uint256,
            string memory,
            string memory
        )
    {
        ElectionDetails storage election = elections[_electionId];
        Position memory position = election.positions[_positionId];
        return (position.id, position.name, position.description);
    }

    function getAllPositions(uint256 _electionId)
        public
        view
        returns (
            uint256[] memory,
            string[] memory,
            string[] memory
        )
    {
        ElectionDetails storage election = elections[_electionId];
        uint256[] memory positionIds = new uint256[](election.positionsCount);
        string[] memory positionNames = new string[](election.positionsCount);
        string[] memory positionDescriptions = new string[](
            election.positionsCount
        );

        for (uint256 i = 1; i <= election.positionsCount; i++) {
            Position storage position = election.positions[i];
            positionIds[i - 1] = position.id;
            positionNames[i - 1] = position.name;
            positionDescriptions[i - 1] = position.description;
        }
        return (positionIds, positionNames, positionDescriptions);
    }

    function getElectionDetails(uint256 _electionId)
        public
        view
        returns (
            string memory,
            uint256,
            uint256,
            uint256
        )
    {
        ElectionDetails storage election = elections[_electionId];
        return (
            election.name,
            election.startTime,
            election.endTime,
            election.positionsCount
        );
    }

    function getAllElections()
        public
        view
        returns (
            uint256[] memory,
            string[] memory,
            uint256[] memory,
            uint256[] memory
        )
    {
        uint256[] memory ids = new uint256[](electionCount);
        string[] memory names = new string[](electionCount);
        uint256[] memory startTimes = new uint256[](electionCount);
        uint256[] memory endTimes = new uint256[](electionCount);

        for (uint256 i = 1; i <= electionCount; i++) {
            ElectionDetails storage election = elections[i];
            ids[i - 1] = i;
            names[i - 1] = election.name;
            startTimes[i - 1] = election.startTime;
            endTimes[i - 1] = election.endTime;
        }

        return (ids, names, startTimes, endTimes);
    }

    function startElection(uint _election_id) public onlyAdmin {
        require(_election_id > 0 && _election_id <= electionCount, "Invalid election ID");

        ElectionDetails storage election = elections[_election_id];
        require(!election.isActive, "Election is already active");
        election.isActive = true;

        emit ElectionStarted();
    }

    function endElection(uint _election_id) public onlyAdmin {
        require(_election_id > 0 && _election_id <= electionCount, "Invalid election ID");
        ElectionDetails storage election = elections[_election_id];
        require(election.isActive, "Election is not active");
        election.isActive = false;
        emit ElectionEnded();
    }

    function isElectionActive(uint256 _election_id) public view returns (bool) {
        require(_election_id > 0 && _election_id <= electionCount, "Invalid election ID");
        ElectionDetails storage election = elections[_election_id];
        return election.isActive;
    }

}
