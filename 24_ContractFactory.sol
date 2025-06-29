// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Item {
    string public name;
    address public owner;
    address public addr;

    constructor(address _owner, string memory _name) payable {
        owner = _owner;
        name = _name;
        addr = address(this);
    }
}

contract ItemFactory {
    Item[] public items;

    // 不带转账的道具合约实例创建
    function create(address _owner, string memory _name) public {
        Item item = new Item(_owner, _name);
        items.push(item);
    }

    //与第一个接口的区别: 通过传入value 值进行 eth 转账
    function createAndSendEth(address _owner, string memory _name) payable public {
        Item item = new Item{value: msg.value}(_owner, _name);
        items.push(item);
    }

    // 带了 salt 的合约, 使得合约地址变为可预测的地址
    function createWithSalt(address _owner, string memory name, bytes32 _salt) public {
        Item item = new Item{salt: _salt}(_owner, name);
        items.push(item);
    }

    // 除了带了 salt, 且可发送以太币
    function createWithSaltAndSendEth (address _owner, string memory name, bytes32 _salt) public  payable {
        Item item = new Item{value: msg.value, salt: _salt}(_owner, name);
        items.push(item);
    }

    // 通过索引获得具体item
    function getItem(uint256 _index) public view returns (address owner, string memory name, address addr, uint256 balance ) {
        Item item = items[_index];
        return (item.owner(), item.name(), item.addr(), address(item).balance);
    }

    // 辅助函数: 由字符串转换为32字节码的值
    function stringToBytes32Hash(string memory str) external pure returns (bytes32) {
        return keccak256(abi.encodePacked(str));
    }
}
