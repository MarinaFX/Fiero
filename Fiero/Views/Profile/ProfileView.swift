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
    
    var body: some View {
        ZStack {
            Tokens.Colors.Background.dark.value.edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "gearshape")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .sheet(isPresented: $settingsScreen) {
                            SettingsView()
                                .id(settingsScreen)
                        }
                        .onTapGesture {
                            self.settingsScreen = true
                        }
                }
                ProfilePictureComponent(nameUser: UserViewModel.getUserNameFromDefaults())
                Spacer()
                Text("Você é uma máquina de vencer")
                    .multilineTextAlignment(.center)
                    .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                    .font(Tokens.FontStyle.title3.font(weigth: .regular, design: .default))
                LottieView(fileName: "tonto2", reverse: false, loop: true, ended: $ended)
            }
            .padding(Tokens.Spacing.defaultMargin.value)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
