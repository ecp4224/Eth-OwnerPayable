# Ethereum Owner Pays Contract (ERC-??)

This repo contains a extendable contract that enables owner pays in a secure manner using passive gas. I would feedback on this idea and any contributions would be greatly appreciated.

## Passive Gas
Passive gas is gas that a contract can put aside to spend on any function call. The idea behind this is that you prefill your smart contract with passive gas and refund the caller the amount of gas that was computed in the function. You can add passive gas by invoking the `addSpending()` function with the amount of passive gas you'd like to provide along as the value.

Due to limitations, the caller is still required to provide all the gas required upfront to complete the transaction, but they will be refunded the gas the owner contract covers.

## Modifiers

To enable a function to be owner pays, you attach the `ownerPays` modifier to the function

```
function myFunction() ownerPays {
    ....
} 
```

This will record the amount of gas spent during the execution of the function and refund the amount spent to the sender. This will also emit `PassiveGasSpent(uint gasAmount, uint totalSpent, uint spendingLimit, uint totalCost)`. This can be used to record the refund transaction (i.e to a log).

## Functions

Functions can be used to run analysis of the Passive Gas spending and knowing when to add more Passive Gas.


TODO

