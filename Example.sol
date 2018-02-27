pragma solidity ^0.4.20;

import "OwnerPays.sol";

//TODO Come up with good example of owner pays model
contract ExampleContract is OwnerPays {

    mapping(address => uint) idk;

    function myPublicFunction() public returns (uint) {
       costlyFunction();
       return idk[msg.sender];
    }

    function costlyFunction() private ownerPays {
        idk[msg.sender]++;

    }
}
