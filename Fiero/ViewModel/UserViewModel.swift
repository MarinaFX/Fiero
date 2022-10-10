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
    case confirmAccountDelete, error, logOut
}

//MARK: UserViewModel
class UserViewModel: ObservableObject {
    //MARK: - Variables Setup
    @Published private(set) var user: User
    @Published var keyboardShown: Bool = false
    @Published var loginAlertCases: LoginAlertCases = .emptyFields
    @Published var isShowingLoading: Bool = false
    @Published var activeAlert: ActiveAlert?
    @Published var showingAlert = false
    @Published var isLogged = false

    private(set) var client: HTTPClient
    private(set) var keyValueStorage: KeyValueStorage
    private(set) var authTokenService: AuthTokenService
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    //MARK: - Init
    init(client: HTTPClient = URLSession.shared,
         keyValueStorage: KeyValueStorage = UserDefaults.standard,
         authTokenService: AuthTokenService = AuthTokenServiceImpl()) {
        self.user = User(email: "", name: "", password: "")
        self.client = client
        self.keyValueStorage = keyValueStorage
        self.authTokenService = authTokenService
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
        DispatchQueue.main.async {
            self.isShowingLoading = true
        }
        
        let json = """
        {
            "email" : "\(user.email)",
            "name" : "\(user.name)",
            "password" : "\(user.password!)"
        }
        """
        
        let request = makePOSTRequest(json: json, scheme: "http", port: 3333,
                                      baseURL: FieroAPIEnum.BASE_URL.description,
                                      endPoint: UserEndpointEnum.SIGNUP.description,
                                      authToken: "")
        
        let operation = self.client.perform(for: request)
            .decodeHTTPResponse(type: UserLoginResponse.self, decoder: JSONDecoder())
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .share()
        
        operation
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                    case .failure(let error):
                        print("Failed to create request to signup endpoint: \(error)")
                        self?.loginAlertCases = .connectionError
                        self?.isShowingLoading = false
                    case .finished:
                        print("Successfully created request to signup endpoint")
                }
            }, receiveValue: { [weak self] rawURLResponse in
                guard let response = rawURLResponse.item else {
                    print("Error when trying to create account: \(rawURLResponse.statusCode)")
                    
                    switch rawURLResponse.statusCode {
                        case 400:
                            self?.loginAlertCases = .invalidEmail
                        case 409:
                            self?.loginAlertCases = .accountAlreadyExists
                        case 500:
                            self?.loginAlertCases = .connectionError
                        default:
                            self?.loginAlertCases = .connectionError
                    }
                    self?.isShowingLoading = false
                    return
                }
                print("Successfully created account: \(rawURLResponse.statusCode)")
                self?.keyValueStorage.set(response.token, forKey: UDKeys.authToken.description)
                self?.keyValueStorage.set(response.user.id, forKey: UDKeys.userID.description)
                self?.keyValueStorage.set(response.user.name, forKey: UDKeys.username.description)
                self?.keyValueStorage.set(response.user.email, forKey: UDKeys.email.description)
                self?.keyValueStorage.set(user.password!, forKey: UDKeys.password.description)

                self?.isShowingLoading = false
                self?.isLogged = true
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
        DispatchQueue.main.async {
            self.isShowingLoading = true
        }
        
        let userJSON = """
        {
            "password" : "\(password)",
            "email" : "\(email)"
        }
        """
        
        let request = makePOSTRequest(json: userJSON, scheme: "http", port: 3333,
                                      baseURL: FieroAPIEnum.BASE_URL.description,
                                      endPoint: UserEndpointEnum.LOGIN.description,
                                      authToken: "")
        
        let operation = self.client.perform(for: request)
            .decodeHTTPResponse(type: UserLoginResponse.self, decoder: JSONDecoder())
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .share()
        
        operation
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                    case .failure(let error):
                        print("Failed to create request to login endpoint: \(error)")
                        self?.loginAlertCases = .connectionError
                        self?.isShowingLoading = false
                    case .finished:
                        print("Successfully created request to login endpoint")
                }
            }, receiveValue: { [weak self] rawURLResponse in
                guard let response = rawURLResponse.item else {
                    print("Error while trying to login: \(rawURLResponse.statusCode)")
                    
                    switch rawURLResponse.statusCode {
                        case 400:
                            self?.loginAlertCases = .invalidEmail
                        case 403:
                            self?.loginAlertCases = .wrongCredentials
                        case 404:
                            self?.loginAlertCases = .emailNotRegistrated
                        case 500:
                            self?.loginAlertCases = .connectionError
                        default:
                            self?.loginAlertCases = .connectionError
                    }
                    self?.isShowingLoading = false
                    
                    return
                }
                print("Successfully logged in: \(rawURLResponse.statusCode)")
                self?.user = response.user
                self?.user.token = response.token
                
                self?.keyValueStorage.set(self?.user.id, forKey: UDKeys.userID.description)
                self?.keyValueStorage.set(self?.user.token, forKey: UDKeys.authToken.description)
                self?.keyValueStorage.set(password, forKey: UDKeys.password.description)
                self?.keyValueStorage.set(email, forKey: UDKeys.email.description)
                
                self?.isShowingLoading = false
                self?.isLogged = true
                
            })
            .store(in: &cancellables)
        
        return operation
            .map({ _ in ()})
            .mapError({ $0 as Error})
            .eraseToAnyPublisher()
    }
    
    //MARK: - Delete Account
    @discardableResult
    func deleteAccount() -> AnyPublisher<Void, Error> {
        guard let userId = self.keyValueStorage.string(forKey: UDKeys.userID.description) else {
            print("Nao foi possivel achar o ID do usuario")
            
            return Empty()
                .eraseToAnyPublisher()
        }
        
        let operation = self.authTokenService.getAuthToken()
            .flatMap({ authToken in
                let request = makeDELETERequest(param: userId, scheme: "http", port: 3333,
                                                baseURL: FieroAPIEnum.BASE_URL.description,
                                                endPoint: UserEndpointEnum.DELETE_USER.description,
                                                authToken: authToken)
                
                return self.client.perform(for: request)
            })
            .decodeHTTPResponse(type: UserDELETEResponse.self, decoder: JSONDecoder())
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .share()
        
        operation
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .failure(let error):
                        print("Error to create delete account request: \(error)")
                    case .finished:
                        print("Successfully created delete account request")
                }
            }, receiveValue: { [weak self] rawURLResponse in
                guard let _ = rawURLResponse.item else {
                    print("Error when trying to delete account: \(rawURLResponse.statusCode)")
                    self?.activeAlert = .error
                    return
                }
                print("Successfully deleted account: \(rawURLResponse.statusCode)")
                self?.activeAlert = .confirmAccountDelete
            })
            .store(in: &cancellables)
        
        
        return operation
            .map({ _ in () })
            .mapError({ $0 as Error})
            .eraseToAnyPublisher()
    }
    
    @discardableResult
    func sendVerificationCode(for email: String) -> AnyPublisher<Void, Error> {
        let json = """
        {
            "email" : "\(email)"
        }
        """
        
        let request = makePOSTRequest(json: json, scheme: "http", port: 3333, baseURL: FieroAPIEnum.BASE_URL.description, endPoint: UserEndpointEnum.VERIFICATION_CODE.description, authToken: "")
        
        let operation = self.client.perform(for: request)
            .tryMap({ $1 as? HTTPURLResponse })
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .share()
        
        operation
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .failure(let error):
                        print("Failed to create request to verificationCode endpoint: \(error)")
                    case .finished:
                        print("Successfully created request to signup endpoint")
                }
            }, receiveValue: { response in
                guard let response = response else {
                    print("There was an error while trying to send the verification code to the email: \(String(describing: response?.statusCode))")
                    return
                }
                
                if response.statusCode == 201 {
                    print("Successfully sent verification code to email \(email): status code \(response.statusCode)")
                }
                else {
                    print("There was an error while trying to send the verification code to email \(email): status code \(response.statusCode)")
                }
            })
            .store(in: &cancellables)
        
        return operation
            .map({ _ in () })
            .mapError({ $0 as Error })
            .eraseToAnyPublisher()
    }
    
    @discardableResult
    func resetAccountPassword(with newPassword: String, using verificationCode: String) -> AnyPublisher<Void, Error> {
        guard let email = self.keyValueStorage.string(forKey: UDKeys.email.description) else {
            print("no email was found")
            
            return Empty(outputType: Void.self, failureType: Error.self)
                .eraseToAnyPublisher()
        }
        
        let json = """
        {
            "newPassword" : "\(newPassword)",
            "verificationCode" : "\(verificationCode)",
            "email" : "\(email)"
        }
        """
        
        let request = makePATCHRequest(json: json, scheme: "http", port: 3333, baseURL: FieroAPIEnum.BASE_URL.description, endPoint: UserEndpointEnum.RESET_PASSWORD.description, authToken: "")
        
        
        let operation = self.client.perform(for: request)
            .tryMap({ $1 as? HTTPURLResponse })
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .share()
        
        operation
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .failure(let error):
                        print("Failed to create request to reset password endpoint: \(error)")
                    case .finished:
                        print("Successfully created request to reset password endpoint")
                }
            }, receiveValue: { [weak self] response in
                guard let response = response else {
                    print("There was an error while trying to reset the password: \(String(describing: response?.statusCode))")
                    return
                }
                
                if response.statusCode == 200 {
                    print("Successfully reset password: status code \(response.statusCode)")
                    
                    self?.keyValueStorage.set(newPassword, forKey: UDKeys.password.description)
                }
                else {
                    print("There was an error while trying to reset the password: \(String(describing: response.statusCode))")
                }
            })
            .store(in: &cancellables)
        
        
        return operation
            .map({ _ in () })
            .mapError({ $0 as Error })
            .eraseToAnyPublisher()
    }
    
    //MARK: - Get AuthToken
    @discardableResult
    func refreshAuthToken() -> AnyPublisher<String, Error> {
        self.authTokenService.getAuthToken()
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
        UserDefaults.standard.set(email, forKey: UDKeys.email.description)
        UserDefaults.standard.set(password, forKey: UDKeys.password.description)
    }
    
    func cleanDefaults() {
        UserDefaults.standard.set("", forKey: UDKeys.email.description)
        UserDefaults.standard.set("", forKey: UDKeys.password.description)
        UserDefaults.standard.set("", forKey: UDKeys.authToken.description)
        UserDefaults.standard.set("", forKey: UDKeys.userID.description)
    }
    
}
