//
//  SettingsView.swift
//  Fiero
//
//  Created by Lucas Dimer Justo on 13/10/22.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: Tokens.Spacing.xxs.value) {
                Toggle("Efeitos sonoros", isOn: SoundPlayer.isActionSoundsActiveBinding)
                Toggle("Feedback tátil", isOn: HapticsController.isHapticsActiveBinding)
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
                    self.dismiss()
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
