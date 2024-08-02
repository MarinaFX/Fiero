//
//  HTTPRequestFactory.swift
//  Fiero
//
//  Created by Marina De Pazzi on 27/07/24.
//

import Foundation


enum HTTPRequestType: String {
    case GET    = "GET"
    case POST   = "POST"
    case PATCH  = "PATCH"
    case DELETE = "DELETE"
}

protocol RequestFactory {
    func makeHTTPRequest(type: HTTPRequestType,
                         scheme: String,
                         port: Int,
                         host: String, path: String,
                         body: String?, authToken: String?)
    -> URLRequest
}

struct HTTPRequestFactory: RequestFactory {
    
    func makeHTTPRequest(type: HTTPRequestType,
                         scheme: String = "http",
                         port: Int = 3333,
                         host: String, path: String,
                         body: String? = nil, authToken: String? = nil)
    -> URLRequest{
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.port = port
        urlComponents.host = host
        urlComponents.path = path
        
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        
        request.httpMethod = type.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            let requestBody = body.data(using: .utf8)!
            request.httpBody = requestBody
        }
        
        if let authToken = authToken {
            request.addValue(authToken, forHTTPHeaderField: "authToken")
        }
        
        return request
    }
}
