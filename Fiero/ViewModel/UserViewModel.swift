//
//  UserViewModel.swift
//  Fiero
//
//  Created by Marina De Pazzi on 08/07/22.
//

import Foundation
import Combine
import SwiftUI

enum ActiveAlert {
    case confirmAccountDelete, error
}

//MARK: UserViewModel
class UserViewModel: ObservableObject {
    //MARK: - Variables Setup
    @Published private(set) var user: User
    @Published var serverResponse: ServerResponse
    @Published var keyboardShown: Bool = false
    @Published var loginAlertCases: LoginAlertCases = .emptyFields
    @Published var registrationAlertCases: RegistrationAlertCases = .emptyFields
    @Published var isShowingLoading: Bool = false
    @Published var activeAlert: ActiveAlert?
    @Published var showingAlert = false
    @Published var isLogged = false

    private let BASE_URL: String = "localhost"
    //private let BASE_URL: String = "10.41.48.196"
    //private let BASE_URL: String = "ec2-54-233-77-56.sa-east-1.compute.amazonaws.com"
    private let ENDPOINT_SIGNUP: String = "/user/register"
    private let ENDPOINT_LOGIN: String = "/user/login"
    private let ENDPOINT_DELETE_USER: String = "/user"
    
    private(set) var client: HTTPClient
    private(set) var keyValueStorage: KeyValueStorage
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    //MARK: - Init
    init(client: HTTPClient = URLSession.shared, keyValueStorage: KeyValueStorage = UserDefaults.standard) {
        self.user = User(email: "", name: "", password: "")
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
    
    //MARK: - User Signup
    @discardableResult
    func signup(for user: User) -> AnyPublisher<Void, Error> {
        isShowingLoading = true
        let json = """
        {
            "email" : "\(user.email)",
            "name" : "\(user.name)",
            "password" : "\(user.password!)"
        }
        """
        
        let request = makePOSTRequest(json: json, scheme: "http", port: 3333, baseURL: self.BASE_URL, endPoint: self.ENDPOINT_SIGNUP, authToken: "")
        
        let operation = self.client.perform(for: request)
            .decodeHTTPResponse(type: UserSignupResponse.self, decoder: JSONDecoder())
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .share()
        
        operation
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .failure(let error):
                        print("completion failed with: \(error)")
                    case .finished:
                        print("finished successfully")
                }
            }, receiveValue: { [weak self] rawURLResponse in
                guard let response = rawURLResponse.item else {
                    self?.serverResponse.statusCode = rawURLResponse.statusCode
                    return
                }
                print("Signup status code: \(rawURLResponse.statusCode)")
                self?.keyValueStorage.set(response.user.id, forKey: UDKeys.userID.description)
                self?.keyValueStorage.set(response.user.name, forKey: UDKeys.username.description)
                self?.keyValueStorage.set(response.user.email, forKey: UDKeys.email.description)
                self?.keyValueStorage.set(user.password!, forKey: UDKeys.password.description)

                self?.serverResponse.statusCode = rawURLResponse.statusCode
            })
            .store(in: &cancellables)
        
        return operation
            .map({ _ in () })
            .mapError({ $0 as Error})
            .eraseToAnyPublisher()
    }
    
    //MARK: - User Login
    @discardableResult
    func login(email: String, password: String) -> AnyPublisher<Void, Error> {
        isShowingLoading = true
        let userJSON = """
        {
            "password" : "\(password)",
            "email" : "\(email)"
        }
        """
        
        let request = makePOSTRequest(json: userJSON, scheme: "http", port: 3333, baseURL: self.BASE_URL, endPoint: self.ENDPOINT_LOGIN, authToken: "")
        
        let operation = self.client.perform(for: request)
            .decodeHTTPResponse(type: UserLoginResponse.self, decoder: JSONDecoder())
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .share()
        
        operation
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .failure(let error):
                        print("completion failed with: \(error)")
                    case .finished:
                        print("finished successfully")
                }
            }, receiveValue: { [weak self] rawURLResponse in
                guard let response = rawURLResponse.item else {
                    self?.serverResponse.statusCode = rawURLResponse.statusCode
                    print(self?.user as Any)
                    print(self?.serverResponse.statusCode as Any)
                    
                    return
                }
                
                self?.user = response.user
                self?.user.token = response.token
                
                self?.keyValueStorage.set(self?.user.id, forKey: "userID")
                self?.keyValueStorage.set(self?.user.token, forKey: "AuthToken")
                
                self?.keyValueStorage.set(password, forKey: "password")
                self?.keyValueStorage.set(email, forKey: "email")
                self?.removeLoadingAnimation()
                self?.isLogged = true
                
            })
            .store(in: &cancellables)
        
        return operation
            .map({ _ in ()})
            .mapError({ $0 as Error})
            .eraseToAnyPublisher()
    }
    
    //MARK: - Delete Account
    func deleteAccount() -> AnyPublisher<Void, Error> {
        guard let userToken = self.keyValueStorage.string(forKey: "AuthToken") else {
            print("Nao foi possivel achar o token do usuario")
            
            return Empty()
                .eraseToAnyPublisher()
        }
        
        guard let userId = self.keyValueStorage.string(forKey: "userID") else {
            print("Nao foi possivel achar o ID do usuario")
            
            return Empty()
                .eraseToAnyPublisher()
        }
        
        let request = makeDELETERequest(param: userId, scheme: "http", port: 3333, baseURL: self.BASE_URL, endPoint: self.ENDPOINT_DELETE_USER, authToken: userToken)
        
        let operation = self.client.perform(for: request)
            .decodeHTTPResponse(type: UserDELETEResponse.self, decoder: JSONDecoder())
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .share()
        
        operation
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .failure(let error):
                        print("Error while performing request: \(error)")
                    case .finished:
                        print("Successfully performed request")
                }
            }, receiveValue: { [weak self] rawURLResponse in
                guard let _ = rawURLResponse.item else {
                    self?.serverResponse.statusCode = rawURLResponse.statusCode
                    self?.activeAlert = .error
                    return
                }
                
                self?.serverResponse.statusCode = rawURLResponse.statusCode
                self?.activeAlert = .confirmAccountDelete
            })
            .store(in: &cancellables)
        
        
        return operation
            .map({ _ in () })
            .mapError({ $0 as Error})
            .eraseToAnyPublisher()
    }
    
    func removeLoadingAnimation() {
        isShowingLoading = false
    }
    
    func showingAlertToFalse() {
        self.showingAlert = false
    }
    
    func showingAlertToTrue() {
        self.showingAlert = true
    }
    
    //MARK: STATIC FUNCTIONS
    //MARK: Getters
    static func getUserIDFromDefaults() -> String {
        return UserDefaults.standard.string(forKey: UDKeys.userID.description) ?? "no user id found"
    }
    
    static func getUserNameFromDefaults() -> String {
        return UserDefaults.standard.string(forKey: UDKeys.username.description) ?? "Alpaca Enfurecida"
    }
    
    static func getUserEmailFromDefaults() -> String {
        return UserDefaults.standard.string(forKey: UDKeys.username.description) ?? "no user email found"
    }
    
    static func getUserFromDefaults() -> User {
        return .init(email: getUserEmailFromDefaults(), name: getUserNameFromDefaults())
    }
    
    //MARK: Setters
    static func saveUserNameOnDefaults(name: String) {
        UserDefaults.standard.set(name, forKey: UDKeys.username.description)
    }
    
    static func saveUserCredentialsOnDefaults(for email: String, and password: String) {
        UserDefaults.standard.set(email, forKey: "email")
        UserDefaults.standard.set(password, forKey: "password")
    }
    
    func cleanDefaults() {
        UserDefaults.standard.set("", forKey: "email")
        UserDefaults.standard.set("", forKey: "password")
        UserDefaults.standard.set("", forKey: "AuthToken")
        UserDefaults.standard.set("", forKey: "userID")
    }
    
}
