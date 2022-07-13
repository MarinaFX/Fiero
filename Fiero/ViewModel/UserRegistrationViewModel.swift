//
//  UserRegistrationViewModel.swift
//  Fiero
//
//  Created by Marina De Pazzi on 08/07/22.
//

import Foundation
import Combine


class UserRegistrationViewModel: ObservableObject {
    
    enum DatabaseResponse {
        case userCreated
        case badRequest
        case error
    }
        
    private let BASE_URL: String = "localhost"
    private let ENDPOINT: String = "/user/register"
    
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    func createUserOnDatabase(for user: User, completionHandler: @escaping (DatabaseResponse) -> ()) {
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
        
        URLSession.shared.dataTaskPublisher(for: request)
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
            }, receiveValue: { httpResponse in
                guard let response = httpResponse as? HTTPURLResponse else { return }
                print("status code: \(response.statusCode)")

                switch response.statusCode {
                    case 200:
                        return completionHandler(.userCreated)
                    case 400:
                        return completionHandler(.badRequest)
                    default:
                        return completionHandler(.error)
                }
            })
            .store(in: &cancellables)
    }
}
