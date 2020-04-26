//
//  Response.swift
//  BlockchainExchange
//
//  Created by Jack on 26/04/2020.
//

import Foundation
import AnyCodable

public protocol Response: Decodable {
    
    var seqnum: Int { get }
    
    var event: EventType { get }
}

public struct BaseResponse: Response {
    
    public let seqnum: Int
    
    public let event: EventType
}

public struct MetaResponse: Response {
    
    public let seqnum: Int
    
    public let event: EventType
    
    public let channel: Channel
}

public struct HeartbeatResponse: Response {
    
    public let seqnum: Int
    
    public let event: EventType
    
    public let timestamp: String?
}

public struct SymbolsResponse: Response {
    
    public let seqnum: Int
    
    public let event: EventType
    
    public let symbols: [String: AnyDecodable]
}

public struct TickerResponse: Response {
    
    public let seqnum: Int
    
    public let event: EventType
    
    public let symbol: Symbol
    
    public let price24h: Decimal?
    
    public let volume24h: Decimal?
    
    public let lastTradePrice: Decimal?
}

public struct OrderBookResponse: Response {
    
    public struct BidResponse: Codable {
        
        public let num: Int
        public let px: Decimal
        public let qty: Decimal
    }

    public struct AskResponse: Codable {
        
        public let num: Int
        public let px: Decimal
        public let qty: Decimal
    }
    
    public let seqnum: Int
    
    public let event: EventType
    
    public let channel: Channel
    
    public let symbol: Symbol
    
    public let bids: [BidResponse]?
    
    public let asks: [AskResponse]?
}

public struct PricesResponse: Response {
    
    public let seqnum: Int
    
    public let event: EventType
    
    public let symbol: Symbol
    
    public let price: [Decimal]?
}

public struct AuthResponse: Response {
    
    public let seqnum: Int
    
    public let event: EventType
    
    public let text: String?
}


public struct BalancesResponse: Response {
    
    public typealias Balance = [String: AnyDecodable]
    
    public let seqnum: Int
    
    public let event: EventType
    
    public let balances: [Balance]?
    
    public let totalAvailableLocal: Decimal?
    
    public let totalBalanceLocal: Decimal?
}

public struct TradesResponse: Response {
    
    public let seqnum: Int
    
    public let event: EventType
    
    public let symbol: Symbol
    
    public let timestamp: String?
    
    public let side: String?
    
    public let qty: Decimal?
    
    public let price: Decimal?
    
    public let tradeId: String?
}

public struct OrderResponse: Response {
    
    public let seqnum: Int
    
    public let event: EventType
    
    public let symbol: Symbol
    
    public let timestamp: String?
    
    public let side: String?
    
    public let qty: Decimal?
    
    public let price: Decimal?
    
    public let tradeId: String?
}
