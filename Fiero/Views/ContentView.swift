//
//  ContentView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 14/06/22.
//

import SwiftUI
import UXCamSwiftUI
import UXCam

struct ContentView: View {
    @StateObject private var quickChallengeViewModel: QuickChallengeViewModel = QuickChallengeViewModel()
    @StateObject private var userViewModel: UserViewModel = UserViewModel()
    
    @State private var pushHomeView: Bool = false
    @State private var isFirstLogin: Bool

    init() {
        UXCam.optIntoSchematicRecordings()
        let config = UXCamSwiftUI.Configuration(appKey: "7jcm86kt1or6528")
        UXCamSwiftUI.start(with: config)
        if UserDefaults.standard.string(forKey: UDKeys.isFirstOpen.description) ?? "" == "alreadyOpen" {
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
