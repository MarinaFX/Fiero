//
//  ProfileViewModel.swift
//  Fiero
//
//  Created by Marcelo Diefenbach on 19/08/22.
//

import Foundation


enum ActiveAlert {
    case confirmAccountDelete, error
}

class ProfileViewModel: ObservableObject {
    
    @Published var userName: String
    @Published var serverResponse: ServerResponse
    @Published var showingAlert = false
    @Published var activeAlert: ActiveAlert = .confirmAccountDelete
    
    private var userRegistrationViewModel: UserRegistrationViewModel = UserRegistrationViewModel()
    
    
    init() {
        userName = userRegistrationViewModel.getUserOnUserDefaults()
        serverResponse = ServerResponse.unknown
    }
    
    func deleteAccount() {

        //TODO: - logic to delete user account

        serverResponse.statusCode = 401
        let statusCode = serverResponse.statusCode
        if (statusCode == 201) {
            
            //TODO: - when success we need to go to login screen
            
        } else if (statusCode == 401) {
            DispatchQueue.main.async {
                self.activeAlert = .error
                self.showingAlert = true
            }
        }
    }
    
    func showingAlertToFalse() {
        showingAlert = false
    }
    
    func showingAlertToTrue() {
        showingAlert = true
    }
    
}
