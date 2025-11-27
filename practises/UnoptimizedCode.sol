// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract UnoptimizedCode {
    uint[] public data;
        uint[] public data1;
    uint[] public data2;

    
     function process(uint[] calldata values) external {
        uint len = values.length;
        
        // 第一次遍历：计算需要添加的数量
        uint count = 0;
        for(uint i = 0; i < len; i++) {
            if(values[i] > 10) {
                count++;
            }
        }        
        // 第二次遍历：添加元素
        for(uint i = 0; i < len; i++) {
            if(values[i] > 10) {
                data.push(values[i]);
            }
        }
    }


    function process1(uint[] calldata values) public   {
        uint  len = values.length;
        for(uint i = 0; i < len; i++) {
            uint value=values[i];
            if(value > 10) {
                // data1.push(value);
            }
        }
               
    }
       function process2(uint[] memory values) public {
        for(uint i = 0; i < values.length; i++) {
            if(values[i] > 10) {
                // data2.push(values[i]);
            }
        }
    }

    // 在 Remix 中创建大数组测试
function testLargeArray() public pure  returns (uint[] memory) {
    // 生成包含1000个元素的大数组
    uint[] memory largeArray = new uint[](500);
    for (uint i = 0; i < 500; i++) {
        largeArray[i] = i % 20; // 混合大于10和小于10的值
    }
    
    // 分别测试两个函数
    // process1(largeArray); // calldata
    // process2(largeArray); // memory
    return  largeArray;
}
 // 重置数据用于多次测试
    function reset() public {
        delete data;
        delete data1;
        delete data2;
    }
    
}
