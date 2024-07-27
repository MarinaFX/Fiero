//
//  Profile Picture Component.swift
//  Fiero
//
//  Created by Marcelo Diefenbach on 18/08/22.
//

import SwiftUI
import Combine

struct ProfileView: View {
    @Environment(\.sizeCategory) var dynamicTypeCategory
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State private var ended: Bool = false
    @State private var settingsScreen: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("background").ignoresSafeArea()
                VStack {
                    if dynamicTypeCategory > .accessibilityLarge {
                        ScrollView(showsIndicators: true) {
                           ProfileBodyTextView()
                        }
                    }
                    else {
                        ProfileBodyTextView()
                    }
            
                    LottieView(fileName: "tonto2", reverse: false, loop: true, ended: $ended)
                    
                }
                .padding(.horizontal ,Tokens.Spacing.nano.value)
                .navigationTitle("Perfil")
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
