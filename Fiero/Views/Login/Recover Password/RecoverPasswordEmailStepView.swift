//
//  RecoverPasswordEmailStep.swift
//  Fiero
//
//  Created by João Gabriel Biazus de Quevedo on 07/10/22.
//

import SwiftUI

struct RecoverPasswordEmailStepView: View {
    @Environment(\.presentationMode) var presentationMode
    

    @State private var emailText: String = ""
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
                            //TODO: - send confirmationCode to user email and go to next step
                            self.isPresentingConfirmCodeScreen.toggle()
                        })
                    NavigationLink("", isActive: self.$isPresentingConfirmCodeScreen) {
                        InputConfirmationCodeView()
                    }.hidden()
                    
                }.padding(.horizontal,Tokens.Spacing.defaultMargin.value)
            }
        }
    }
}

struct RecoverPasswordEmailStep_Previews: PreviewProvider {
    static var previews: some View {
        RecoverPasswordEmailStepView()
    }
}
