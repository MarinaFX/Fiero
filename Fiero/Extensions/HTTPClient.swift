//
//  HTTPClient.swift
//  Fiero
//
//  Created by Marina De Pazzi on 13/07/22.
//

import Foundation
import Combine

protocol HTTPClient {
    func perform(for request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), Error>
}
