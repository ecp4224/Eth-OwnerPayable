pragma solidity ^0.4.20;

/**
 * @title OwnerPays
 * @dev The OwnerPays contract is a type of Ownable, and thus has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 *
 * This contract adds the ability to supply a contract with "Passive Gas" from an owner address. Passive Gas is then used
 * to refund the caller the gas amount for any function that has the ownerPays modifier.
 *
 * To mark a function as owner pays, just give the function the ownerPays modifier.
 */
contract OwnerPays is Ownable {
    uint passiveGasSpendingLimit = 5000;
    uint totalPassiveGasSpent = 0;
    bool paused = false;

    event PassiveGasSpent(uint gasAmount, uint totalSpent, uint spendingLimit);

    /**
     * @dev Record the exact amount of gas spent during this function call
     * and refund the caller the amount spent
     */
    modifier ownerPays {
        require(!paused);
        require(totalPassiveGasSpent < passiveGasSpendingLimit);

        uint beginGas = msg.gas; //Record remaining at start

        _; //Execute function

        uint endGas = msg.gas; //Record remaining at end
        uint totalGas = beginGas - endGas; //msg.gas is gas remaining, so begin > end
        uint totalPrice = totalGas * tx.gasprice; //The total amount of gas

        //TODO Give back gas to owner
        //msg.gas = msg.gas + totalGas;

        require(totalGas + totalPassiveGasSpent < passiveGasSpendingLimit);

        PassiveGasSpent(totalGas, totalPassiveGasSpent, passiveGasSpendingLimit);

        msg.sender.send(totalGas);
        totalPassiveGasSpent += totalGas;
    }

    /**
     * @dev Set the spending limit for passive gas.
     */
    function setPassiveGasSpendingLimit(uint limit) onlyOwner public {
        passiveGasSpendingLimit = limit;
    }

    /**
     * @dev Add passive gas to this contract.
     */
    function addSpending() onlyOwner public {
        require(msg.value > 0);
        totalPassiveGasSpent = 0;
    }

    function getTotalPassiveGasSpent() onlyOwner view returns (uint) {
        return totalPassiveGasSpent;
    }

    function getPassiveGasSpendingLimit() onlyOwner view returns (uint) {
        return passiveGasSpendingLimit;
    }

    function pause() onlyOwner public {
        paused = true;
    }

    function resume() onlyOwner public {
        paused = false;
    }
    function isPaused () onlyOwner public view returns(bool) {
        return paused;
    }
}
