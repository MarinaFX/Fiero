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
    
    var client: Client { get set }
    var storageClient: StorageClient { get set }
    var authClient: AuthClient { get set }
    var requestClient: RequestClient { get set }
    
    init(client: Client, storageClient: StorageClient, authClient: AuthClient, requestClient: RequestClient)
    init()
    
    func fetch<T>(_ type: T.Type, path: FetchOrigin) -> AnyPublisher<T, APIError> where T: Codable
    
}

struct CombineAPIServiceImpl: CombineAPIService {
    typealias Client = HTTPClient
    typealias StorageClient = KeyValueStorage
    typealias AuthClient = AuthTokenService
    typealias RequestClient = RequestFactory
    
    var client: any Client
    var storageClient: any StorageClient
    var authClient: AuthClient
    var requestClient: RequestClient
    
    init(client: any Client = URLSession.shared,
         storageClient: any StorageClient = UserDefaults.standard,
         authClient: any AuthClient = AuthTokenServiceImpl(),
         requestClient: any RequestFactory = HTTPRequestFactory()) {
        self.client = client
        self.storageClient = storageClient
        self.authClient = authClient
        self.requestClient = requestClient
    }
    
    init() {
        self.client = URLSession.shared
        self.storageClient = UserDefaults.standard
        self.authClient = AuthTokenServiceImpl()
        self.requestClient = HTTPRequestFactory()
    }
    
    func fetch<T>(_ type: T.Type = T.self, path: FetchOrigin) -> AnyPublisher<T, APIError> where T: Codable {
        return self.authClient.getAuthToken()
            .flatMap({ authToken in
                let request = self.requestClient.makeHTTPRequest(type: .GET, scheme: "http", port: 3333,
                                                            host: FieroAPIEnum.BASE_URL.description,
                                                            path: path.value, body: nil, authToken: authToken)
                
                return self.client.perform(for: request)
            })
            .decodeHTTPResponse(type: APISingleResponse<T>.self, decoder: JSONDecoder())
            .tryMap({ rawURLResponse in
                guard let item = rawURLResponse.item else {
                    throw APIError(message: rawURLResponse.item?.message ?? "", timestamp: rawURLResponse.item?.timestamp ?? "")
                }
                
                guard let data = item.data else {
                    throw APIError(message: rawURLResponse.item?.message ?? "", timestamp: rawURLResponse.item?.timestamp ?? "")
                }
                
                return data
            })
            .mapError({ $0 as! APIError })
            .eraseToAnyPublisher()
    }
    
    
    func fetch<T>(_ type: [T].Type = [T].self, path: FetchOrigin) -> AnyPublisher<[T], APIError> where T: Codable {
        return self.authClient.getAuthToken()
            .flatMap({ authToken in
                let request = self.requestClient.makeHTTPRequest(type: .GET, scheme: "http", port: 3333, host: FieroAPIEnum.BASE_URL.description, path: path.value, body: nil, authToken: authToken)
                
                return self.client.perform(for: request)
            })
            .decodeHTTPResponse(type: APIPluralResponse<T>.self, decoder: JSONDecoder())
            .tryMap({ rawURLResponse in
                guard let item = rawURLResponse.item else {
                    throw APIError(message: rawURLResponse.item?.message ?? "", timestamp: rawURLResponse.item?.timestamp ?? "")
                }
                
                guard let data = item.data else {
                    throw APIError(message: rawURLResponse.item?.message ?? "", timestamp: rawURLResponse.item?.timestamp ?? "")
                }
                
                return data
            })
            .mapError({ $0 as! APIError })
            .eraseToAnyPublisher()
    }
}


class TestViewModel: ObservableObject {
    @Published var challenge: QuickChallenge?
    @Published var challenges: [QuickChallenge] = []
    
    private var subscriptions = Set<AnyCancellable>()
    
    func testeSingleChallenge() {
        var service = CombineAPIServiceImpl()
        
        service.fetch([QuickChallenge].self, path: .challenges)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { challenges in
                print("funfou \(challenges)")
                self.challenges = challenges
            })
            .store(in: &subscriptions)
    }
}
