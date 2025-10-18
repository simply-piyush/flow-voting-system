// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title VotingSystem
 * @dev A simple decentralized voting system where users can vote for proposals.
 * Built for Flow EVM Testnet.
 */
contract VotingSystem {
    struct Proposal {
        string name;
        uint voteCount;
    }

    mapping(address => bool) public hasVoted;
    Proposal[] public proposals;
    address public owner;
    bool public votingOpen;

    constructor(string[] memory proposalNames) {
        owner = msg.sender;
        for (uint i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({name: proposalNames[i], voteCount: 0}));
        }
        votingOpen = true;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    modifier isVotingOpen() {
        require(votingOpen, "Voting is closed");
        _;
    }

    function vote(uint proposalIndex) external isVotingOpen {
        require(!hasVoted[msg.sender], "You already voted");
        require(proposalIndex < proposals.length, "Invalid proposal");

        hasVoted[msg.sender] = true;
        proposals[proposalIndex].voteCount += 1;
    }

    function endVoting() external onlyOwner {
        votingOpen = false;
    }

    function getWinningProposal() external view returns (string memory winnerName, uint votes) {
        require(!votingOpen, "Voting still open");
        uint winningVoteCount = 0;
        uint winningIndex = 0;
        for (uint i = 0; i < proposals.length; i++) {
            if (proposals[i].voteCount > winningVoteCount) {
                winningVoteCount = proposals[i].voteCount;
                winningIndex = i;
            }
        }
        return (proposals[winningIndex].name, proposals[winningIndex].voteCount);
    }

    function getProposals() external view returns (Proposal[] memory) {
        return proposals;
    }
}
