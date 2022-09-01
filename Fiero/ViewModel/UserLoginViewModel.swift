//
//  UserLoginViewModel.swift
//  Fiero
//
//  Created by Marina De Pazzi on 08/07/22.
//

import Foundation
import Combine
import SwiftUI

//MARK: UserLoginViewModel
class UserLoginViewModel: ObservableObject {
    //MARK: - Variables Setup
    @Published private(set) var user: User
    @Published var serverResponse: ServerResponse
    @Published var loginAlertCases: LoginAlertCases = .emptyFields
    @Published var isShowingLoading: Bool = false

    //private let BASE_URL: String = "localhost"
    //private let BASE_URL: String = "10.41.48.196"
    private let BASE_URL: String = "ec2-54-233-77-56.sa-east-1.compute.amazonaws.com"
    private let ENDPOINT: String = "/user/login"
    
    private(set) var client: HTTPClient
    private(set) var keyValueStorage: KeyValueStorage
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    @Published var keyboardShown: Bool = false
    
    //MARK: - Init
    init(client: HTTPClient = URLSession.shared, keyValueStorage: KeyValueStorage = UserDefaults.standard) {
        self.client = client
        self.user = User(email: "", name: "", password: "")
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
    
    //MARK: - AuthenticateUser
    func authenticateUser(email: String, password: String) {
        isShowingLoading = true
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
                    
                    self?.keyValueStorage.set(self?.user.id, forKey: "userID")
                    self?.keyValueStorage.set(self?.user.token, forKey: "AuthToken")
                    
                    if self?.serverResponse.statusCode == 200 || self?.serverResponse.statusCode == 201 {
                        self?.keyValueStorage.set(password, forKey: "password")
                        self?.keyValueStorage.set(email, forKey: "email")
                        self?.removeLoadingAnimation()
                    }
                }
                
                self?.serverResponse.statusCode = httpResponse.statusCode
                print(self?.user as Any)
                print(self?.serverResponse.statusCode as Any)
            })
            .store(in: &cancellables)
    }
    
    func setUserOnDefaults(email: String, password: String) {
        self.keyValueStorage.set(email, forKey: "email")
        self.keyValueStorage.set(password, forKey: "password")
    }
    
    func getUserFromDefaults() -> (email: String?, password: String?) {
        return (self.keyValueStorage.string(forKey: "email"), self.keyValueStorage.string(forKey: "password"))
    }
    
    func removeLoadingAnimation() {
        isShowingLoading = false
    }
}
