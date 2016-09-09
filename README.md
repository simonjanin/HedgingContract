# HedgingContract

An Ethereum smart contract for hedging a financial position.
Its purpose is to match buyers of insurance (the hedgers) with the sellers of insurance (the speculator); from this trade, both participants can benefit.

## The tech

The code is contained in hedgeContract.sol, here are the main functions:

* function createOffer(uint T, uint minThreshold, uint maxThreshold)
* function takeOffer(address hedger)
* function refund(address hedger)

## The team

This project was created by:

* Simon Janin
* Salomon Faure
* Alex Roque

## Presentation

You can look at our presentation at this address: https://docs.google.com/presentation/d/1Q36Fh505VYGxrpxLy9BJ1I4s8HdPt8yvEMSWE6o4RWQ/edit?usp=sharing
