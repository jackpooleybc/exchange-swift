import Foundation
import BlockchainExchangeKit

class AnonymousExample {
    
    private var exchange: ExchangeClient?
    
    private init() {
        let eventHandler: ExchangeClient.EventHandler = { result in
            switch result {
            case .success(let event):
                switch event {
                case .orderBook(let orderBook):
                    switch orderBook.event {
                    case .snapshot:
                        print("📸 - \(orderBook.channel) / \(orderBook.symbol) [ bids: \(String(describing: orderBook.bids?.map(\.qty))), asks: \(String(describing: orderBook.asks?.map(\.qty))) ]")
                    case .updated:
                        print("📖 - \(orderBook.channel) / \(orderBook.symbol) [ bids: \(String(describing: orderBook.bids)), asks: \(String(describing: orderBook.asks)) ]")
                    default:
                        break
                    }
                case .symbols(let symbols):
                    if symbols.event == .updated {
                        print("🔄 - \(symbols.symbols)")
                    }
                case .ticker(let ticker):
                    if ticker.event.category == .data {
                        print("🕒 -  \(ticker.symbol): [ price: \(String(describing: ticker.price24h)), volume: \(String(describing: ticker.volume24h)), last: \(String(describing: ticker.lastTradePrice)) ] ")
                    }
                default:
                    print("ℹ️ - \(event)")
                }
            case .failure(let error):
                print("🛑 - \(error)")
            }
        }
        
        let lifecycleHandler: ExchangeClient.LifecycleHandler = { [weak self] lifecyleEvent in
            if lifecyleEvent == .connected {
                self?.subscribe()
            }
        }
        
        self.exchange = ExchangeClient(
            eventHandler: eventHandler,
            lifecycleHandler: lifecycleHandler
        )
    }
    
    static func run() {
        print("Running Anonymous Example")
        
        let anonymousExample = AnonymousExample()
        anonymousExample.exchange?.start()
        RunLoop.main.run()
    }
    
    private func subscribe() {
        exchange?.subscribeHeartbeat()
        exchange?.subscribeSymbols()
        exchange?.subscribeL2(symbol: Symbol(.BTC, .USD))
        exchange?.subscribeTicker(symbol: Symbol(.XLM, .USD))
    }
}
