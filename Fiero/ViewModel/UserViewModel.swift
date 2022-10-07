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
    @Published var serverResponse: ServerResponse
    @Published var keyboardShown: Bool = false
    @Published var loginAlertCases: LoginAlertCases = .emptyFields
    @Published var isShowingLoading: Bool = false
    @Published var activeAlert: ActiveAlert?
    @Published var showingAlert = false
    @Published var isLogged = false

    private(set) var client: HTTPClient
    private(set) var keyValueStorage: KeyValueStorage
    private var refreshTokenSubscription: AnyCancellable?
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
                        print("completion failed with: \(error)")
                        self?.loginAlertCases = .connectionError
                        self?.isShowingLoading = false
                    case .finished:
                        print("finished successfully")
                }
            }, receiveValue: { [weak self] rawURLResponse in
                guard let response = rawURLResponse.item else {
                    self?.serverResponse.statusCode = rawURLResponse.statusCode
                    
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
                print("Signup status code: \(rawURLResponse.statusCode)")
                self?.keyValueStorage.set(response.token, forKey: UDKeys.authToken.description)
                self?.keyValueStorage.set(response.user.id, forKey: UDKeys.userID.description)
                self?.keyValueStorage.set(response.user.name, forKey: UDKeys.username.description)
                self?.keyValueStorage.set(response.user.email, forKey: UDKeys.email.description)
                self?.keyValueStorage.set(user.password!, forKey: UDKeys.password.description)

                self?.serverResponse.statusCode = rawURLResponse.statusCode
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
                        print("completion failed with: \(error)")
                        self?.loginAlertCases = .connectionError
                        self?.isShowingLoading = false
                    case .finished:
                        print("finished successfully")
                }
            }, receiveValue: { [weak self] rawURLResponse in
                guard let response = rawURLResponse.item else {
                    self?.serverResponse.statusCode = rawURLResponse.statusCode
                    
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
                    print("Login status code: \(rawURLResponse.statusCode)")
                    self?.isShowingLoading = false
                    
                    return
                }
                print("Login status code: \(rawURLResponse.statusCode)")
                print("Login token: \(response.token)")
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
    
    //MARK: - Get AuthToken
    func getAuthToken() {
        guard let email = self.keyValueStorage.string(forKey: UDKeys.email.description) else {
            print("Não ha nenhum email de usuario salvo")
            
            return
        }
        
        guard let password = self.keyValueStorage.string(forKey: UDKeys.password.description) else {
            print("Não ha nenhuma senha de usuario salva")
            
            return
        }
        
        let json = """
        {
            "email" : "\(email)",
            "password" : "\(password)"
        }
        """
        
        let request = makePOSTRequest(json: json, scheme: "http", port: 3333,
                                      baseURL: FieroAPIEnum.BASE_URL.description,
                                      endPoint: UserEndpointEnum.TOKEN.description,
                                      authToken: "")
        
        
        self.client.perform(for: request)
            .decodeHTTPResponse(type: UserTokenResponse.self, decoder: JSONDecoder())
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .failure(let error):
                        print("request failed with: \(error)")
                    case .finished:
                        print("request successful")
                }
            }, receiveValue: { [weak self] rawURLResponse in
                guard let response = rawURLResponse.item else {
                    self?.serverResponse.statusCode = rawURLResponse.statusCode
                    print(self?.serverResponse.statusCode as Any)
                    return
                }
                
                print("getToken successful: \(rawURLResponse.statusCode)")
                
                self?.keyValueStorage.set(response.token, forKey: UDKeys.authToken.description)
            })
            .store(in: &cancellables)
    }
    
    //MARK: - Delete Account
    func deleteAccount() -> AnyPublisher<Void, Error> {
        guard let userToken = self.keyValueStorage.string(forKey: UDKeys.authToken.description) else {
            print("Nao foi possivel achar o token do usuario")
            
            return Empty()
                .eraseToAnyPublisher()
        }
        
        guard let userId = self.keyValueStorage.string(forKey: UDKeys.userID.description) else {
            print("Nao foi possivel achar o ID do usuario")
            
            return Empty()
                .eraseToAnyPublisher()
        }
        
        let request = makeDELETERequest(param: userId, scheme: "http", port: 3333,
                                        baseURL: FieroAPIEnum.BASE_URL.description,
                                        endPoint: UserEndpointEnum.DELETE_USER.description,
                                        authToken: userToken)
        
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
    
    //MARK: - Refresh Token
    func refreshableToken() {
        guard let email = self.keyValueStorage.string(forKey: UDKeys.email.description),
              let password = self.keyValueStorage.string(forKey: UDKeys.password.description) else {
            print("NO USER SAVED IN DEFAULTS")
            return
        }
        
        guard refreshTokenSubscription == nil else {
            print("Has token subscription")
            return
        }
        
        self.refreshTokenSubscription = Timer.publish(every: 1200, on: .main, in: .default)
            .autoconnect()
            .receive(on: DispatchQueue.global(qos: .userInitiated))
            .flatMap({ _ in
                return self.login(email: email, password: password)
                    .eraseToAnyPublisher()
            })
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
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
