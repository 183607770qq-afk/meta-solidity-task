// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RoleManagement {
    // TODO: 定义角色枚举
    enum Role { None, User, Admin, Owner }
    
    // TODO: 存储用户角色
    mapping(address => Role) public roles;
    
    address public owner;
     
    event RoleAssigned(address indexed user,Role role);
    event RoleRevoked(address indexed  user);
    constructor() {
        owner = msg.sender;
        roles[msg.sender] = Role.Owner;
    }
    
    // TODO: 定义modifier
    modifier onlyOwner() {
        // 检查是否为Owner
        require(roles[msg.sender] == Role.Owner ,"only Owner can call");
        _;
    }
    
    modifier onlyAdmin() {
        // 检查是否为Admin或Owner
        require(roles[msg.sender]==Role.Admin || roles[msg.sender] == Role.Owner ,"only Owner or  Admin can call" );
        _;
    }
    
    // TODO: 实现功能函数
    function addAdmin(address user) public  {
        // Owner添加Admin
        require(user != address(0) ,"Invalid address");
        require(roles[user] != Role.Owner,"Cannot change owner role");
        roles[user] = Role.Admin;
        emit  RoleAssigned(user, Role.Admin);
    }
    
    function addUser(address user) public onlyAdmin {
        // Admin添加User
        require(user != address(0) ,"Invalid address");
        roles[user] = Role.User;
        emit  RoleAssigned(user, Role.User);

    }
    
    function getRole(address user) public view returns (Role) {
        // 查询角色
        require(user != address(0) ,"Invalid address");
        return roles[user];
    }
}