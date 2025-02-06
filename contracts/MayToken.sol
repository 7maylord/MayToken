// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract MayToken {
    string public name = "MayToken";
    string public symbol = "MAY";
    uint8 public decimals = 18;
    uint public totalSupply;
    address public owner;

    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Burn(address indexed from, uint value);
    event Mint(address indexed to, uint value);
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    constructor(uint256 _initialSupply) {
        owner = msg.sender;
        totalSupply = _initialSupply * 10 ** uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
    }

    function transfer(address _to, uint _value) public returns (bool success) {
        require(_to != address(0), "Invalid address");
        require(balanceOf[msg.sender] >= _value, "Not enough funds");
        
        unchecked {
            balanceOf[msg.sender] -= _value;
            balanceOf[_to] += _value;
        }

        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint _value) public returns (bool success) {
        require(_spender != address(0), "Invalid address");
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
        require(_to != address(0), "Invalid address");
        require(balanceOf[_from] >= _value, "Not enough funds");
        require(allowance[_from][msg.sender] >= _value, "Allowance exceeded");

        unchecked {
            balanceOf[_from] -= _value;
            balanceOf[_to] += _value;
            allowance[_from][msg.sender] -= _value;
        }

        emit Transfer(_from, _to, _value);
        return true;
    }

    function increaseAllowance(address _spender, uint _addedValue) public returns (bool success) {
        require(_spender != address(0), "Invalid address");
        allowance[msg.sender][_spender] += _addedValue;
        emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
        return true;
    }

    function decreaseAllowance(address _spender, uint _subtractedValue) public returns (bool success) {
        require(_spender != address(0), "Invalid address");
        require(allowance[msg.sender][_spender] >= _subtractedValue, "Allowance too low");

        unchecked {
            allowance[msg.sender][_spender] -= _subtractedValue;
        }

        emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
        return true;
    }

    function burn(uint _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Not enough funds");

        unchecked {
            balanceOf[msg.sender] -= _value;
            totalSupply -= _value;
        }

        emit Burn(msg.sender, _value);
        emit Transfer(msg.sender, address(0), _value);
        return true;
    }

    function mint(address _to, uint _value) public onlyOwner returns (bool success) {
        require(_to != address(0), "Invalid address");

        unchecked {
            totalSupply += _value;
            balanceOf[_to] += _value;
        }

        emit Mint(_to, _value);
        emit Transfer(address(0), _to, _value);
        return true;
    }
}
