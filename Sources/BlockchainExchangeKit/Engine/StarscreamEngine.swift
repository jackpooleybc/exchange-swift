//
//  StarscreamClient.swift
//  BlockchainExchange
//
//  Created by Jack on 26/04/2020.
//

import Foundation
import Starscream

final class StarscreamEngine: SocketEngine {
    
    private let lifecycleHandler: ExchangeClient.LifecycleHandler?
    private let eventHandler: ExchangeClient.EventHandler
    private let socket: WebSocket
    private let decoder: MessageDecoder
    private let encoder: MessageEncoder
    
    init(request: URLRequest, eventHandler: @escaping ExchangeClient.EventHandler, lifecycleHandler: ExchangeClient.LifecycleHandler? = nil, decoder: MessageDecoder = ResponseDecoder(), encoder: MessageEncoder = RequestEncoder()) {
        self.eventHandler = eventHandler
        self.lifecycleHandler = lifecycleHandler
        self.decoder = decoder
        self.encoder = encoder
        
        socket = WebSocket(request: request)
        socket.onEvent = { [weak self] event in
            
            guard let self = self else { return }
            
            switch event {
            case .connected(_):
                self.lifecycleHandler?(.connected)
            case .disconnected(_, _):
                self.lifecycleHandler?(.disconnected)
            case .text(let text):
                self.eventHandler(self.map(response: text))
            case .error(let error):
                guard let error = error else { return }
                self.eventHandler(.failure(ClientError.socketError(error)))
            case .cancelled:
                self.lifecycleHandler?(.cancelled)
            default:
                break
            }
        }
    }
    
    func start() {
        socket.connect()
    }
    
    func stop() {
        socket.disconnect()
    }
    
    func send<R: Request>(request: R, completion: (() -> Void)?) {
        guard let encodedRequestString = try? encoder.encode(request: request).get() else {
            return
        }
        socket.write(string: encodedRequestString, completion: completion)
    }
    
    // MARK: - Private methods
    
    private func map(response: String) -> Result<Event, ClientError> {
        decoder.decode(response: response).mapError { _ in .decodingError }
    }
}
