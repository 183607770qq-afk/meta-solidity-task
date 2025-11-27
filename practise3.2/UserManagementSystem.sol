// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UserManagementSystem {
    // TODO: 定义User结构体
    struct User {
        // name, email, balance, registeredAt, exists
        string name;
        string email;
        uint256 balance;
        uint256 registeredAt;
        bool exists;
    }
    
    // TODO: 定义数据存储
    mapping(address => User) public users;
    address[] public userAddresses;
    uint256 public userCount;
    uint256 public constant MAX_USERS = 1000;
    
    event UserRegistered(address indexed user, string name);
    event UserUpdated(address indexed user);
    event Deposit(address indexed user, uint256 amount);
    // TODO: 实现注册功能
    function register(string memory name, string memory email) public {
        // 检查是否已注册
        require(keccak256(bytes(users[msg.sender].name)) != keccak256(bytes(name)),"user is already register");
        // 检查是否达到上限
        require(userCount < MAX_USERS,"users is full");
        // 创建用户
        users[msg.sender] = User({
            name :name,
            email :email,
            balance: 0,
            registeredAt:block.timestamp,
            exists:true
        });
        // 添加到列表
        userAddresses.push(msg.sender);
        // 更新计数
        userCount++;
        emit UserRegistered(msg.sender, name);
    }
    
    // TODO: 实现其他功能...
    function updateUserInfo(string memory name,string memory email) public {
        require(users[msg.sender].exists,"user does not exist ");
        users[msg.sender].name = name;
        users[msg.sender].email = email;
        emit UserUpdated(msg.sender);
    } 
    function deposit() public payable {
     require(users[msg.sender].exists,"user does not exist ");
     require(msg.value > 0,"must be ETH");
     users[msg.sender].balance += msg.value;
     emit Deposit(msg.sender, msg.value);
    }
    function getUserInfo(address user) public  view  returns (User memory){
    require(users[user].exists,"user does not exist ");
       return users[user];
    }
    function allUsers() public view returns (address[] memory){
      return userAddresses;
    }
    function batchGetUser(uint start,uint end)public  view  returns (address[] memory){
        require(start < end,"Invalid range");
        require(end <= userAddresses.length,"index out of bounds");
        uint len = end -start;
        address[] memory result = new  address[](len);
        for (uint i=0;i<len;i++){
            result[i]=userAddresses[start + i];
        }
        return  result;
    }

}