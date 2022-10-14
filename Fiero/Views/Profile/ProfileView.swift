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
    
    @State private var subscriptions: Set<AnyCancellable> = []
    
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

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
