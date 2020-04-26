//
//  Channel.swift
//  BlockchainExchange
//
//  Created by Jack on 26/04/2020.
//

/// Channels
public enum Channel: String, Codable {
    
    case heartbeat
    case l2
    case l3
    case prices
    case symbols
    case trades   
    case ticker
    case auth
    case balances
    case trading
}
