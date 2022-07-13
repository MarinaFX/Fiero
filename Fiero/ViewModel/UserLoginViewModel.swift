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
    @Published private(set) var statusCode: Int

    private let BASE_URL: String = "localhost"
    private let ENDPOINT: String = "/user/login"
    
    private(set) var client: HTTPClient
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init(client: HTTPClient = URLSession.shared) {
        self.client = client
        self.user = User(email: "", name: "", password: "")
        self.statusCode = 0
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
            //.tryMap({ $0.data })
            //.decode(type: UserResponse.self, decoder: JSONDecoder())
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .failure(let error):
                        print("completion failed with: \(error.localizedDescription)")
                    case .finished:
                        print("finished successfully")
                }
            }, receiveValue: { [weak self] data, response in
                guard let response = response as? HTTPURLResponse else { return }
                
                switch response.statusCode {
                    case 200:
                        let userResponse = try! JSONDecoder().decode(UserResponse.self, from: data)
                        self?.user = userResponse.user
                        self?.user.token = userResponse.token
                        self?.statusCode = 200
                        
                    case 400:
                        self?.statusCode = 400
                        
                    case 403:
                        self?.statusCode = 403
                        
                    case 404:
                        self?.statusCode = 404
                        
                    case 500:
                        self?.statusCode = 500

                    default:
                        print(response.statusCode)
                }
            })
            .store(in: &cancellables)
    }
}

/**
    login register - Success = 200, login feito
    login register - BadRequest = 400, email ou senha errados
    login - Forbidden = 403, senha errada
    login - NotFound = 404, email valido, mas nao tem conta cadastrada = sem usuario cadastro com o email
    register - Conflict = 409, tenta criar uma conta com email que ja existe
    
    InternalServerError = 500 error
    Unauthorized = 401, sem uso ate o momento
 */

