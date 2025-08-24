// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract MCXToken {
    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowances;
    string private _name;
    string private _symble;
    address private _owner;
    uint256 public _supply;

    event Transfer(address from, address to, uint256 amount);
    event Approve(address from, address to, uint256 amount);

    constructor(string memory name, string memory symble)   {
        _name   = name;
        _symble = symble;
        _owner  = msg.sender;
        // _mint(msg.sender, 10 ** 18);
    }

    modifier onlyOwner {
        require(msg.sender == _owner, "only owner can mint");
        _;
    }

    function mint(address addr, uint256 amount) onlyOwner public {
        balances[addr] += amount;
        _supply += amount;
    }

    function balanceOf(address addr) public view returns(uint256 balance)  {
        balance = balances[addr];
    }

    function transfer(address to, uint256 amount) public {
        require(balances[msg.sender] > amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        balances[to]   += amount;
        emit Transfer(msg.sender, to, amount);
    }

    function approve(address to, uint256 amount) public {
        allowances[msg.sender][to] += amount;
        emit Approve(msg.sender, to, amount);
    }

    function transferFrom(address from, address to, uint256 amount) public {
        require(allowances[from][msg.sender] > amount, "Insufficient allowance");
        require(balances[from] > amount, "Insufficient balance");
        balances[from] -= amount;
        balances[to]   += amount;
        allowances[from][to] -= amount;
        emit Transfer(from, to, amount);
    }
}