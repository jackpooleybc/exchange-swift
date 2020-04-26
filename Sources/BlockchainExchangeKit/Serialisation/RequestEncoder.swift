//
//  RequestEncoder.swift
//  AnyCodable
//
//  Created by Jack on 26/04/2020.
//

import Foundation

enum EncodingError: Error {
    case encodingFailed
}

protocol MessageEncoder {
    
    func encode<R: Request>(request: R) -> Result<String, EncodingError>
}

final class RequestEncoder: MessageEncoder {
    
    private let encoder = JSONEncoder()
    
    func encode<R: Request>(request: R) -> Result<String, EncodingError> {
        Result { try JSONEncoder().encode(request) }
            .mapError { _ in EncodingError.encodingFailed }
            .flatMap { encodedRequest -> Result<String, EncodingError> in
                guard let encodedRequestString = String(data: encodedRequest, encoding: .utf8) else {
                    return .failure(.encodingFailed)
                }
                return .success(encodedRequestString)
            }
    }
}
