// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

event ConstructorA(uint x);
event ConstructorC(uint y);
event ConstructorB();

contract D {}

contract A is D {
    constructor(uint x) { emit ConstructorA(x); }
    function foo () public  virtual pure returns (string memory) {
        return "A contract";
    }
}
contract C is D {
    constructor(uint y) { emit ConstructorC(y); }
    function foo () public  virtual pure returns (string memory) {
        return "A contract";
    }
}

contract B is A, C {
    constructor() A(100) C(200) { emit ConstructorB(); }
    function foo () public override(A, C) pure returns (string memory) {
        return "B contract";
    }
}