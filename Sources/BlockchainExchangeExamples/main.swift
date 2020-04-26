import ArgumentParser

struct Examples: ParsableCommand {
    
    static var configuration = CommandConfiguration(
        abstract: "Subscription examples",
        version: "1.0.0",
        subcommands: [Authenticated.self, Anonymous.self],
        defaultSubcommand: Anonymous.self
    )
    
    struct Anonymous: ParsableCommand {
        
        static var configuration =
            CommandConfiguration(abstract: "Run the anonymous example.")
        
        func run() throws {
            AnonymousExample.run()
        }
    }
    
    struct Authenticated: ParsableCommand {
        
        static var configuration =
            CommandConfiguration(abstract: "Run the authenticated example.")
        
        @Option(help: "Authentication token.")
        var token: String
        
        func run() throws {
            AuthenticatedExample.run(with: token)
        }
    }
}

Examples.main()
