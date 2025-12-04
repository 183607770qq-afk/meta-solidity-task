// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// 简单的计数器合约
contract Counter {
    uint256 public count;
    address public owner;
    
    constructor(address _owner) {
        owner = _owner;
        count = 0;
    }
    
    function increment() external {
        require(msg.sender == owner, "Not owner");
        count++;
    }
}

// 工厂合约：使用new创建新合约
contract CounterFactory {
    // 记录所有创建的计数器地址
    address[] public counters;
    
    event CounterCreated(address indexed counterAddress, address owner);
    
    /**
     * @notice 使用new创建新的计数器合约
     * @return 新创建的计数器合约地址
     */
    function createCounter() external returns (address) {
        // 使用new关键字创建新合约
        // 构造函数参数是msg.sender（调用者地址）
        Counter newCounter = new Counter(msg.sender);
        
        // 获取新合约的地址
        address counterAddress = address(newCounter);
        
        // 记录新合约地址
        counters.push(counterAddress);
        
        // 触发事件
        emit CounterCreated(counterAddress, msg.sender);
        
        return counterAddress;
    }
    
    /**
     * @notice 查询所有创建的计数器数量
     */
    function getCounterCount() external view returns (uint256) {
        return counters.length;
    }
    
    /**
     * @notice 查询指定索引的计数器地址
     */
    function getCounter(uint256 index) external view returns (address) {
        require(index < counters.length, "Index out of range");
        return counters[index];
    }
}


// contract newCounterFactory{
//     function creatCountFactory() public  view  returns (address,address){
// // 部署工厂合约
// CounterFactory factory = new CounterFactory();

// // 创建第一个计数器
// address counter1 = factory.createCounter();
// // counter1的地址是随机的，无法提前知道

// // 创建第二个计数器
// address counter2 = factory.createCounter();
// // counter2的地址也是随机的，与counter1不同
//     return (counter1,counter2);

//     }

// }