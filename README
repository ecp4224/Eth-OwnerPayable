# Ethereum Owner Pays Protocol (ERC-??)

This repo contains a extendable contract that enables owner pays in a secure manner using passive gas.

## Passive Gas
Passive gas is gas that a contract can put aside to spend on any function call. The idea behind this is that you prefill your smart contract with passive gas and refund the caller the amount of gas that was computated in the function. When you reset your spending you're required to send at least `spendingLimit - totalSpent` along with it. When you set the spending limit, you're required to send `totalSpent + spendingLimit` along with it.

## Modifiers

To enable a function to be owner pays, you attach the `ownerPays` modifier to the function

```
function myFunction() ownerPays {
    ....
} 
```

This will record the amount of gas spent during the execution of the function and refund the amount spent to the sender. This will also emit `PassiveGasSpent(uint gasAmount, uint totalSpent, uint spendingLimit)`. This can be used to record the refund transaction (i.e to a log).

## Functions

Functions can be used to run analysis of the Passive Gas spending and knowing when to reset your Passive Gas.


TODO

