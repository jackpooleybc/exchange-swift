//
//  SocketEngine.swift
//  AnyCodable
//
//  Created by Jack on 26/04/2020.
//

import Foundation

public protocol SocketEngine {
    
    func start()
    
    func stop()
    
    func send<R: Request>(request: R, completion: (() -> Void)?)
}
