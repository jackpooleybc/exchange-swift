# BlockchainExchangeKit

A [Blockchain.com Exchange](https://exchange.blockchain.com/) API client written in Swift.

## Supports the following features

- [x] Create market, and limit orders
- [x] Cancel an order
- [x] Subscribe to balances
- [x] Subscribe to market data
- [x] Subscribe to symbol reference data

## Example Project

Check out the `BlockchainExchangeExample` project to see how to connect to the exchange and subscribe to the available channels.

### Anonymous example

    $ swift run examples anonymous 

### Authenticated example

    $ swift run examples authenticated --token "<API_TOKEN>"

## Requirements

`BlockchainExchangeKit` works on iOS 13 and macoOS Catalina or above. 

## Installation

### Swift Package Manager

```swift
dependencies: [
    .package(name: "BlockchainExchangeKit", url: "https://github.com/jackpooleybc/exchange-swift.git", from: "0.0.1")
]
```
