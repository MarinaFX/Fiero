//
//  Profile Picture Component.swift
//  Fiero
//
//  Created by Marcelo Diefenbach on 18/08/22.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject private var profileViewModel = ProfileViewModel()
    
    var body: some View {
        ZStack {
            Tokens.Colors.Background.dark.value.edgesIgnoringSafeArea(.all)
            VStack {
                ProfilePictureComponent(nameUser: profileViewModel.userName)
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
                                profileViewModel.showingAlertToFalse()
                            },
                            secondaryButton: .cancel(Text("Cancelar")){
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
