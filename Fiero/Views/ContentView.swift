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
    let defaults = UserDefaults.standard

    init() {
        UXCam.optIntoSchematicRecordings()
        let config = UXCamSwiftUI.Configuration(appKey: "7jcm86kt1or6528")
        UXCamSwiftUI.start(with: config)
        if defaults.string(forKey: "isFirstOpen") ?? "" == "alreadyOpens" {
            isFirstLogin = true
        } else {
            isFirstLogin = false
        }
    }
    
    var body: some View {
        
        if self.isFirstLogin {
            if userViewModel.isLogged {
                withAnimation {
                    TabBarView()
                .environmentObject(self.quickChallengeViewModel)
                    .environmentObject(self.userViewModel)
            }
            }
            
            if !userViewModel.isLogged {
                AccountLoginView(pushHomeView: self.$pushHomeView)
                .environmentObject(self.userViewModel)
                    .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)))
            }
        } else {
            OnboardingScreen(isFirstLogin: self.$isFirstLogin)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
