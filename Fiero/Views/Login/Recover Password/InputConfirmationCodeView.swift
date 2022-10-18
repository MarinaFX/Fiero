//
//  InputConfirmationCodeView.swift
//  Fiero
//
//  Created by João Gabriel Biazus de Quevedo on 07/10/22.
//

import SwiftUI

struct InputConfirmationCodeView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var userViewModel: UserViewModel

    @State private var confirmationCode: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    @State private var isPresentingErrorAlert: Bool = false
    @State var isPresentingNewPassword: Bool = false
    
    @Binding var email: String

    var body: some View {
        ZStack {
            Tokens.Colors.Background.dark.value.ignoresSafeArea()
            
            ScrollView {
                VStack (spacing: Tokens.Spacing.xxxs.value){
                    Spacer()
                    Text("verificationcationCodeTitleLabel")
                        .font(Tokens.FontStyle.largeTitle.font(weigth: .bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom, Tokens.Spacing.nano.value)
                    
                    CustomTextFieldView(
                        type: .none,
                        style: .primary,
                        placeholder: "verificationCodeTextFieldPlaceholder",
                        keyboardType: .alphabet,
                        isSecure: false,
                        isLowCase: true ,
                        isWrong: .constant(false),
                        text: self.$confirmationCode)
                    
                    CustomTextFieldView(
                        type: .none,
                        style: .primary,
                        placeholder: "passwordTextFieldPlaceholder",
                        keyboardType: .alphabet,
                        isSecure: false,
                        isLowCase: true ,
                        isWrong: .constant(false),
                        text: self.$password)
                    
                    CustomTextFieldView(
                        type: .none,
                        style: .primary,
                        placeholder: "confirmPasswordTextFieldPlaceholder",
                        keyboardType: .alphabet,
                        isSecure: false,
                        isLowCase: true ,
                        isWrong: .constant(false),
                        text: self.$confirmPassword)
                    
                    if userViewModel.keyboardShown {
                        ButtonComponent(
                            style: .primary(isEnabled: true),
                            text: "changePasswordButtonLabel",
                            action: {
                                validateInput(password: self.password,
                                                      confirmPassword: self.confirmPassword,
                                                      validationCode: self.confirmationCode)
                            })
                        .padding(.bottom, Tokens.Spacing.sm.value)
                    } else {
                        ButtonComponent(
                            style: .primary(isEnabled: true),
                            text: "changePasswordButtonLabel",
                            action: {
                                validateInput(password: self.password,
                                                    confirmPassword: self.confirmPassword,
                                                    validationCode: self.confirmationCode)
                            })
                    }
                }.padding(.horizontal,Tokens.Spacing.defaultMargin.value)
            }
        }
        .alert(isPresented: self.$isPresentingErrorAlert, content: {
            switch self.userViewModel.recoveryAccountSecondStepErrorCases {
                case .none:
                    return Alert(title: Text(RecoveryAccountSecondStepErrorCases.none.title),
                                 message: Text(RecoveryAccountSecondStepErrorCases.none.message),
                                 dismissButton: .cancel(Text("OK"), action: {
                        self.isPresentingErrorAlert = false
                        RootViewController.popToRootViewController()
                    }))
                case .emptyFields:
                    return Alert(title: Text(RecoveryAccountSecondStepErrorCases.emptyFields.title),
                                 message: Text(RecoveryAccountSecondStepErrorCases.emptyFields.message),
                                 dismissButton: .cancel(Text("OK"), action: {
                        self.isPresentingErrorAlert = false
                    }))
                case .wrongCode:
                    return Alert(title: Text(RecoveryAccountSecondStepErrorCases.wrongCode.title),
                                        message: Text(RecoveryAccountSecondStepErrorCases.wrongCode.message),
                                        primaryButton: .default(Text(RecoveryAccountSecondStepErrorCases.wrongCode.primaryButton), action: {
                                self.userViewModel.sendVerificationCode(for: self.email)
                                self.isPresentingErrorAlert = false
                           }),
                                        secondaryButton: .destructive(Text(RecoveryAccountSecondStepErrorCases.wrongCode.secondaryButton), action: {
                               self.isPresentingErrorAlert = false
                                RootViewController.popToRootViewController()
                           }))
                case .unmatchedPasswords:
                    return Alert(title: Text(RecoveryAccountSecondStepErrorCases.unmatchedPasswords.title),
                                 message: Text(RecoveryAccountSecondStepErrorCases.unmatchedPasswords.message),
                                 dismissButton: .cancel(Text(RecoveryAccountSecondStepErrorCases.unmatchedPasswords.primaryButton), action: {
                        self.isPresentingErrorAlert = false
                    }))
                case .internalServerError:
                    return Alert(title: Text(RecoveryAccountSecondStepErrorCases.internalServerError.title),
                                 message: Text(RecoveryAccountSecondStepErrorCases.internalServerError.message),
                                 dismissButton: .cancel(Text("OK"), action: {
                        self.isPresentingErrorAlert = false
                    }))
            }
        })
        .navigationBarHidden(true)
    }
    
    func validateInput(password: String, confirmPassword: String, validationCode: String) {
        if self.confirmationCode.isEmpty || self.password.isEmpty || self.confirmPassword.isEmpty {
            self.userViewModel.recoveryAccountSecondStepErrorCases = .emptyFields
            self.isPresentingErrorAlert = true
        }
        else {
            if self.password != self.confirmPassword {
                self.userViewModel.recoveryAccountSecondStepErrorCases = .unmatchedPasswords
                self.isPresentingErrorAlert = true
            }
            else {
                self.userViewModel.resetAccountPassword(with: self.confirmPassword, using: self.confirmationCode)
                self.isPresentingErrorAlert = true
            }
        }
    }
}

struct InputConfirmationCode_Previews: PreviewProvider {
    static var previews: some View {
        InputConfirmationCodeView(email: .constant("flemis"))
    }
}
