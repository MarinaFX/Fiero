//
//  URLSession+Extensions.swift
//  Fiero
//
//  Created by Marina De Pazzi on 13/07/22.
//

import Foundation
import Combine

extension URLSession: HTTPClient {
    func perform(for request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), Error> {
        dataTaskPublisher(for: request)
            .mapError({ $0 as Error })
            .eraseToAnyPublisher()
    }
}
