//
//  ContentView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 14/06/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var sceneDelegate: SceneDelegate
    
    @StateObject private var quickChallengeViewModel: QuickChallengeViewModel = QuickChallengeViewModel()
    @StateObject private var userViewModel: UserViewModel = UserViewModel()
    @StateObject private var healthKitViewModel: HealthKitViewModel = HealthKitViewModel()
    
    @State private var pushHomeView: Bool = false
    @State private var isFirstLogin: Bool

    init() {
        if UserDefaults.standard.string(forKey: UDKeysEnum.isFirstOpen.description) ?? "" == "alreadyOpen" {
            isFirstLogin = false
        } else {
            isFirstLogin = true
        }
    }
    
    var body: some View {
        if self.isFirstLogin {
            OnboardingScreen(isFirstLogin: self.$isFirstLogin)
        } else {
            if userViewModel.isLogged {
                withAnimation {
                    TabBarView()
                    .environmentObject(self.quickChallengeViewModel)
                    .environmentObject(self.userViewModel)
                    .environmentObject(self.healthKitViewModel)
                    .onAppear(perform: {
                        self.sceneDelegate.userViewModel = self.userViewModel
                    })
                }
            }
            
            if !userViewModel.isLogged {
                AccountLoginView()
                .environmentObject(self.userViewModel)
                    .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
