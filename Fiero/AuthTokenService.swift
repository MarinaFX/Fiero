//
//  AuthTokenService.swift
//  Fiero
//
//  Created by Marina De Pazzi on 06/10/22.
//

import Foundation
import Combine

protocol AuthTokenService {
    func getAuthToken() -> AnyPublisher<String, Error>
}

class AuthTokenServiceImpl: AuthTokenService {
    private let keyValueStorage: KeyValueStorage
    private let client: HTTPClient
    private var cancellables: Set<AnyCancellable> = []
    
    init(keyValueStorage: KeyValueStorage = UserDefaults.standard, client: HTTPClient = URLSession.shared) {
        self.keyValueStorage = keyValueStorage
        self.client = client
    }
    
    func getAuthToken() -> AnyPublisher<String, Error> {
        guard let authToken = self.keyValueStorage.string(forKey: UDKeysEnum.authToken.description) else {
            return requestUpdatedAuthToken()
        }
        
        guard let payload = authToken.split(separator: ".").dropFirst().first,
              let decodedPayload = Data.fromBase64(String(payload)),
              let jsonPayload = try? JSONSerialization.jsonObject(with: decodedPayload) as? [String: Any],
              let exp = jsonPayload["exp"] as? Int else {
            return requestUpdatedAuthToken()
        }
        
        let expDate = Date(timeIntervalSince1970: Double(exp))
        let now = Date()
        let distance = abs(expDate.timeIntervalSince1970 - now.timeIntervalSince1970)
        
        if expDate < now || distance <= 120 {
            return requestUpdatedAuthToken()
        } else {
            return Just(authToken)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    private func requestUpdatedAuthToken() -> AnyPublisher<String, Error> {
        guard let email = self.keyValueStorage.string(forKey: UDKeysEnum.email.description),
              let password = self.keyValueStorage.string(forKey: UDKeysEnum.password.description) else {
            
            let error = NSError(domain: "fiero", code: -1)
            return Fail(outputType: String.self, failure: error as Error).eraseToAnyPublisher()
        }
        
        let json = """
        {
            "email" : "\(email)",
            "password" : "\(password)"
        }
        """
        
        let request = makePOSTRequest(json: json, scheme: "http", port: 3333,
                                      baseURL: FieroAPIEnum.BASE_URL.description,
                                      endPoint: UserEndpointEnum.TOKEN.description,
                                      authToken: "")
        
        let operation = self.client.perform(for: request)
            .decodeHTTPResponse(type: UserTokenResponse.self, decoder: JSONDecoder())
            .compactMap { $0.item?.token }
            .share()
        
        operation
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                    case .failure(let error):
                        self?.keyValueStorage.set(nil, forKey: UDKeysEnum.authToken.description)
                        print("Failed to create request to fetch token endpoint: \(error)")
                    case .finished:
                        print("Successfully created request to fetch token endpoint")
                }
            }, receiveValue: { [weak self] token in
                print("Successfully generated new token")
                self?.keyValueStorage.set(token, forKey: UDKeysEnum.authToken.description)
            })
            .store(in: &cancellables)
        
        return operation.eraseToAnyPublisher()
    }
}
