//
//  MockHTTPClient.swift
//  FieroTests
//
//  Created by Marina De Pazzi on 14/07/22.
//

import Foundation
import Combine
@testable import Fiero

class MockHTTPClient: HTTPClient {
    var url: String
    var statusCode: Int
    var json: String
    
    init (url: String, statusCode: Int, json: String) {
        self.url = url
        self.statusCode = statusCode
        self.json = json
    }
    
    func mock(url: String, statusCode: Int, json: String) {
        self.url = url
        self.statusCode = statusCode
        self.json = json
    }
    
    func perform(for request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), Error> {
        if request.url!.absoluteString.contains(url) {
            
            let jsonData = json.data(using: .utf8)!
            let response = HTTPURLResponse(url: request.url!, statusCode: statusCode, httpVersion: "1.1", headerFields: nil)!
            
            return Just((data: jsonData, response: response))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        return Empty()
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
