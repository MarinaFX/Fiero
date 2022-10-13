//
//  SettingsView.swift
//  Fiero
//
//  Created by Lucas Dimer Justo on 13/10/22.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Toggle("Efeitos sonoros", isOn: SoundPlayer.isActionSoundsActiveBinding)
                Spacer()
                ButtonComponent(style: .secondary(isEnabled: true), text: "Sair da conta", action: {
                    self.userViewModel.activeAlert = .logOut
                    self.userViewModel.showingAlertToTrue()
                })
                ButtonComponent(style: .destructive(isEnabled: true), text: "Apagar conta", action: {
                    self.userViewModel.activeAlert = .confirmAccountDelete
                    self.userViewModel.showingAlertToTrue()
                })
            }
            .padding(Tokens.Spacing.defaultMargin.value)
            .navigationBarTitle("Configurações", displayMode: .inline)
            .toolbar {
                Button("Feito!") {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
            .onAppear {
                print(UserDefaults.standard.value(forKey: SoundTypes.action.description) as? Bool)
                print(SoundPlayer.isActionSoundsActiveBinding.wrappedValue)
            }
            .onDisappear {
                print(UserDefaults.standard.value(forKey: SoundTypes.action.description) as? Bool)
                print(SoundPlayer.isActionSoundsActiveBinding.wrappedValue)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
