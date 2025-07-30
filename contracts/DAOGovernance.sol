// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;
import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DAOGovernance {
    IERC20 public voteToken;
    mapping(uint256 => Proposal) public proposals;
    uint256 private proposalCount;
    uint256 private votingDuration = 3 days;
    uint256 public quorum;
    uint256 private constant DEFAULT_QUORUM = 10000 * 1e18;

    constructor(address _voteToken){
        require(_voteToken != address(0), "Invalid token address");
        voteToken = IERC20(_voteToken);
    }

    struct Proposal {
        uint256 id;
        string description;
        uint256 voteCountYes;
        uint256 voteCountNo;
        uint256 deadline;
        address creator;
        bool executed;
        mapping(address => bool) hasVoted;
    }

    event ProposalCreated(uint256 id, string description, address creator, uint256 deadline);

    function createProposal(string calldata _description) external {
        proposalCount++;

        require(bytes(_description).length > 0, "Proposal description cannot be empty");
        require(bytes(_description).length <= 100, "Proposal description cannot exceed 100 characters");

        Proposal storage p = proposals[proposalCount];
        p.id = proposalCount;
        p.description = _description;
        p.deadline = block.timestamp + votingDuration;
        p.creator = msg.sender;
        p.executed = false;

        emit ProposalCreated(proposalCount, _description, msg.sender, block.timestamp + votingDuration);
    }

    function vote(uint256 _proposalId, bool _voteYes) external {
        Proposal storage proposal = proposals[_proposalId];
        require(proposal.id != 0, "Proposal does not exist");
        require(block.timestamp < proposal.deadline, "Voting period has ended");
        require(!proposal.executed, "Proposal has already been executed");
        require(!proposal.hasVoted[msg.sender], "Already voted");

        uint256 balance = voteToken.balanceOf(msg.sender);
        require(balance > 0, "You must hold tokens to vote");
           
        if (_voteYes) {
            proposal.voteCountYes++;
        } else {
            proposal.voteCountNo++;
        }

        proposal.hasVoted[msg.sender] = true;
    }

    function quorumReached(uint256 _id) public view returns (bool) {
        Proposal storage p = proposals[_id];
        return (p.voteCountYes + p.voteCountNo) >= quorum;
    }

    function executeProposal(uint256 _id) external {
        Proposal storage p = proposals[_id];
        require(block.timestamp >= p.deadline, "Voting still active");
        require(!p.executed, "Already executed");
        require(quorumReached(_id), "Quorum not reached");
        require(p.voteCountYes > p.voteCountNo, "Proposal did not pass");

        // Add real execution logic here (e.g., send tokens or call contract)
        p.executed = true;
    }

    function GetProposalResults(uint256 _proposalId) external view returns (
            string memory description,
            uint256 voteCountYes,
            uint256 voteCountNo,
            address creator,
            bool executed)
    {
        Proposal storage proposal = proposals[_proposalId];
        require(block.timestamp >= proposal.deadline, "Voting period is still active");
        require( block.timestamp >= proposal.deadline, "Voting period is still active");

        description = proposal.description;
        voteCountYes = proposal.voteCountYes;
        voteCountNo = proposal.voteCountNo;
        creator = proposal.creator;
        executed = proposal.executed;
    }
}
