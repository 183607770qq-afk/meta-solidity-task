// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract Titles {
      mapping (bytes1 => uint) romanToInts;
      mapping (uint => bytes1) romans;
      constructor (){
            romanToInts['I'] = 1;
            romanToInts['V'] = 5;
            romanToInts['X'] = 10;
            romanToInts['L'] = 50;
            romanToInts['C'] = 100;
            romanToInts['D'] = 500;
            romanToInts['M'] = 1000;
            romans[1] = 'I';
            romans[5] = 'V';
            romans[10] = 'X';
            romans[50] = 'L';
            romans[100] = 'C';
            romans[500] = 'D';
            romans[1000] = 'M';
      }

     function reverseString(string memory s)public  pure   returns (string memory){
        bytes memory bytesStr = bytes(s);
        uint len = bytesStr.length;
        bytes memory resultStr = new bytes(len);
        for (uint i = 0; i< len; i ++){
              resultStr[i] = bytesStr[len -i-1];
        }
        return  string(resultStr);
     }
     function  romanToInt(string memory s) public view  returns  (int) {
           bytes memory str = bytes(s);
           uint len = str.length;
           int ans = 0;
           for (uint i= 0 ;i< len; i++){
             uint value  =  romanToInts[str[i]];
             if (i < len -1 && value < romanToInts[str[i +1]]){
                      ans -= int(value);
             }else{
                  ans += int(value);
             }
           }
           return  ans;

}
   function uintToRoman(uint num) public  pure   returns  (string memory){
      uint256[13] memory keys = [uint256(1000), 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1];

      string[13] memory values = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"];

      bytes memory result = "";
 
      for(uint i = 0;i<13 ;i++){
            while (num >= keys[i]){
                  num -=keys[i];
                  result = abi.encodePacked(result,values[i]);
            }
      }
      return  string(result);
   }
            //将两个有序数组合并为一个有序数组。
    function megerSortArray(uint[] calldata arr1,uint[] calldata arr2) public  pure   returns (uint[] memory){
           uint len1 =arr1.length;
           uint len2 =arr2.length;
           uint[] memory arr = new uint[](len1+len2);
           uint i=0;
           uint j=0;
           uint k=0;
           while (i < len1 && j < len2){
            arr[k++] = arr1[i] <= arr2[j]? arr1[i++]:arr2[j++];
           }
           while (i<len1) arr[k++] =arr1[i++];
           while (j<len2) arr[k++] =arr2[j++];
           return arr;
    }
    //在一个有序数组中查找目标值。
    function BinarySearch(uint[] calldata arr,uint num) public  pure  returns (int){
            uint len =arr.length;
            uint left = 0;
            uint right = len-1;
            while (left <= right){
                  uint mid = left + (right - left)/2 ;
                  if  (arr[mid] == num) {return int(mid);}
                   if (arr[mid] >num){
                        right = mid -1;
                   }
                  if (arr[mid] <num){
                        left = mid +1;
                   }
            }
            return -1;
    }
}