pragma solidity 0.4.24;
  
import './Owned.sol';
import './SafeMath.sol';

/**
* @title  OPN token
* @dev    Main OPN Token Contract.
* @author codeblcks <codeblcks@gmail.com>
*/

contract OPNToken is Owned {
    using SafeMath for uint256;

    // OPN Token variables
    bytes32 internal name;
    bytes8  internal symbol;
    uint256 internal decimalFactor;
    uint256 internal totalSupply;
    uint256 internal constant decimals = 18;  
    uint256 internal constant tokenSupply = 100000000; //100 million;
   
    // Create array for balance
    mapping (address => uint256) public balances;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Burn(address indexed burner, uint256 value);
 

    /**
    * @dev Constructor for OPN token creation
    * @dev Assigns the totalSupply to the OPNToken contract
    */
    constructor() public {
        name = 'OEL Foundation OPN token';
        symbol = 'OPN';
        decimalFactor = decimals.mul(10);
        totalSupply = tokenSupply.mul(decimalFactor);
        owner = msg.sender;
        balances[msg.sender] = totalSupply;    
    } 


    /**
    * @dev    Gets the balance of the specified address.
    * @param  _owner The address to query the the balance of.
    * @return An uint256 representing the amount owned by the passed address.
    */
    function balanceOf(address _owner) internal view returns (uint256) {
        return balances[_owner];
    }


    /**
    * @dev   transfer token for a specified address
    * @param _to The address to transfer to.
    * @param _value The amount to be transferred.
    */
    function transfer(address _to, uint256 _value) internal returns (bool) {
        require(_to != address(0));
        require(_value <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }


    /**
    * @dev   Remove `_value` tokens from the system irreversibly
    * @param _value the amount of money to burn
    */
    function burn(uint256 _value) internal onlyOwner {
        assert(balances[msg.sender] >= _value);   
        balances[msg.sender] = balances[msg.sender].sub(_value); 
        totalSupply = totalSupply.sub(_value);                     
        emit Burn(msg.sender, _value);
    }

    /**
    * @dev   Function to distribute tokens
    * @param addresses array of addresses
    * @param values  array of amount to be transfered 
    */
    function distributeTokens(address[] addresses, uint256[] values) public onlyOwner {
        for (uint256 i = 0; i < addresses.length; i++) {
            require(transfer(addresses[i], values[i])); 
        }
    } 
}

