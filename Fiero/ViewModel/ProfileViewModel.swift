//
//  ProfileViewModel.swift
//  Fiero
//
//  Created by Marcelo Diefenbach on 19/08/22.
//

import Foundation
import Combine
import SwiftUI

class ProfileViewModel: ObservableObject {
    @EnvironmentObject var userRegistrationViewModel: UserViewModel
    
    @Published var username: String = ""
    @Published var serverResponse: ServerResponse = .unknown
    @Published var showingAlert = false
    
    private let BASE_URL: String = "localhost"
    //private let BASE_URL: String = "10.41.48.196"
    //private let BASE_URL: String = "ec2-54-233-77-56.sa-east-1.compute.amazonaws.com"
    private let ENDPOINT_DELETE_USER: String = "/user"
    
    private var cancellables: Set<AnyCancellable> = []
    private var client: HTTPClient
    private var keyValueStorage: KeyValueStorage
    
    init(client: HTTPClient = URLSession.shared, keyValueStorage: KeyValueStorage = UserDefaults.standard) {
        self.client = client
        self.keyValueStorage = keyValueStorage
    }
    
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
                    //self?.activeAlert = .error
                    return
                }
                
                self?.serverResponse.statusCode = rawURLResponse.statusCode
                //self?.activeAlert = .confirmAccountDelete
            })
            .store(in: &cancellables)
        
        
        return operation
            .map({ _ in () })
            .mapError({ $0 as Error})
            .eraseToAnyPublisher()
    }
    
    func getUserName() -> String {
        return self.keyValueStorage.string(forKey: "userName") ?? "Alpaca Enfurecida"
    }
    
    func showingAlertToFalse() {
        self.showingAlert = false
    }
    
    func showingAlertToTrue() {
        self.showingAlert = true
    }
    
}
