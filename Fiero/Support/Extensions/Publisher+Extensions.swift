//
//  Publisher+Extensions.swift
//  Fiero
//
//  Created by Marina De Pazzi on 15/07/22.
//

import Foundation
import Combine

extension Publisher where Output == (data: Data, response: URLResponse) {
    func decodeHTTPResponse<Item, Coder>(
        type: Item.Type,
        decoder: Coder)
    -> AnyPublisher<HTTPResult<Item>, Error>
        where Item: Decodable, Coder: TopLevelDecoder, Coder.Input == Data
    {
        self
            .tryMap({ (data: Data, response: URLResponse) -> HTTPResult<Item> in
                guard let httpUrlResponse = response as? HTTPURLResponse else {
                    fatalError()
                }
                
                if httpUrlResponse.statusCode == 200 {
                    let response = try decoder.decode(Item.self, from: data)
                    return .success(response, 200)
                }
                
                if httpUrlResponse.statusCode == 201 {
                    let response = try decoder.decode(Item.self, from: data)
                    return .created(response, 201)
                }
                
                let response = try decoder.decode(Item.self, from: data)
                return .failure(response, httpUrlResponse.statusCode)
                
            })
            .mapError({ $0 as Error })
            .eraseToAnyPublisher()
    }
}

extension Publisher {
    func parseURLResponse<Item, Failure>()
    -> AnyPublisher<Item, Failure>
    where Item: Decodable, Failure: APIErrorConvertible, Output == HTTPResult<APISingleResponse<Item>>
    {
        self.tryMap { rawURLResponse in
            switch rawURLResponse {
                case .success(let item, _), .created(let item, _):
                    guard let data = item.data else {
                        throw Failure(message: "Error while trying to map data from item in response. API did not return a compatible error", timestamp: rawURLResponse.item?.timestamp ?? "\(Date.now.ISO8601Format(.iso8601))")
                    }
                    
                    return data
                
                case .failure(let item, let statusCode):
                    throw Failure(message: item.message ?? "Error while trying to map failure from response. API did not return a compatible error", timestamp: item.timestamp)
            }
        }
        .mapError({ Failure(message: "Error while trying to map error -- \($0.localizedDescription)", timestamp: "\(Date.now)") })
        .eraseToAnyPublisher()
    }
}
