// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Modifier {
    address public owner;
    mapping (address => uint256) public balance;

    constructor() {
        owner = msg.sender;
    }

    event eventModifier(address indexed sender, string desc);

    function deposit() external payable {
        require(msg.value > 0, "Deposit amount must be greater than 0 wei");
        balance[msg.sender] += msg.value;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only Owner");
        _; // 占位符
    }

    modifier validAmount(uint256 amount) {
        require(amount > 0, "!!!!amount value must be greater than 0!!!!");
        _;
    }

    modifier EventModifier(address sender, string memory func) {
        emit eventModifier(sender, string.concat("before::::", func));
        _;
        emit eventModifier(sender, string.concat("after---->", func));
    }

    function withdraw(uint256 amount) external onlyOwner validAmount(amount) {
        // require(msg.sender == owner, "Now owner"); // 这行给上面的modifier: onlyOwner 取代了, modifier可以在不同函数进行复用 
        // require(amount > 0); // 这行被上面 modifier: validAmount 取代了
        require(amount <= address(this).balance, "Insufficient contract balance");
        balance[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    // 可以前置及后置检查的 modifier: EventModifier, 传入这里的函数名 "changeOwner"
    function changeOwner(address _newOwner) external onlyOwner EventModifier(_newOwner, "changeOwner"){
        // require(msg.sender == owner, "No Owner");// 这行给上面的modifier: onlyOwner 取代了
        owner = _newOwner;
    }

    function getBalance() external view returns(uint256) {
        return address(this).balance;
    }
}