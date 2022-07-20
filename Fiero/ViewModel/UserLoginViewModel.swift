//
//  UserLoginViewModel.swift
//  Fiero
//
//  Created by Marina De Pazzi on 08/07/22.
//

import Foundation
import Combine

//MARK: UserLoginViewModel
class UserLoginViewModel: ObservableObject {
    //MARK: - Variables Setup
    @Published private(set) var user: User
    @Published private(set) var serverResponse: ServerResponse

    private let BASE_URL: String = "localhost"
    private let ENDPOINT: String = "/user/login"
    
    private(set) var client: HTTPClient
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    //MARK: - Init
    init(client: HTTPClient = URLSession.shared) {
        self.client = client
        self.user = User(email: "", name: "", password: "")
        self.serverResponse = .unknown
    }
    
    //MARK: - AuthenticateUser
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
                    
                    let defaults = UserDefaults.standard
                    
                    defaults.set(self?.user.id, forKey: "userID")
                    defaults.set(self?.user.token, forKey: "AuthToken")
                }
                
                self?.serverResponse.statusCode = httpResponse.statusCode
                print(self?.user as Any)
                print(self?.serverResponse.statusCode as Any)
            })
            .store(in: &cancellables)
    }
}
