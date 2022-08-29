//
//  UserRegistrationViewModel.swift
//  Fiero
//
//  Created by Marina De Pazzi on 08/07/22.
//

import Foundation
import Combine
import SwiftUI

//MARK: UserRegistrationViewModel
class UserRegistrationViewModel: ObservableObject {
    //MARK: - Variables Setup
    @Published private(set) var serverResponse: ServerResponse
    @Published var keyboardShown: Bool = false
        
    private let BASE_URL: String = "localhost"
    //private let BASE_URL: String = "10.41.48.196"
    //private let BASE_URL: String = "ec2-54-233-77-56.sa-east-1.compute.amazonaws.com"
    private let ENDPOINT: String = "/user/register"
    
    private(set) var client: HTTPClient
    private(set) var keyValueStorage: KeyValueStorage
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    //MARK: - Init
    init(client: HTTPClient = URLSession.shared, keyValueStorage: KeyValueStorage = UserDefaults.standard) {
        self.client = client
        self.serverResponse = .unknown
        self.keyValueStorage = keyValueStorage
    }
    
    //MARK: - Keyboard Detection
    func onKeyboardDidSHow() {
        withAnimation() { keyboardShown = true }
    }
    
    func onKeyboardDidHide() {
        withAnimation() { keyboardShown = false }
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
    
    func saveUserOnUserDefaults(name: String) {
        self.keyValueStorage.set(name, forKey: "name")
    }
    
    func getUserOnUserDefaults() -> String {
        self.keyValueStorage.string(forKey: "name") ?? "Alpaca Enfurecida"
    }
}
