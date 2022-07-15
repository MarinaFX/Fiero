//
//  UserLoginViewModel.swift
//  Fiero
//
//  Created by Marina De Pazzi on 08/07/22.
//

import Foundation
import Combine

class UserLoginViewModel: ObservableObject {
    
    @Published private(set) var user: User
    @Published private(set) var serverResponse: ServerResponse

    private let BASE_URL: String = "localhost"
    private let ENDPOINT: String = "/user/login"
    
    private(set) var client: HTTPClient
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init(client: HTTPClient = URLSession.shared) {
        self.client = client
        self.user = User(email: "", name: "", password: "")
        self.serverResponse = .unknown
    }
    
    func authenticateUser(email: String, password: String) {
        let userJSON: [String : String] = [
            "password": password,
            "email": email
        ]
        
        let requestBody = try? JSONSerialization.data(withJSONObject: userJSON)
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.port = 3333
        urlComponents.host = BASE_URL
        urlComponents.path = ENDPOINT
        
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.httpBody = requestBody

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        self.client.perform(for: request)
            .decodeHTTPResponse(type: UserResponse.self, decoder: JSONDecoder())
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .failure(let error):
                        print("completion failed with: \(error.localizedDescription)")
                    case .finished:
                        print("finished successfully")
                }
            }, receiveValue: { [weak self] httpResponse in
                if let userResponse = httpResponse.item {
                    self?.user = userResponse.user
                    self?.user.token = userResponse.token
                }
                
                self?.serverResponse.statusCode = httpResponse.statusCode
                print(self?.user as Any)
                print(self?.serverResponse.statusCode as Any)
            })
            .store(in: &cancellables)
    }
}

enum HTTPResult<Item> {
    case success(Item)
    case failure(HTTPURLResponse, Data)
    
    var item: Item? {
        if case .success(let item) = self {
            return item
        }
        
        return nil
    }
    
    var statusCode: Int {
        switch self {
            case .success:
                return 200
            case .failure(let httpUrlResponse, _):
                return httpUrlResponse.statusCode
        }
    }
}

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
