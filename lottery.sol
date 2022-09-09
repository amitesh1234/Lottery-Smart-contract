// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
pragma abicoder v2;

import "@openzeppelin/contracts/access/Ownable.sol";


contract Lottery is Ownable {
    enum LOTTERY_STATE {OPEN, CLOSED}
    LOTTERY_STATE public state;
    uint256 public numberWinners;
    uint256[] public tasksList;
    uint256[] public winners;

    constructor() {
        state = LOTTERY_STATE.CLOSED;
        numberWinners = 3;
    }

    function taskListLength() public view returns(uint256) {
        return tasksList.length;
    }

    function setNumberWinners(uint256 _numberWinners) public {
        numberWinners = _numberWinners;
    }

    function winnerArrayLength() public view onlyOwner returns(uint256) {
        return winners.length;
    }

    function returnSender() public view returns(address) {
        return msg.sender;
    }

    function stopLottery() public onlyOwner {
        state = LOTTERY_STATE.CLOSED;
    }


    function startLottery() public onlyOwner {
        state = LOTTERY_STATE.OPEN;
        tasksList = new uint256[](0);
        winners = new uint256[](0);
    }

    function addPlayers(uint256[] memory tasks) public {
        require(state == LOTTERY_STATE.OPEN, "Lottery is either finished or hasn't begun yet!");
        require(tasks.length >= numberWinners, "Number of Winners to be declared greater thatn the input size!");
        require(tasks.length > 0, "No Imput addresses present!");
        for(uint i=0; i<tasks.length; i++) {
            tasksList.push(tasks[i]);
        }
    }


    function declareWinner() public onlyOwner{
        require(state == LOTTERY_STATE.OPEN, "Lottery is either finished or hasn't begun yet!");
        require(tasksList.length > 0, "No players in the lottery Yet!");
        require(numberWinners <= tasksList.length, "The number of winners to be declared need to be greater than the entries");
        require(numberWinners > 0, "The number of winners to be declared cannot be zero");

        for (uint256 i = 0; i < numberWinners; i++) {
            uint256 n = i + uint256(keccak256(abi.encodePacked(block.timestamp))) % (tasksList.length - i);
            uint256 temp = tasksList[n];
            tasksList[n] = tasksList[i];
            tasksList[i] = temp;
        }
        for(uint256 i=0; i<numberWinners; i++) {
            winners.push(tasksList[i]);
        }
    }

    function returnWinnersList() public view returns(uint256[] memory) {
        return winners;
    }

    function resetLottery() public onlyOwner {
        stopLottery();
        tasksList = new uint256[](0);
        winners = new uint256[](0);
    }
}