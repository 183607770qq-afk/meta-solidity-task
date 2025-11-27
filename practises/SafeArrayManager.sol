// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SafeArrayManager {
    uint[] public data;
    uint public constant MAX_SIZE = 100;
    
    // TODO: 实现以下功能
    
    // 1. 安全添加
    function safePush(uint value) public {
        // 检查大小限制
        // 添加元素
        require(data.length < MAX_SIZE ,"Array is full");
        data.push(value);
    }
    
    // 2. 保序删除
    function removeOrdered(uint index) public {
        // 检查索引
        // 移动元素
        // pop最后元素
        require(index < MAX_SIZE,"index out of array");
        for ( uint i = index ;i < data.length-1;i++){
          data[i] = data[i+1];
        }
        data.pop();
    }
    
    // 3. 快速删除
    function removeUnordered(uint index) public {
        // 检查索引
        // 替换为最后元素
        // pop
          require(index < MAX_SIZE,"index out of array");
        data[index] = data[data.length-1];
        data.pop();
    }
    
    // 4. 分批求和
    function sumRange(uint start, uint end) public view returns (uint) {
        // 检查范围
        // 计算总和
        require(start < end ,"Invalid range");
        require(end < data.length,"index out of bounds");
        uint totalCount;
        for (uint i = start ; i <= end;i++){
            totalCount += data[i];
        }
        return totalCount;
    }
    
    // 5. 查找元素
    function findElement(uint value) public view returns (bool, uint) {
        // 遍历查找
        // 返回是否找到和索引
        uint len = data.length;
        for(uint i= 0 ; i<len;i++){
            if (data[i] == value){
                return (true,i);
            }
        }
         return  (false,0);
    }
    
    // 6. 获取所有元素
    function getAll() public view returns (uint[] memory) {
        // 返回整个数组
        return data;
    }
}