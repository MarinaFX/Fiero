//
//  InputConfirmationCode.swift
//  Fiero
//
//  Created by João Gabriel Biazus de Quevedo on 07/10/22.
//

import SwiftUI

struct InputConfirmationCode: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var userViewModel: UserViewModel

    @State private var confirmationCode: String = ""
    @State var isPresentingNewPassword: Bool = false

    var body: some View {
        ZStack {
            Tokens.Colors.Background.dark.value.ignoresSafeArea()
            
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
                    text: self.$confirmationCode)
                
                CustomTextFieldView(
                    type: .none,
                    style: .primary,
                    placeholder: "confirmPasswordTextFieldPlaceholder",
                    keyboardType: .alphabet,
                    isSecure: false,
                    isLowCase: true ,
                    isWrong: .constant(false),
                    text: self.$confirmationCode)
                if userViewModel.keyboardShown {
                    ButtonComponent(
                        style: .primary(isEnabled: true),
                        text: "changePasswordButtonLabel",
                        action: {
                            //TODO: - verify confirmation code before go to next step
                            self.isPresentingNewPassword.toggle()
                        })
                    .padding(.bottom, Tokens.Spacing.sm.value)
                } else {
                    ButtonComponent(
                        style: .primary(isEnabled: true),
                        text: "changePasswordButtonLabel",
                        action: {
                            //TODO: - verify confirmation code before go to next step
                            self.isPresentingNewPassword.toggle()
                        })
                }
            }.padding(.horizontal,Tokens.Spacing.defaultMargin.value)
        }
        .navigationBarHidden(true)
    }
}

struct InputConfirmationCode_Previews: PreviewProvider {
    static var previews: some View {
        InputConfirmationCode()
    }
}
