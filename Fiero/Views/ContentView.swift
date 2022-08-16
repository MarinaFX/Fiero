//
//  ContentView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 14/06/22.
//

import SwiftUI

struct ContentView: View {
    @State private var pushHomeView: Bool = false
    @ObservedObject private var userLoginViewModel: UserLoginViewModel
    
    init() {
        userLoginViewModel = UserLoginViewModel()
        let password = UserDefaults.standard.string(forKey: "password") ?? ""
        let email = UserDefaults.standard.string(forKey: "email") ?? ""
        userLoginViewModel.authenticateUser(email: email, password: password)
    }

    var body: some View {
        Group{
            if self.pushHomeView {
                withAnimation {
                    ChallengesListScreenView()
                        .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)))
                }
            }
            
            if !self.pushHomeView {
                AccountLoginView(pushHomeView: self.$pushHomeView)
                    .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)))
            }
        }
        .onChange(of: self.userLoginViewModel.serverResponse, perform: { serverResponse in
            if serverResponse.statusCode == 200 || serverResponse.statusCode == 201 {
                self.pushHomeView.toggle()
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
