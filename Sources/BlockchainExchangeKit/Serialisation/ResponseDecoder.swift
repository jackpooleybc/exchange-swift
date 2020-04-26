//
//  ResponseDecoder.swift
//  AnyCodable
//
//  Created by Jack on 26/04/2020.
//

import Foundation
import AnyCodable

enum DecoderError: Error {
    case decodeFailed
}

extension CodingUserInfoKey {
    
    static let info = CodingUserInfoKey(rawValue: "info")!
}

final class MessageInfo {
    
    let data: Data
    let json: [String: Any]
    let channel: Channel
    let eventType: EventType
    
    init(data: Data) throws {
        guard let json = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: Any] else {
            throw DecoderError.decodeFailed
        }
        guard let channelString = json["channel"] as? String, let channel = Channel(rawValue: channelString) else {
            throw DecoderError.decodeFailed
        }
        guard let eventTypeString = json["event"] as? String, let eventType = EventType(rawValue: eventTypeString) else {
            throw DecoderError.decodeFailed
        }
        self.data = data
        self.json = json
        self.channel = channel
        self.eventType = eventType
    }
}

protocol MessageDecoder {
    
    func decode(response: String) -> Result<Event, DecoderError>
}

final class ResponseDecoder: MessageDecoder {
    
    private let decoder: JSONDecoder
    
    init() {
        self.decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func decode(response: String) -> Result<Event, DecoderError> {
        guard let data = response.data(using: .utf8) else {
            return .failure(.decodeFailed)
        }
        return Result { try MessageInfo(data: data) }
            .mapError { _ in DecoderError.decodeFailed }
            .flatMap { info -> Result<Event, DecoderError> in
                decoder.userInfo[.info] = info
                guard let decoded = try? decoder.decode(Event.self, from: data) else {
                    return .failure(.decodeFailed)
                }
                return .success(decoded)
            }
    }
}


