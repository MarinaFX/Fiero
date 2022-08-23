//
//  TabBar.swift
//  Fiero
//
//  Created by Marcelo Diefenbach on 18/08/22.
//

import SwiftUI

struct TabBarView: View {
    @StateObject var quickChallengeViewModel: QuickChallengeViewModel = QuickChallengeViewModel()

    init() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().backgroundColor = UIColor(Tokens.Colors.Neutral.Low.dark.value)
        UITabBar.appearance().unselectedItemTintColor = UIColor(Tokens.Colors.Neutral.Low.light.value)
    }
    
    var body: some View {
        
        TabView {
            ChallengesListScreenView()
            .environmentObject(self.quickChallengeViewModel)
            .tabItem {
                Label("Desafios", systemImage: "list.triangle")
            }
            
            ProfileView()
            .tabItem {
                Label("Perfil", systemImage: "person")
            }
        }
        .accentColor(Tokens.Colors.Brand.Primary.pure.value)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
