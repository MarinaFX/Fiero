//
//  RecoverPasswordEmailStep.swift
//  Fiero
//
//  Created by João Gabriel Biazus de Quevedo on 07/10/22.
//

import SwiftUI

struct RecoverPasswordEmailStep: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userViewModel: UserViewModel

    @State private var emailText: String = ""
    @State private var isPresentingErrorAlert: Bool = false
    @State var isPresentingConfirmCodeScreen: Bool = false
    
    
    var body: some View {
        NavigationView {
            ZStack {
                Tokens.Colors.Background.dark.value.ignoresSafeArea()
                VStack (spacing: Tokens.Spacing.xxxs.value){
                    Spacer()
                    
                    Text("recoverAccountTitleLabel")
                        .font(Tokens.FontStyle.largeTitle.font(weigth: .bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    CustomTextFieldView(
                        type: .none,
                        style: .primary,
                        placeholder: "textFieldPlaceholder",
                        keyboardType: .emailAddress,
                        isSecure: false,
                        isLowCase: true ,
                        isWrong: .constant(false),
                        text: self.$emailText)
                    
                    ButtonComponent(
                        style: .primary(isEnabled: true),
                        text: "buttonLabel",
                        action: {
                            if self.emailText.isEmpty {
                                self.userViewModel.recoveryAccountErrorCases = .emptyFields
                                self.isPresentingErrorAlert = true
                            }
                            else {
                                if !self.emailText.contains("@") || !self.emailText.contains(".") {
                                    self.userViewModel.recoveryAccountErrorCases = .invalidEmail
                                    self.isPresentingErrorAlert = true
                                }
                                else {
                                    self.userViewModel.sendVerificationCode(for: self.emailText)
                                    self.isPresentingErrorAlert = true
                                }
                            }
                        })
                    NavigationLink("", isActive: self.$isPresentingConfirmCodeScreen) {
                        InputConfirmationCode(email: self.$emailText)
                    }.hidden()
                    
                }.padding(.horizontal,Tokens.Spacing.defaultMargin.value)
            }
            .alert(isPresented: self.$isPresentingErrorAlert, content: {
                switch self.userViewModel.recoveryAccountErrorCases {
                    case .none:
                        return Alert(title: Text(RecoveryAccountErrorCases.none.title),
                                     message: Text(RecoveryAccountErrorCases.none.message),
                                     dismissButton: .cancel(Text("OK"), action: {
                            self.isPresentingErrorAlert = false
                            self.isPresentingConfirmCodeScreen.toggle()
                        }))
                    case .emptyFields:
                        return Alert(title: Text(RecoveryAccountErrorCases.emptyFields.title),
                                     message: Text(RecoveryAccountErrorCases.emptyFields.message),
                                     dismissButton: .cancel(Text("OK"), action: {
                            self.isPresentingErrorAlert = false
                        }))
                    case .invalidEmail:
                        return Alert(title: Text(RecoveryAccountErrorCases.invalidEmail.title),
                                     message: Text(RecoveryAccountErrorCases.invalidEmail.message),
                                     dismissButton: .cancel(Text("OK"), action: {
                            self.isPresentingErrorAlert = false
                        }))
                    case .noEmailFound:
                        return Alert(title: Text(RecoveryAccountErrorCases.noEmailFound.title),
                                     message: Text(RecoveryAccountErrorCases.noEmailFound.message),
                                     primaryButton: .default(Text(RecoveryAccountErrorCases.noEmailFound.primaryButton), action: {
                            self.isPresentingErrorAlert = false
                            self.presentationMode.wrappedValue.dismiss()
                        }),
                                     secondaryButton: .destructive(Text(RecoveryAccountErrorCases.noEmailFound.secondaryButton), action: {
                            self.isPresentingErrorAlert = false
                        }))
                    case .internalServerError:
                        return Alert(title: Text(RecoveryAccountErrorCases.internalServerError.title),
                                     message: Text(RecoveryAccountErrorCases.internalServerError.message),
                                     dismissButton: .cancel(Text("OK"), action: {
                            self.isPresentingErrorAlert = false
                        }))
                }
            })
        }
    }
}

struct RecoverPasswordEmailStep_Previews: PreviewProvider {
    static var previews: some View {
        RecoverPasswordEmailStep()
    }
}
