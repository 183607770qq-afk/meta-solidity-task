// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract MyToken{
    string public name = "Chp Token";
    string public symbol = "CTK";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    address public owner;
    
    event Transfer (address from,address to,uint amount);
    event Approval (address from,address to,uint amount);
    event TransferFrom (address from,address to,uint amount);
    constructor ()  {
        owner = msg.sender;
    }
    bool public paused = false;

modifier whenNotPaused() {
    require(!paused, "Contract is paused");
    _;
}
modifier onlyOwner(){
    require(msg.sender == owner ,"Only owner can operation");
    _;
}
function pause() public onlyOwner {
    paused = true;
}

function unpause() public onlyOwner {
    paused = false;
}
    // modifier  onlyOwner(address addr){
    //     require(addr == owner ,"only owner can opreation");
    //     _;
    // }
    function transfer(address to ,uint amount)public  payable whenNotPaused  returns (bool){
       require(to != address(0),"can not transfer to zero address");
       require(balanceOf[msg.sender] >= amount ,"insufficient balance");
       balanceOf[msg.sender] -= amount;
       balanceOf[to] += amount;
       emit  Transfer(msg.sender, to, amount);
       return  true;
    }
    function approval (address spender ,uint amount)public whenNotPaused returns (bool){
        require(spender != address(0),"can not approval to zero address");
       require(balanceOf[msg.sender] >= amount ,"insufficient balance");
       allowance[msg.sender][spender] = amount;
       emit Approval(msg.sender,spender,amount);
       return  true;
    }
    function transferFrom(address from,address to ,uint amount) public whenNotPaused returns (bool){
        require(from != address(0),"from Zero");
        require(to != address(0),"to Zero");
        require(balanceOf[from] >= amount,"Insufficient Balance");
        require(allowance[from][msg.sender] >= amount,"Insufficient allowance");
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        allowance[from][msg.sender] -= amount;
        emit TransferFrom(from, to, amount);
        return  true;
    }
    function mint(address to ,uint amount) public  returns (bool){
        require(to != address(0),"Cannot mint to zero address");
        totalSupply += amount;
        balanceOf[to] += amount;
        emit  Transfer(address(0), to, amount);
        return true;
    }
    function burn(uint amount) public  returns (bool){
        require(balanceOf[msg.sender] >= amount,"Insufficient balance to burn");
        totalSupply -= amount;
        balanceOf[msg.sender] -= amount;
        emit  Transfer(msg.sender, address(0), amount);
        return true;
    }
    function batchTransfer(
    address[] memory recipients,
    uint256[] memory amounts
) public returns (bool) {
    // TODO: 实现批量转账
    // 1. 检查数组长度
    require(recipients.length == amounts.length,"Length mismatch");
    // 2. 限制批量大小
    require(recipients.length <= 50,"Batch too large");
    // 3. 计算总金额
    uint totalAmount;
    for (uint i ;i < amounts.length;i++){
        totalAmount += amounts[i];
    }   
    // 4. 检查余额
    require(balanceOf[msg.sender]>= totalAmount,"Insufficient balance");
    // 5. 执行转账
    for (uint i;i<recipients.length;i++){
            balanceOf[msg.sender] -= amounts[i];
            balanceOf[recipients[i]] += amounts[i];
        emit  Transfer(msg.sender,recipients[i], amounts[i]);
    }
    return  true;
}
}