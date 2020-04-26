//
//  Action.swift
//  BlockchainExchange
//
//  Created by Jack on 26/04/2020.
//

/// Actions
enum Action: String {
    
    case subscribe
    case unsubscribe
    case cancelOrder = "CancelOrderRequest"
    case createOrder = "NewOrderSingle"
}
