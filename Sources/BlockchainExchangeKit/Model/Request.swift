//
//  Request.swift
//  BlockchainExchange
//
//  Created by Jack on 26/04/2020.
//

import Foundation

public enum OrderType: String {
    
    case market
    
    case limit
}

/// Create order parameters
public struct CreateOrder {
    
    public let cancelOrderId: String
    
    public let symbol: Symbol
    
    public let orderType: OrderType
    
    public let timeInForce: String?
    
    public let side: String
    
    public let orderQty: Decimal
    
    public let price: Decimal?
    
    public let minQty: Decimal?
    
    public let stopPx: Decimal?
    
    public let expireDate: Int?
    
    public let execInst: String?
    
    var orderRequest: CreateOrderRequest {
        CreateOrderRequest(
            clOrderId: cancelOrderId,
            symbol: symbol,
            ordType: orderType,
            timeInForce: timeInForce,
            side: side,
            orderQty: orderQty,
            price: price,
            minQty: minQty,
            stopPx: stopPx,
            expireDate: expireDate,
            execInst: execInst
        )
    }
}

public enum Granularity: Int {
    
    case oneMinute = 60
    case fiveMinutes = 300
    case fifteenMinutes = 900
    case oneHour = 3600
    case sixHours = 21600
    case day = 86400
}

public protocol Request: Encodable {
    
    var action: String { get }
    var channel: String { get }
}

struct SubscriptionRequest: Request {
    
    let action: String
    let channel: String
    let symbol: String?
    let granularity: Int?
    let token: String?
    
    init(action: Action, channel: Channel, symbol: Symbol? = nil, granularity: Granularity? = nil, token: String? = nil) {
        self.action = action.rawValue
        self.channel = channel.rawValue
        self.symbol = symbol?.rawValue
        self.granularity = granularity?.rawValue
        self.token = token
    }
}

struct CreateOrderRequest: Request {
    
    let action: String
    
    let channel: String
    
    let clOrderId: String
    
    let symbol: String
    
    let ordType: String
    
    let timeInForce: String?
    
    let side: String
    
    let orderQty: Decimal
    
    let price: Decimal?
    
    let minQty: Decimal?
    
    let stopPx: Decimal?
    
    let expireDate: Int?
    
    let execInst: String?
    
    init(action: Action = .createOrder,
         channel: Channel = .trading,
         clOrderId: String,
         symbol: Symbol,
         ordType: OrderType,
         timeInForce: String? = nil,
         side: String,
         orderQty: Decimal,
         price: Decimal? = nil,
         minQty: Decimal? = nil,
         stopPx: Decimal? = nil,
         expireDate: Int? = nil,
         execInst: String? = nil) {
        self.action = action.rawValue
        self.channel = channel.rawValue
        self.clOrderId = clOrderId
        self.symbol = symbol.rawValue
        self.ordType = ordType.rawValue
        self.timeInForce = timeInForce
        self.side = side
        self.orderQty = orderQty
        self.price = price
        self.minQty = minQty
        self.stopPx = stopPx
        self.expireDate = expireDate
        self.execInst = execInst
    }
}

struct CancelOrderRequest: Request {
    
    let action: String = Action.cancelOrder.rawValue
    
    let channel: String = Channel.trading.rawValue
    
    let orderId: String
}
