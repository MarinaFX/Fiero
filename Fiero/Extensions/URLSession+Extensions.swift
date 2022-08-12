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

public func makeGETRequest
(
    scheme: String,
    port: Int,
    baseURL: String,
    endPoint: String,
    authToken: String
) -> URLRequest {
    var urlComponents = URLComponents()
    urlComponents.scheme = scheme
    urlComponents.port = port
    urlComponents.host = baseURL
    urlComponents.path = endPoint
    
    let url = urlComponents.url!
    var request = URLRequest(url: url)
    
    request.httpMethod = "GET"

    request.addValue(authToken, forHTTPHeaderField: "authToken")
    
    return request
}
extension UserDefaults: KeyValueStorage { }

public func makePOSTRequest
    (
        json: String,
        scheme: String,
        port: Int,
        baseURL: String,
        endPoint: String,
        authToken: String
    )
    -> URLRequest {
    let requestBody = json.data(using: .utf8)!
        
    var urlComponents = URLComponents()
    urlComponents.scheme = scheme
    urlComponents.port = port
    urlComponents.host = baseURL
    urlComponents.path = endPoint
    
    let url = urlComponents.url!
    var request = URLRequest(url: url)
    
    request.httpMethod = "POST"
    request.httpBody = requestBody

    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue(authToken, forHTTPHeaderField: "authToken")
    
    return request
}

public func makeDELETERequest
(
    param: String,
    scheme: String,
    port: Int,
    baseURL: String,
    endPoint: String,
    authToken: String
) -> URLRequest {
    var urlComponents = URLComponents()
    urlComponents.scheme = scheme
    urlComponents.port = port
    urlComponents.host = baseURL
    urlComponents.path = endPoint + "/\(param)"
    
    let url = urlComponents.url!
    var request = URLRequest(url: url)
    print(request.url?.absoluteString)
    request.httpMethod = "DELETE"

    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue(authToken, forHTTPHeaderField: "authToken")
    
    return request
}
