//
//  APIService.swift
//  Fiero
//
//  Created by Marina De Pazzi on 27/07/24.
//

import Foundation
import Combine

protocol CombineAPIService {
    associatedtype Client
    associatedtype StorageClient
    associatedtype AuthClient
    associatedtype RequestClient
    
    associatedtype Decoder
    
    var client: Client { get set }
    var storageClient: StorageClient { get set }
    var authClient: AuthClient { get set }
    var requestClient: RequestClient { get set }
    var decoder: Decoder { get set }
    
    init(client: Client, storageClient: StorageClient, authClient: AuthClient, requestClient: RequestClient, decoder: Decoder)
    init()
    
    func fetch<T>(_ type: T.Type, path: FetchOrigin) -> AnyPublisher<T, APIError> where T: Codable
    
    func fetch<T>(_ type: [T].Type, path: FetchOrigin) -> AnyPublisher<[T], APIError> where T: Codable
    
    func save<T>(_ type: T.Type, path: SaveOrigin, body: String?) -> AnyPublisher<T, APIError> where T: Codable
    
}

struct CombineAPIServiceImpl: CombineAPIService {
    typealias Client = HTTPClient
    typealias StorageClient = KeyValueStorage
    typealias AuthClient = AuthTokenService
    typealias RequestClient = RequestFactory
    
    typealias Decoder = DecoderClient
    
    var client: Client
    var storageClient: StorageClient
    var authClient: AuthClient
    var requestClient: RequestClient
    
    var decoder: any Decoder
        
    init(client: any Client = URLSession.shared,
         storageClient: any StorageClient = UserDefaults.standard,
         authClient: any AuthClient = AuthTokenServiceImpl(),
         requestClient: any RequestFactory = HTTPRequestFactory(),
         decoder: any Decoder = JSONDecoder()) {
        self.client = client
        self.storageClient = storageClient
        self.authClient = authClient
        self.requestClient = requestClient
        self.decoder = decoder
    }
    
    init() {
        self.client = URLSession.shared
        self.storageClient = UserDefaults.standard
        self.authClient = AuthTokenServiceImpl()
        self.requestClient = HTTPRequestFactory()
        self.decoder = JSONDecoder()
    }
}

extension CombineAPIServiceImpl {
    func fetch<T>(_ type: T.Type = T.self, path: FetchOrigin) -> AnyPublisher<T, APIError> where T: Codable {
        return self.authClient.getAuthToken()
            .flatMap({ authToken in
                let request = self.requestClient.makeHTTPRequest(type: .GET, scheme: "http", port: 3333,
                                                            host: FieroAPIEnum.host.description,
                                                            path: path.value, body: nil, authToken: authToken)
                
                return self.client.perform(for: request)
            })
            .decodeHTTPResponse(type: APISingleResponse<T>.self, decoder: self.decoder)
            .parseURLResponse()
            .eraseToAnyPublisher()
    }
    
    
    func fetch<T>(_ type: [T].Type = [T].self, path: FetchOrigin) -> AnyPublisher<[T], APIError> where T: Codable {
        return self.authClient.getAuthToken()
            .flatMap({ authToken in
                let request = self.requestClient.makeHTTPRequest(type: .GET, scheme: "http", port: 3333, host: FieroAPIEnum.host.description, path: path.value, body: nil, authToken: authToken)
                
                return self.client.perform(for: request)
            })
            .decodeHTTPResponse(type: APIPluralResponse<T>.self, decoder: self.decoder)
            .tryMap({ rawURLResponse in
                guard let item = rawURLResponse.item else {
                    throw APIError(message: rawURLResponse.item?.message ?? "", timestamp: rawURLResponse.item?.timestamp ?? "")
                }
                
                guard let data = item.data else {
                    throw APIError(message: rawURLResponse.item?.message ?? "", timestamp: rawURLResponse.item?.timestamp ?? "")
                }
                
                return data
            })
            .mapError({ _ in APIError(message: "Error while trying to map error -- ", timestamp: "\(Date.now)") })
            .eraseToAnyPublisher()
    }
}

extension CombineAPIServiceImpl {
    func save<T>(_ type: T.Type = T.self, path: SaveOrigin, body: String? = nil) -> AnyPublisher<T, APIError> where T: Codable {
        return self.authClient.getAuthToken()
            .flatMap({ authToken in
                let request = self.requestClient.makeHTTPRequest(type: .POST, scheme: "http", port: 3333, host: FieroAPIEnum.host.description, path: path.value, body: body, authToken: authToken)
                
                return self.client.perform(for: request)
            })
            .decodeHTTPResponse(type: APISingleResponse<T>.self, decoder: self.decoder)
            .parseURLResponse()
            .eraseToAnyPublisher()
    }
}

extension CombineAPIServiceImpl {
    func update<T>(_ type: T.Type = T.self, path: UpdateOrigin, body: String? = nil) -> AnyPublisher<T, APIError> where T: Codable {
        return self.authClient.getAuthToken()
            .flatMap({ authToken in
                let request = self.requestClient.makeHTTPRequest(type: .PATCH, scheme: "http", port: 3333, host: FieroAPIEnum.host.description, path: path.value, body: body, authToken: authToken)
                
                return self.client.perform(for: request)
            })
            .decodeHTTPResponse(type: APISingleResponse<T>.self, decoder: self.decoder)
            .parseURLResponse()
            .eraseToAnyPublisher()
    }
}

extension CombineAPIServiceImpl {
    func delete<T>(_ type: T.Type = T.self, path: DeleteOrigin, body: String? = nil) -> AnyPublisher<T, APIError> where T: Codable {
        return self.authClient.getAuthToken()
            .flatMap({ authToken in
                let request = self.requestClient.makeHTTPRequest(type: .DELETE, scheme: "http", port: 3333, host: FieroAPIEnum.host.description, path: path.value, body: body, authToken: authToken)
                
                return self.client.perform(for: request)
            })
            .print("antes do decode")
            .decodeHTTPResponse(type: APISingleResponse<T>.self, decoder: self.decoder)
            .print("depois do decode")
            .tryMap({ rawURLResponse in
                switch rawURLResponse {
                    case .success(let item, _), .created(let item, _):
                        guard let data = item.data else {
                            throw APIError(message: "Error while trying to map data from item in response. API did not return a compatible type", timestamp: rawURLResponse.item?.timestamp ?? "\(Date.now.ISO8601Format(.iso8601))")
                        }
                        
                        guard let message = item.message else {
                            throw APIError(message: "Error while trying to map message from item in response. API did not return a compatible message", timestamp: rawURLResponse.item?.timestamp ?? "\(Date.now.ISO8601Format(.iso8601))")
                        }
                        
                        if message.contains("successful.") {
                            return data
                        }
                        else {
                            throw APIError(message: "Error while trying to verify message from item in response. API did not return a compatible message", timestamp: rawURLResponse.item?.timestamp ?? "\(Date.now.ISO8601Format(.iso8601))")
                        }
                    
                    case .failure(let item, let statusCode):
                        throw APIError(message: item.message ?? "Error while trying to map failure from response. API did not return a compatible error", timestamp: item.timestamp)
                }
            })
            .mapError({ _ in APIError(message: "", timestamp: "") })
            .eraseToAnyPublisher()
    }
}
