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
    
    @State private var subscriptions: Set<AnyCancellable> = []
    
    var body: some View {
        ZStack {
            Tokens.Colors.Background.dark.value.edgesIgnoringSafeArea(.all)
            VStack {
                ProfilePictureComponent(nameUser: UserViewModel.getUserNameFromDefaults())
                Spacer()
                ButtonComponent(style: .secondary(isEnabled: true), text: "Apagar conta", action: {
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
                            title: Text("Deletar conta"),
                            message: Text("Essa ação não poderá ser desfeita."),
                            primaryButton: .destructive(Text("Apagar meus dados")) {
                                self.userViewModel.deleteAccount()
                                    .sink(receiveCompletion: { completion in
                                        switch completion {
                                            case .finished:
                                                self.userViewModel.showingAlertToFalse()
                                            case .failure(_):
                                                self.userViewModel.activeAlert = .error
                                                self.userViewModel.showingAlertToTrue()
                                        }
                                    }, receiveValue: { _ in })
                                    .store(in: &subscriptions)
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
