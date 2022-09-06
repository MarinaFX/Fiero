//
//  UserSignupViewModel.swift
//  Fiero
//
//  Created by Marina De Pazzi on 08/07/22.
//

import Foundation
import Combine
import SwiftUI

//MARK: UserSignupViewModel
class UserSignupViewModel: ObservableObject {
    //MARK: - Variables Setup
    @Published var serverResponse: ServerResponse
    @Published var keyboardShown: Bool = false
    @Published var registrationAlertCases: RegistrationAlertCases = .emptyFields
    @Published var isShowingLoading: Bool = false
        
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
        isShowingLoading = true
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
            .decodeHTTPResponse(type: UserLoginResponse.self, decoder: JSONDecoder())
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .failure(let error):
                        print("completion failed with: \(error.localizedDescription)")
                    case .finished:
                        print("finished successfully")
                }
            }, receiveValue: { [weak self] rawURLResponse in
                guard let response = rawURLResponse.item else {
                    self?.serverResponse.statusCode = rawURLResponse.statusCode
                    return
                }
                print("Signup status code: \(rawURLResponse.statusCode)")
                self?.keyValueStorage.set(response.user.id, forKey: "userId")
                self?.keyValueStorage.set(response.user.name, forKey: "name")
                self?.keyValueStorage.set(response.user.email, forKey: "email")

                self?.serverResponse.statusCode = rawURLResponse.statusCode
            })
            .store(in: &cancellables)
    }
    
    func removeLoadingAnimation() {
        isShowingLoading = false
    }
    
    //MARK: STATIC FUNCTIONS
    func getUserName() -> String {
        return keyValueStorage.string(forKey: "name") ?? "Alpaca Enfurecida"
    }
    
    func getUserId() -> String {
        return keyValueStorage.string(forKey: "userId") ?? "no user id found"
    }
    
    func saveUserOnUserDefaults(name: String) {
        return keyValueStorage.set(name, forKey: "name")
    }
    
}
