pragma solidity >=0.4.21 <0.6.0;

library ArrayUtils {
    function existsAdress(address[] memory arr, address element) public pure returns (bool) {
        for (uint64 index = 0; index < arr.length; index++) {
            if (element == arr[index]) {
                return true;
            }
        }
        return false;
    }

    function existsValue(uint64[] memory arr, uint64 element) public pure returns (bool) {
        for (uint64 index = 0; index < arr.length; index++) {
            if (element == arr[index]) {
                return true;
            }
        }
        return false;
    }
}