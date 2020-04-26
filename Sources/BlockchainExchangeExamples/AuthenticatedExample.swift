import Foundation
import BlockchainExchangeKit

class AuthenticatedExample {
    
    private let token: String
    
    private var exchange: ExchangeClient?
    
    private init(token: String) {
        self.token = token
        
        let eventHandler: ExchangeClient.EventHandler = { [weak self] result in
            switch result {
            case .success(let event):
                switch event {
                case .meta(let meta):
                    if meta.channel == .auth && meta.event == .subscribed {
                        self?.subscribe()
                    }
                case .balances(let balances):
                    if balances.event == .snapshot {
                        print("💰 - \(balances)")
                    }
                case .auth(let auth):
                    print("🔒 - \(auth)")
                default:
                    print("ℹ️ - \(event)")
                }
            case .failure(let error):
                print("🛑 - \(error)")
            }
        }
        
        let lifecycleHandler: ExchangeClient.LifecycleHandler = { [weak self] lifecyleEvent in
            if lifecyleEvent == .connected {
                self?.authenticate()
            }
        }
        
        self.exchange = ExchangeClient(
            eventHandler: eventHandler,
            lifecycleHandler: lifecycleHandler
        )
    }
    
    static func run(with token: String) {
        print("Running Authenticated Example")
        
        let authenticatedExample = AuthenticatedExample(token: token)
        authenticatedExample.exchange?.start()
        RunLoop.main.run()
    }
    
    private func authenticate() {
        exchange?.authenticate(token: token)
    }
    
    private func subscribe() {
        exchange?.subscribeBalances()
    }
}
