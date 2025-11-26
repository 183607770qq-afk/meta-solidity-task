// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract practise211{
    function safeConvertToUint8(uint256 value) public pure returns (uint8) {
    // TODO: 添加范围检查
    // 如果value大于255，应该revert
  require(value > type(uint8).max ,"value 过长");
}
function isZeroAddress(address addr) public pure returns (bool) {
    // TODO: 检查是否为零地址
    return  address == address(0);
}
}