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
    uint passiveGasAllowance = 0;
    bool paused = false;

    event PassiveGasSpent(uint gasAmount, uint totalSpent, uint spendingLimit, uint totalPrice);

    /**
     * @dev Record the exact amount of gas spent during this function call
     * and refund the caller the amount spent
     */
    modifier ownerPays {
        require(!paused);
        require(passiveGasAllowance > 0);

        uint beginGas = msg.gas; //Record remaining at start

        _; //Execute function

        uint endGas = msg.gas; //Record remaining at end
        uint totalGas = beginGas - endGas; //msg.gas is gas remaining, so begin > end
        uint totalPrice = totalGas * tx.gasprice; //The total amount of gas

        //TODO Give back gas to owner
        //msg.gas = msg.gas + totalGas;

        require(passiveGasAllowance - totalGas > 0);

        PassiveGasSpent(totalGas, totalPassiveGasSpent, passiveGasSpendingLimit, totalPrice);

        msg.sender.send(totalGas);
        passiveGasAllowance -= totalGas;
    }

    /**
     * @dev Add passive gas to this contract. The value sent to this
     * call will be added to the total amount of passiveGasAllowance
     */
    function addSpending() onlyOwner public {
        require(msg.value > 0);
        passiveGasAllowance += msg.value;
    }

    /**
     * @dev Get total passive gas left in this contract.
     */
    function getTotalPassiveGas() onlyOwner view returns (uint) {
        return passiveGasAllowance;
    }

    /**
     * @dev Pause all usage of passive gas. This will cause any function using
     * the ownerPays to throw before execution begins
     */
    function pause() onlyOwner public {
        paused = true;
    }

    /**
     * @dev Resume all usage of passive gas.
     */
    function resume() onlyOwner public {
        paused = false;
    }

    /**
     * @dev Check whether passive gas usage is paused. If passive gas usage is
     * paused, any function using the ownerPays to throw before execution begins
     */
    function isPaused () onlyOwner public view returns(bool) {
        return paused;
    }
}
