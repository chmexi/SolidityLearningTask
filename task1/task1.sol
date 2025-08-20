// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract ReverseString {
    // ✅ 反转字符串 (Reverse String)
    function reverseString(string calldata str) public pure returns (string memory) {
        bytes calldata strBytes = bytes(str);
        bytes memory resBytes = new bytes(strBytes.length);
        uint256 length = strBytes.length;
        for (uint256 i = 0; i < length; i++) {
            resBytes[i] = (strBytes[length - 1 - i]);
        }
        return string(resBytes);
    }

}

contract RomanNumberConverter {
    mapping(bytes1 => uint256) private romanToInt;

    constructor() {
        romanToInt['I'] = 1;
        romanToInt['V'] = 5;
        romanToInt['X'] = 10;
        romanToInt['L'] = 50;
        romanToInt['C'] = 100;
        romanToInt['D'] = 500;
        romanToInt['M'] = 1000;
    }

    // ✅  用 solidity 实现罗马数字转数整数
    function getNum(bytes1 romanNumber) internal view returns(uint256) {
        return romanToInt[romanNumber];
    }

    function convertRomanToInt(string calldata s) public view returns (uint256) {
        // 1.每次读取当前字符和下一个字符，如果下个字符比当前字符大，把这两个字符当一个整体，继续往下走
        bytes calldata sBytes = bytes(s);
        uint256 res;
        uint256 len = sBytes.length;
        for (uint256 i = 0; i < len; i++) {
            if (i < len - 1 && getNum(sBytes[i]) < getNum(sBytes[i + 1])) {
                res += getNum(sBytes[i + 1]) - getNum(sBytes[i]);
                i += 1;
                continue;
            }
            else {
                res += getNum(sBytes[i]);
            }
        }
        return res;
    }
    
    // ✅  用 solidity 实现整数转罗马数字
    function convertIntToRoman(uint256 num) public pure returns (string memory) {
        require(num > 0 && num < 4000, "number must between 0 and 4000! ");
        uint16[13] memory values =  [1000, 900,   500, 400,  100, 90,   50,   40,  10,   9,    5,   4,    1];
        string[13] memory symbols = ["M",  "CM", "D",  "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"];
        uint256 len = values.length;
        string memory roman = "";
        while (num > 0) {
            for (uint256 i = 0; i < len; i++) {
                if (num >= values[i]) {
                    roman = string(abi.encodePacked(roman, symbols[i]));
                    num -= values[i];
                }
            }
        }
        return roman;
    }
}

// ✅  合并两个有序数组 (Merge Sorted Array)
// ✅  二分查找 (Binary Search)
contract ArrayMerger {
    function mergeTwoSortedArray(uint256[] calldata arrA, uint256[] calldata arrB) public pure returns(uint256[] memory) {
        uint256 indexA;
        uint256 indexB;
        uint256 lenA = arrA.length;
        uint256 lenB = arrB.length;
        uint256[] memory arrRes = new uint[](lenA + lenB);
        uint256 indexRes;
        while (indexA < lenA && indexB < lenB) {
            if (arrA[indexA] < arrB[indexB]) {
                arrRes[indexRes] = arrA[indexA];
                indexA++;
            }
            else {
                arrRes[indexRes] = arrB[indexB];
                indexB++;
            }
            indexRes++;
        }
        if (indexA == lenA) {
            for (; indexB < lenB; indexB++) {
                arrRes[indexRes] = arrB[indexB];
                indexRes++;
            }
        }
        else {
            for (; indexA < lenA; indexA++) {
                arrRes[indexRes] = arrA[indexA];
                indexRes++;
            }
        }
        return arrRes;
    }

    error TargetValueDontExist();
    function binarySearch(uint256[] calldata arr, uint256 target) public pure returns (uint256) {
        uint256 left = 0; 
        uint256 right = arr.length - 1;
        while (left <= right) {
            uint256 mid = (left + right) / 2;
            if (arr[mid] == target) {
                return mid;
            }
            else if (arr[mid] > target) {
                right = mid;
            }
            else if (arr[mid] < target) {
                left  = mid + 1;
            }
        }
        revert TargetValueDontExist();
    }
}