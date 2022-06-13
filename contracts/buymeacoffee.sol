//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

//Deployed to Goerli at :0xa775818a67990cA9418d8503fDa4C2A4846F2368
contract BuyMeACoffee is Ownable{
    //Event to emit when a Memo is created
    event NewMemo(
        address indexed from,
        uint256 timestamp,
        string name,
        string message
    );

    //Memo struct
    struct Memo {
        address from;
        uint256 timestamp;
        string name;
        string message;
    }

    //List of all memos received from friends.
    Memo[] memos;

    //Address of contract
    address payable currentOwner;

    //Deploy logic
    constructor() {
        //currentOwner = payable(msg.sender);
        currentOwner = payable(owner());
    }

    /**
     * @dev buy a coffee for contract owner
     * @param _name name of the coffee buyer
     * @param _message a nice message for the coffee buyer
     */

    function buyCoffee(string memory _name, string memory _message) public payable {
        require(msg.value > 0, "need more than 0 eth to buy a coffee");

        //Add the memo to storage!
        memos.push (Memo(
            msg.sender,
            block.timestamp,
            _name,
            _message
        ));

        //Emit a log event when a new memo is created
        emit NewMemo(
            msg.sender,
            block.timestamp,
            _name,
            _message
        );  
    }

     /**
     * @dev send the entire balance stored in this contract to the owner 
     */
    function withdrawTips() public { 
        require(currentOwner.send(address(this).balance));
    }

     /**
     * @dev retrieve all the memos received and stored on the blockchain 
     */
    function getMemos() public view returns(Memo[] memory)  {
        return memos;
    }

    /**
     * @dev change the owner of the project 
     */
    function changeOwner(address newOwner) public payable onlyOwner {
        require(msg.value > 0, "need more than 0 eth to change the owner");
        transferOwnership(newOwner);
        currentOwner = payable(newOwner);
    }

}