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
    
    func save<T>(_ type: T.Type, path: SaveOrigin, body: String) -> AnyPublisher<T, APIError> where T: Codable
    
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
                                                            host: FieroAPIEnum.BASE_URL.description,
                                                            path: path.value, body: nil, authToken: authToken)
                
                return self.client.perform(for: request)
            })
            .decodeHTTPResponse(type: APISingleResponse<T>.self, decoder: self.decoder)
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
    
    
    func fetch<T>(_ type: [T].Type = [T].self, path: FetchOrigin) -> AnyPublisher<[T], APIError> where T: Codable {
        return self.authClient.getAuthToken()
            .flatMap({ authToken in
                let request = self.requestClient.makeHTTPRequest(type: .GET, scheme: "http", port: 3333, host: FieroAPIEnum.BASE_URL.description, path: path.value, body: nil, authToken: authToken)
                
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
    func save<T>(_ type: T.Type = T.self, path: SaveOrigin, body: String) -> AnyPublisher<T, APIError> where T: Codable {
        return self.authClient.getAuthToken()
            .flatMap({ authToken in
                let request = self.requestClient.makeHTTPRequest(type: .POST, scheme: "http", port: 3333, host: FieroAPIEnum.BASE_URL.description, path: path.value, body: body, authToken: authToken)
                
                return self.client.perform(for: request)
            })
            .decodeHTTPResponse(type: APISingleResponse<T>.self, decoder: self.decoder)
            .tryMap({ rawURLResponse in
                guard let item = rawURLResponse.item else {
                    throw APIError(message: rawURLResponse.item?.message ?? "", timestamp: rawURLResponse.item?.timestamp ?? "")
                }
                
                guard let data = item.data else {
                    throw APIError(message: rawURLResponse.item?.message ?? "", timestamp: rawURLResponse.item?.timestamp ?? "")
                }
                
                return data
            })
            .mapError({ _ in APIError(message: "", timestamp: "") })
            .eraseToAnyPublisher()
    }
}


class TestViewModel: ObservableObject {
    @Published var challenge: QuickChallenge?
    @Published var challenges: [QuickChallenge] = []
    
    private var subscriptions = Set<AnyCancellable>()
    
    func testeSingleChallenge() {
        var service = CombineAPIServiceImpl()
        
//        service.fetch([QuickChallenge].self, path: .challenges)
//            .subscribe(on: DispatchQueue.global(qos: .background))
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { _ in }, receiveValue: { challenges in
//                print("funfou \(challenges)")
//                self.challenges = challenges
//            })
//            .store(in: &subscriptions)
        
//        let body = """
//        {
//            "name" : "Melhor de 3 contra baianinho de maua",
//            "type" : "amount",
//            "goal" : 3,
//            "goalMeasure" : "unity",
//            "online" : true,
//            "numberOfTeams" : 1,
//            "maxTeams" : 9999
//        }
//        """
//        
//        service.save(QuickChallenge.self, path: .challenge, body: body)
//            .subscribe(on: DispatchQueue.global(qos: .background))
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { _ in }, receiveValue: { quickChallenge in
//                print("funfou \(quickChallenge)")
//                self.challenge = quickChallenge
//            })
//            .store(in: &subscriptions)
    }
}
