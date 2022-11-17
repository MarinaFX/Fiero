//
//  TabBar.swift
//  Fiero
//
//  Created by Marcelo Diefenbach on 18/08/22.
//

import SwiftUI

struct TabBarView: View {
    
    @State private var firstTab = 2
    
    init() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().backgroundColor = UIColor(Tokens.Colors.Neutral.Low.dark.value)
        UITabBar.appearance().unselectedItemTintColor = UIColor(Tokens.Colors.Neutral.Low.light.value)
        UserDefaults.standard.set("alreadyOpen", forKey: UDKeysEnum.isFirstOpen.description)
    }
    
    var body: some View {
        TabView(selection: $firstTab) {
            HomeView()
                .tabItem {
                    Label("Desafios",
                          systemImage: "list.triangle")
                }
                .tag(1)
            
            QCCategorySelectionView()
                .tabItem {
                    Label("Criar",
                          systemImage: "plus")
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    Label("Perfil",
                          systemImage: "person")
                }
                .tag(3)
            
            OnlineOngoingChallengeView()
                .tabItem {
                    Label("Perfil",
                          systemImage: "person")
                }
                .tag(4)
        }
        .preferredColorScheme(.dark)
        .environment(\.colorScheme, .dark)
        .accentColor(Tokens.Colors.Highlight.one.value)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
