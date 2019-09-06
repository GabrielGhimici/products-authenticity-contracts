pragma solidity >=0.4.21 <0.6.0;

contract Owned {
    address public owner;
    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "This action can be performed only by contract owner");
        _;
    }

    function transferOwnership(address newOwner) external onlyOwner {
        if (newOwner != address(0)) {
            owner = newOwner;
        }
    }
}
