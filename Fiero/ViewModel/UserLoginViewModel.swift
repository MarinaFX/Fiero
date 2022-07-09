//
//  UserLoginViewModel.swift
//  Fiero
//
//  Created by Marina De Pazzi on 08/07/22.
//

import Foundation
import Combine


class UserLoginViewModel: ObservableObject {
    
    @Published var user: User?
    
    private let BASE_URL: String = "localhost"
    private let ENDPOINT: String = "/user/register"
    
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    func createUser(user: User) {
        let userJSON: [String : String] = [
            "email": user.email,
            "name": user.name,
            "password": user.password
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
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap( { $0.data })
            .decode(type: UserReponse.self, decoder: JSONDecoder())
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .failure(let error):
                        print("completion failed with: \(error.localizedDescription)")
                    case .finished:
                        print("finished successfully")
                }
            }, receiveValue: { [weak self] userResponse in
                self?.user = userResponse.user
            })
            .store(in: &cancellables)
    }
}
