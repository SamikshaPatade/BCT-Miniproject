//SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.9.0;

contract Lottery{
    address public manager;
    address payable[] public players;//to send ether on particular account or contract payable is used.
    

    constructor(){
        manager = msg.sender;//global variable
    }

    receive () external payable
    {
        require(msg.value == 1 ether);
        players.push(payable(msg.sender));
    }


    function getBalance() public view returns(uint){
        require(msg.sender == manager);
        return address(this).balance;
    }

    function random() public view returns(uint){

       return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
       //hashing functions
    }
    function pickWinner() public{
        require(msg.sender == manager);
        require (players.length >= 3);
        uint r = random();
        address payable winner;
        uint index = r % players.length;//This operation will ensure that the return value will be less than denominator.
        winner = players[index];
        winner.transfer(getBalance());
        players = new address payable[](0);
    }
}