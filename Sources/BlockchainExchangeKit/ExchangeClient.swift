//
//  ExchangeClient.swift
//  BlockchainExchange
//
//  Created by Jack on 26/04/2020.
//

import Foundation

public enum ClientError: Error {
    case socketError(Error)
    case decodingError
}

/// Used to inject a different underlying socket transport
public protocol SocketEngineBuilder {
    
    func build(with request: URLRequest, eventHandler: @escaping ExchangeClient.EventHandler, lifecycleHandler: ExchangeClient.LifecycleHandler?) -> SocketEngine
}

/// An API client for the Blockchain.com Exchange
public class ExchangeClient {
    
    /// Client configuration parameters
    public struct Configuration {
        
        public static let `default` = Configuration(
            engine: .default,
            url: URL(string: "wss://ws.prod.blockchain.info/mercury-gateway/v1/ws")!,
            origin: "https://exchange.blockchain.com"
        )
        
        public let engine: Engine
        public let url: URL
        public let origin: String
    }
    
    /// The underlying socket engine
    public enum Engine {
        
        case `default`
        
        case other(SocketEngineBuilder)
    }
    
    
    /// Connection lifecyle events
    public enum LifcycleEvent {
        
        case connected
        case disconnected
        case cancelled
    }
    
    public typealias EventHandler = (Result<Event, ClientError>) -> Void
    public typealias LifecycleHandler = (LifcycleEvent) -> Void
    
    private let engine: SocketEngine
    
    /// Create an instance of the ExchangeClient
    /// - Parameters:
    ///   - eventHandler: an event handler for incoming messages
    ///   - lifecycleHandler: an event handler for connection lifecyle events
    ///   - configuration: configuration parameters, .default should normally be used
    public init(eventHandler: @escaping EventHandler, lifecycleHandler: LifecycleHandler? = nil, configuration: Configuration = .default) {
        
        var request = URLRequest(url: configuration.url)
        request.setValue(configuration.origin, forHTTPHeaderField: "origin")
        
        switch configuration.engine {
        case .default:
            self.engine = StarscreamEngine(
                request: request,
                eventHandler: eventHandler,
                lifecycleHandler: lifecycleHandler
            )
        case .other(let builder):
            self.engine = builder.build(
                with: request,
                eventHandler: eventHandler,
                lifecycleHandler: lifecycleHandler
            )
        }
    }
    
    // MARK: - Lifecyle
    
    /// Open connection
    public func start() {
        engine.start()
    }
    
    /// Close connection
    public func stop() {
        engine.stop()
    }
    
    // MARK: - Anonymous
    
    /// Subscribe to heartbeat channel
    public func subscribeHeartbeat() {
        let request = SubscriptionRequest(
            action: .subscribe,
            channel: .heartbeat
        )
        send(request: request)
    }
    
    /// Subscribe to the symbols updates
    public func subscribeSymbols() {
        let request = SubscriptionRequest(
            action: .subscribe,
            channel: .symbols
        )
        send(request: request)
    }
    
    /// Subscribe to level 2 order book
    /// - Parameter symbol: The symbol to subscribe to
    public func subscribeL2(symbol: Symbol) {
        let request = SubscriptionRequest(
            action: .subscribe,
            channel: .l2,
            symbol: symbol
        )
        send(request: request)
    }
    
    /// Subscribe to level 3 order book
    /// - Parameter symbol: The symbol to subscribe to
    public func subscribeL3(symbol: Symbol) {
        let request = SubscriptionRequest(
            action: .subscribe,
            channel: .l3,
            symbol: symbol
        )
        send(request: request)
    }
    
    /// Subscribe to ticker
    /// - Parameter symbol: The symbol to subscribe to
    public func subscribeTicker(symbol: Symbol) {
        let request = SubscriptionRequest(
            action: .subscribe,
            channel: .ticker,
            symbol: symbol
        )
        send(request: request)
    }
    
    /// Subscribe to candlestick market data
    /// - Parameters:
    ///   - symbol: The symbol to subscribe to (e.g. `BTC-USD`)
    ///   - granularity: The level of granularity, supported values: [ .oneMinute, .fiveMinutes, .fifteenMinutes, .oneHour, .sixHours, .day ]
    public func subscribePrices(symbol: Symbol, granularity: Granularity) {
        let request = SubscriptionRequest(
            action: .subscribe,
            channel: .prices,
            symbol: symbol,
            granularity: granularity
        )
        send(request: request)
    }
    
    // MARK: - Authenticated
    
    /// Authenticate current connection
    /// - Parameter token: the API token
    public func authenticate(token: String) {
        let request = SubscriptionRequest(
            action: .subscribe,
            channel: .auth,
            token: token
        )
        send(request: request)
    }
    
    /// Subscribe to balances channel
    public func subscribeBalances() {
        let request = SubscriptionRequest(
            action: .subscribe,
            channel: .balances
        )
        send(request: request)
    }
    
    /// Subscribe to trade updates
    /// - Parameter symbol: The symbol to subscribe to (e.g. `BTC-USD`)
    public func subscribeTrades(symbol: Symbol) {
        let request = SubscriptionRequest(
            action: .subscribe,
            channel: .trades,
            symbol: symbol
        )
        send(request: request)
    }
    
    /// Create an order
    /// - Parameter order: order parameters
    public func create(order: CreateOrder) {
        let request = order.orderRequest
        send(request: request)
    }
    
    /// Cancel an order
    /// - Parameter id: the order id
    public func cancelOrder(with id: String) {
        let request = CancelOrderRequest(
            orderId: id
        )
        send(request: request)
    }
    
    // MARK: - Private methods
    
    private func send<R: Request>(request: R, completion: (() -> Void)? = nil) {
        engine.send(request: request, completion: completion)
    }
}
