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
                    return .success(response)
                } else {
                    return .failure(httpUrlResponse, data)
                }
            })
            .mapError({ $0 as Error })
            .eraseToAnyPublisher()
    }
}
