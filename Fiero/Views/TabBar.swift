//
//  TabBar.swift
//  Fiero
//
//  Created by Marcelo Diefenbach on 18/08/22.
//

import SwiftUI

struct TabBarView: View {
    
    init() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().backgroundColor = UIColor(Tokens.Colors.Neutral.Low.dark.value)
        UITabBar.appearance().unselectedItemTintColor = UIColor(Tokens.Colors.Neutral.Low.light.value)
        UserDefaults.standard.set("alreadyOpen", forKey: UDKeysEnum.isFirstOpen.description)
    }
    
    var body: some View {
        TabView {
            HomeView()
            .tabItem {
                Label("Desafios", systemImage: "list.triangle")
            }
            
            ProfileView()
            .tabItem {
                Label("Perfil", systemImage: "person")
            }
            
            TesteView()
            .tabItem {
                Label("Teste", systemImage: "person")
            }
        }
        .preferredColorScheme(.dark)
        .environment(\.colorScheme, .dark)
        .accentColor(Tokens.Colors.Highlight.one.value)
    }
}

struct TesteView: View {
    @EnvironmentObject var quickChallengeViewModel: QuickChallengeViewModel

    var body: some View {
        VStack {
            ButtonComponent(style: .secondary(isEnabled: true), text: "entrar no desafio", action: {
                self.quickChallengeViewModel.enterChallenge(by: "ABGLZ")
            })
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
