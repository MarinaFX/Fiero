//
//  Profile Picture Component.swift
//  Fiero
//
//  Created by Marcelo Diefenbach on 18/08/22.
//

import SwiftUI
import Combine

struct ProfileView: View {

    @StateObject private var profileViewModel = ProfileViewModel()
    
    @State private var subscriptions: Set<AnyCancellable> = []
    
    var body: some View {
        ZStack {
            Tokens.Colors.Background.dark.value.edgesIgnoringSafeArea(.all)
            VStack {
                ProfilePictureComponent(nameUser: profileViewModel.getUserName())
                Spacer()
                ButtonComponent(style: .secondary(isEnabled: true), text: "Apagar conta", action: {
                    profileViewModel.activeAlert = .confirmAccountDelete
                    profileViewModel.showingAlertToTrue()
                })
            }
            .padding(Tokens.Spacing.defaultMargin.value)
        }
        .alert(isPresented: $profileViewModel.showingAlert) {
            switch profileViewModel.activeAlert {
                    case .error:
                        return Alert(
                            title: Text("Oops, muito desafiador!"),
                            message: Text("Não conseguimos excluir sua conta no momento, tente mais tarde."),
                            dismissButton: .default(Text("OK")){
                                profileViewModel.showingAlertToFalse()
                            }
                        )
                    case .confirmAccountDelete:
                        return Alert(
                            title: Text("Deletar conta"),
                            message: Text("Essa ação não poderá ser desfeita."),
                            primaryButton: .destructive(Text("Apagar meus dados")) {
                                profileViewModel.deleteAccount()
                                    .sink(receiveCompletion: { completion in
                                        switch completion {
                                            case .finished:
                                                self.profileViewModel.showingAlertToFalse()
                                            case .failure(_):
                                                self.profileViewModel.showingAlertToTrue()
                                        }
                                    }, receiveValue: { _ in })
                                    .store(in: &subscriptions)
                            },
                            secondaryButton: .cancel(Text("Cancelar")){
                                profileViewModel.showingAlertToFalse()
                            }
                        )
                case .none:
                    return Alert(
                        title: Text("Oops, muito desafiador!"),
                        message: Text("Não conseguimos excluir sua conta no momento, tente mais tarde."),
                        dismissButton: .default(Text("OK")){
                            profileViewModel.showingAlertToFalse()
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
