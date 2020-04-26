//
//  Symbol.swift
//  BlockchainExchange
//
//  Created by Jack on 26/04/2020.
//


/// Availble currencies
public enum Currency: String, Codable {
    
    /// Fiat
    case USD
    case EUR
    case GBP
    case TRY
    
    /// Crypto
    case BTC
    case BCH
    case ETH
    case XLM
    case ALGO
    case DGLD
    case USDT
}

public struct Symbol: RawRepresentable, Codable {
    
    public var rawValue: String
    
    public init?(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public init(_ lhs: Currency, _ rhs: Currency) {
        self.rawValue = "\(lhs.rawValue)-\(rhs.rawValue)"
    }
}

extension Symbol: CustomDebugStringConvertible {
    public var debugDescription: String {
        rawValue
    }
}
