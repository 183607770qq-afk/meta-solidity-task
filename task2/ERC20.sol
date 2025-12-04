// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract ERC20{
    string public name = "Chp Token";
    string public symbol = "CTK";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    address public  owner;
    constructor(){
        owner = msg.sender;
    }
    mapping (address=> uint) balance;
    mapping (address=>mapping (address=>uint)) allowoner;
    event Transfer(address from, address to,uint amount);
    event Approve(address from,address to,uint amount);
    modifier onlyOwner(){
           require(msg.sender == owner,"only owner");
           _;
    }
    function balanceOf(address addr) public  view returns (uint256){
           require(addr != address(0),"Invaild address");
           return  balance[addr];
    }
    function approve(address to,uint amount)public   returns (bool){
            require(to != address(0),"Invaild address");
            require( balance[msg.sender] >= amount,"Insufficeint balance");
            allowoner[msg.sender][to] = amount;
            emit  Approve(msg.sender, to, amount);            
            return  true;
    }
     function transferFrom(address from ,address to ,uint amount) public returns (bool){
                require(from != address(0),"Invaild from address");
                require(to != address(0),"Invaild to address");
                require( balance[from] >= amount,"Insufficeint balance");
                balance[from] -= amount;
                balance[to] += amount;
                allowoner[from][msg.sender] -= amount;
                emit Transfer(from, to, amount);
                return true;

     }
     function mint (address to,uint256 amount) public onlyOwner {
        require(to != address(0),"Can Not Mint To Zero Address");
         totalSupply += amount;
         balance[to] += amount;
         emit Transfer(address(0), to, amount);
     }
     function burn (uint256 amount) public onlyOwner {
         require(balance[msg.sender] >= amount,"Insufficient Balance");
         totalSupply -= amount;
         balance[msg.sender] -= amount;
         emit Transfer(msg.sender, address(0), amount);
     }
  }