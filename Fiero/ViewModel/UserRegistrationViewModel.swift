//
//  UserRegistrationViewModel.swift
//  Fiero
//
//  Created by Marina De Pazzi on 08/07/22.
//

import Foundation
import Combine

//MARK: UserRegistrationViewModel
class UserRegistrationViewModel: ObservableObject {
    //MARK: - Variables Setup
    @Published private(set) var serverResponse: ServerResponse
        
    private let BASE_URL: String = "localhost"
    private let ENDPOINT: String = "/user/register"
    
    private(set) var client: HTTPClient
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    //MARK: - Init
    init(client: HTTPClient = URLSession.shared) {
        self.client = client
        self.serverResponse = .unknown
    }
    
    //MARK: - Create Account
    func createUserOnDatabase(for user: User) {
        let userJSON: [String : String] = [
            "email": user.email,
            "name": user.name,
            "password": user.password!
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
            .tryMap({ $0.response })
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .failure(let error):
                        print("completion failed with: \(error.localizedDescription)")
                    case .finished:
                        print("finished successfully")
                }
            }, receiveValue: { [weak self] urlResponse in
                guard let response = urlResponse as? HTTPURLResponse else { return }
                print("status code: \(response.statusCode)")

                self?.serverResponse.statusCode = response.statusCode
            })
            .store(in: &cancellables)
    }
}
