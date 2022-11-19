//
//  SettingsView.swift
//  Fiero
//
//  Created by Lucas Dimer Justo on 13/10/22.
//

import SwiftUI
import Combine

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State private var subscriptions: Set<AnyCancellable> = []
    
    var body: some View {
        NavigationView {
            VStack(spacing: Tokens.Spacing.xxs.value) {
                Toggle("Efeitos sonoros", isOn: SoundPlayer.isActionSoundsActiveBinding)
                    .tint(Tokens.Colors.Highlight.four.value)
                Toggle("Feedback tátil", isOn: HapticsController.isHapticsActiveBinding)
                    .tint(Tokens.Colors.Highlight.four.value)
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
                Button {
                    self.dismiss()
                } label: {
                    Text(LocalizedStringKey("Pronto"))
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                }
            }
        }
        .alert(isPresented: $userViewModel.showingAlert) {
            switch self.userViewModel.activeAlert {
                case .error:
                    return Alert(
                        title: Text("Oops, muito desafiador!"),
                        message: Text("Não conseguimos excluir sua conta no momento, tente mais tarde."),
                        dismissButton: .default(Text("OK")){
                            self.userViewModel.showingAlertToFalse()
                        }
                    )
                case .confirmAccountDelete:
                    return Alert(
                        title: Text("Apagar conta"),
                        message: Text("Essa ação não poderá ser desfeita."),
                        primaryButton: .destructive(Text("Apagar minha conta")) {
                            self.userViewModel.deleteAccount()
                                .sink(receiveCompletion: { completion in
                                    switch completion {
                                        case .finished:
                                            print("Successfully shared delete account subscriptions to ProfileView")
                                        case .failure(_):
                                            self.userViewModel.activeAlert = .error
                                            self.userViewModel.showingAlertToTrue()
                                    }
                                }, receiveValue: {
                                    self.userViewModel.showingAlertToFalse()
                                    self.userViewModel.cleanDefaults()
                                    self.userViewModel.isLogged = false
                                })
                                .store(in: &subscriptions)
                        },
                        secondaryButton: .cancel(Text("Cancelar")){
                            self.userViewModel.showingAlertToFalse()
                        }
                    )
                case .logOut:
                    return Alert(
                        title: Text("Sair da conta"),
                        message: Text(""),
                        primaryButton: .destructive(Text("Sair da conta")) {
                            self.userViewModel.cleanDefaults()
                            self.userViewModel.isLogged = false
                        },
                        secondaryButton: .cancel(Text("Cancelar")){
                            self.userViewModel.showingAlertToFalse()
                        }
                    )
                case .none:
                    return Alert(
                        title: Text("Oops, muito desafiador!"),
                        message: Text("Não conseguimos excluir sua conta no momento, tente mais tarde."),
                        dismissButton: .default(Text("OK")){
                            self.userViewModel.showingAlertToFalse()
                        }
                    )
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
