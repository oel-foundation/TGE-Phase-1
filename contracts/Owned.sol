pragma solidity 0.4.24;

/**
* @title Owned
* @dev    The Owned contract has an owner address, and provides basic authorization control
*         functions, that simplifies the implementation of "user permissions".
* @author codeblcks <codeblcks@gmail.com>
*/

contract Owned {
    address public owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );


    /**
    * @dev Constructor sets the original `owner` of the contract to the sender
    *      account.
    */
    constructor() public {
        owner = msg.sender;
    }


    /**
    * @dev Throws if called by any account other than the owner.
    */
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }


    /**
    * @dev   Transfers control of the contract to a newOwner.
    * @param _newOwner The address to transfer ownership to.
    */
    function transferOwnership(address _newOwner) internal {
        require(_newOwner != address(0));
        emit OwnershipTransferred(owner, _newOwner);
        owner = _newOwner;
    }

    /**
    * @dev   Destroy the token.
    */
    function kill() internal { 
        if (msg.sender == owner) selfdestruct(owner); 
    }
}