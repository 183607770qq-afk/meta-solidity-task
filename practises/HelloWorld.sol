// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract HelloWorld{
    string public  message = "hello world";
    address public  owner;
    function   getMessage()  public  view returns   (string memory){
        return message;
    }
    function updateMessage(string calldata newMessage) public {
        message =newMessage;
    }
    function setOwner ()public {
         owner=msg.sender;
    }
    function getOwner () public  view returns (address){
         return owner;
    }
    function isOwner () public  view  returns (bool){
        return  owner == msg.sender;
}
}


// contract HelloWorld {
//     string public message;
//     address public owner;  // 新增
    
//     constructor() {
//         message = "Hello, Solidity!";
//         owner = msg.sender;  // 新增
//     }
    
//     function updateMessage(string memory newMessage) public {
//         message = newMessage;
//     }
    
//     function getMessage() public view returns (string memory) {
//         return message;
//     }
    
//     function getOwner() public view returns (address) {  // 新增
//         return owner;
//     }
    
//     function isOwner() public view returns (bool) {  // 新增
//         return msg.sender == owner;
//     }
// }