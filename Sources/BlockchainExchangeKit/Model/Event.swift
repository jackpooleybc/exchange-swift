//
//  Event.swift
//  BlockchainExchange
//
//  Created by Jack on 26/04/2020.
//

import Foundation
import AnyCodable

enum DecodingError: Error {
    
    case decodingError
}

/// Event Types
public enum EventType: String, Codable {
    
    public enum Category {
        case data
        case meta
    }
    
    case subscribed   = "subscribed"
    case unsubscribed = "unsubscribed"
    case rejected     = "rejected"
    case snapshot     = "snapshot"
    case updated      = "updated"
    
    public var category: Category {
        switch self {
        case .subscribed, .unsubscribed, .rejected:
            return .meta
        case .snapshot, .updated:
            return .data
        }
    }
}


/// Incoming events
public enum Event: Decodable {
    
    private enum CodingKeys: String, CodingKey {

        case channel = "channel"
    }

    static var messageInfoKey: CodingUserInfoKey {
        CodingUserInfoKey(rawValue: "info")!
    }
    
    /// Meta
    case meta(MetaResponse)

    /// Anonymous
    case heartbeat(HeartbeatResponse)
    case symbols(SymbolsResponse)
    case ticker(TickerResponse)
    case orderBook(OrderBookResponse)
    case prices(PricesResponse)

    /// Authenticated
    case balances(BalancesResponse)
    case order(OrderResponse)
    case trades(TradesResponse)
    case auth(AuthResponse)

    public init(from decoder: Decoder) throws {
        guard let info = decoder.userInfo[Self.messageInfoKey] as? MessageInfo else {
            throw ClientError.decodingError
        }
        switch info.eventType.category {
        case .meta:
            self = try Event.metaEvent(for: info.data)
        case .data:
            self = try Event.dataEvent(for: info.channel, data: info.data)
        }
    }
    
    // MARK: - Private functions
    
    private static func metaEvent(for data: Data) throws -> Self {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let meta = try decoder.decode(MetaResponse.self, from: data)
        return .meta(meta)
    }

    private static func dataEvent(for channel: Channel, data: Data) throws -> Self {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        switch channel {
        case .symbols:
            let symbols: SymbolsResponse = try decoder.decode(SymbolsResponse.self, from: data)
            return .symbols(symbols)
        case .heartbeat:
            let heartbeat = try decoder.decode(HeartbeatResponse.self, from: data)
            return .heartbeat(heartbeat)
        case .ticker:
            let ticker = try decoder.decode(TickerResponse.self, from: data)
            return .ticker(ticker)
        case .l2, .l3:
            let orderBook = try decoder.decode(OrderBookResponse.self, from: data)
            return .orderBook(orderBook)
        case .prices:
            let prices = try decoder.decode(PricesResponse.self, from: data)
            return .prices(prices)
        case .auth:
            let auth = try decoder.decode(AuthResponse.self, from: data)
            return .auth(auth)
        case .balances:
            let balances = try decoder.decode(BalancesResponse.self, from: data)
            return .balances(balances)
        case .trading:
            let order = try decoder.decode(OrderResponse.self, from: data)
            return .order(order)
        case .trades:
            let trades = try decoder.decode(TradesResponse.self, from: data)
            return .trades(trades)
        }
    }
}

