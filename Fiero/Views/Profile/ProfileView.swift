//
//  Profile Picture Component.swift
//  Fiero
//
//  Created by Marcelo Diefenbach on 18/08/22.
//

import SwiftUI
import Combine

struct ProfileView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State private var ended: Bool = false
    @State private var settingsScreen: Bool = false
    
    let userName = UserViewModel.getUserNameFromDefaults()
    
    var body: some View {
        NavigationView {
            ZStack {
                Tokens.Colors.Background.dark.value.edgesIgnoringSafeArea(.all)
                VStack {
                    HStack(spacing: 2) {
                        Text("Fique ligado")
                            .multilineTextAlignment(.center)
                            .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                            .font(Tokens.FontStyle.title.font(design: .rounded))
                        
                        Text(userName)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                            .font(Tokens.FontStyle.title.font(weigth: .bold, design: .rounded))
                            
                    }
                    .padding(.top, Tokens.Spacing.nano.value)
                    .padding(.horizontal, Tokens.Spacing.defaultMargin.value)
                    .padding(.bottom, Tokens.Spacing.quarck.value)
                    
                    Text("Novas funcionalidades")
                        .multilineTextAlignment(.center)
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                        .font(Tokens.FontStyle.title3.font())
                        .padding(.horizontal ,Tokens.Spacing.defaultMargin.value)
            
                    LottieView(fileName: "tonto2", reverse: false, loop: true, ended: $ended)
                    
                }
                .padding(.horizontal ,Tokens.Spacing.defaultMargin.value)
                .navigationTitle("Profile")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Image(systemName: "gearshape")
                            .foregroundColor(Tokens.Colors.Highlight.one.value)
                            .font(Tokens.FontStyle.title3.font(weigth: .bold, design: .rounded))
                            .sheet(isPresented: $settingsScreen) {
                                SettingsView()
                                    .id(settingsScreen)
                            }
                            .onTapGesture {
                                self.settingsScreen = true
                            }
                    }
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
