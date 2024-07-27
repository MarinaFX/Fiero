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

protocol KeyValueStorage {
    func string(forKey defaultName: String) -> String?
    
    func set(_ value: Any?, forKey defaultName: String)
}
