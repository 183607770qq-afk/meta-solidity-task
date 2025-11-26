// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract PracticeContract {
    uint256[] public  numbers;
    address public immutable admin;
    uint256 public  multiplier = 2;
    
    function batchProcess(
        uint256[] memory inputs
    ) external {
        require(msg.sender == admin);
         uint256  len =  inputs.length;
         uint256[] memory results =new uint256[](len);
         
        for (uint i = 0; i < len; i++) {
            results[i]=inputs[i] * multiplier;
        }

        for (uint i = 0; i < len; i++) {
            numbers.push(results[i]);
        }
    }
    
    function getSum() external view returns (uint256) {
        require(msg.sender == admin);
        
        uint256 sum = 0;
        uint256 len = numbers.length;
        for (uint i = 0; i < len; i++) {
            sum += numbers[i];
        }
        return sum;
    }
}