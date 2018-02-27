pragma solidity ^0.4.0;
import 'https://github.com/zeppelin-solidity/contracts/ownership/Ownable.sol'; 
contract OwnerPays is Ownable {
    private uint passiveGasSpendingLimit = 5000;
    private uint totalPassiveGasSpent = 0;
    private bool paused = false;
    
    event PassiveGasSpent(uint gasAmount, uint totalSpent, uint spendingLimit);
    
    modifier ownerPays {
        require(!paused);
        require(totalSpent < spendingLimit);
        
        uint beginGas = msg.gas; //Record remaining at start
        
        _; //Execute function
        
        uint endGas = msg.gas; //Record remaining at end
        uint totalGas = beginGas - endGas; //msg.gas is gas remaining, so begin > end
        uint totalPrice = totalGas * tx.gasprice; //The total amount of gas
        
        emit PassiveGasSpent(gasAmount);
        
        msg.sender.send(totalGas, totalPassiveGasSpent, passiveGasSpendingLimit);
        totalSpent += totalPrice;
    }
    
    function setPassiveGasSpendingLimit(uint limit) onlyOwner public {
        require(msg.value == limit);
        passiveGasSpendingLimit = limit;
    }
    
    function addSpending() onlyOwner public {
        require(msg.value == limit);
        totalSpent = 0;
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
