//
//  InputConfirmationCode.swift
//  Fiero
//
//  Created by João Gabriel Biazus de Quevedo on 07/10/22.
//

import SwiftUI

struct InputConfirmationCodeView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State private var confirmationCode: String = ""
    @State var isPresentingNewPassword: Bool = false
    
    
    var textFont: Font {
        return Tokens.FontStyle.callout.font()
    }
    var color: Color {
        return Tokens.Colors.Neutral.High.pure.value
    }
    
    var body: some View {
        ZStack {
            Tokens.Colors.Background.dark.value.ignoresSafeArea()
            ScrollView{
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
                    
                    ButtonComponent(
                        style: .primary(isEnabled: true),
                        text: "changePasswordButtonLabel",
                        action: {
                            //TODO: - verify confirmation code before go to next step
                            self.isPresentingNewPassword.toggle()
                        })
                    ButtonComponent(
                        style: .black(isEnabled: true),
                        text: "resendEmailVerification",
                        action: {
                            //TODO: - verify confirmation code before go to next step
                            
                        })
                    
                }.padding(.horizontal,Tokens.Spacing.defaultMargin.value)
            }
        }
        .navigationBarHidden(true)
    }
}

struct InputConfirmationCode_Previews: PreviewProvider {
    static var previews: some View {
        InputConfirmationCodeView()
    }
}
