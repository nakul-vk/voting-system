// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Ballot{

    address private owner;

    address[] private registeredVoters;
    mapping(address => bool) private voted;

    uint voteCount;

    enum State{
        Active,
        Expired
    }

    State private state;

    constructor() {
        owner = msg.sender;
        voteCount = 0;
        state = State.Active;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Authentication Failure");
        _;
    }

    modifier onlyVoters(address _voter) { //Checks if the voter is registered.
        bool _isVoterRegistered = false;
        for (uint i = 0; i < registeredVoters.length; i++) { 
            if (registeredVoters[i] == _voter) {
                _isVoterRegistered = true;
                break;
            }
        }
        require(_isVoterRegistered == true, "The voter is not registered.");
        _;
    }

    modifier instate(State _state) {
        require(state == _state);
        _;
    }

    function registerVoter(address _voter) onlyOwner() public returns(bool) {
        bool _isVoterRegistered = false;
        for (uint i = 0; i < registeredVoters.length; i++) { 
            if (registeredVoters[i] == _voter) {
                _isVoterRegistered = true;
                break;
            }
        }
        if(!_isVoterRegistered) {//Checks if the voter is already registered. 
        // If not the voter gets added to the registeredVoters array.
            registeredVoters.push(_voter);
            voted[_voter] = false;
            return true;
        }
        return false;
    }

    function vote() onlyVoters(msg.sender) instate(State.Active) public {
        if (!voted[msg.sender]) {
            voteCount++;
            voted[msg.sender] = true;
        }
    }

    function getCount() public view returns(uint) {
        return voteCount;
    }

    function setState(State _state) onlyOwner() public { //For changing the state to expired or active.
        state = _state;
    }
}