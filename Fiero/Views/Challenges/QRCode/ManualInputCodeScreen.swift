//
//  ManualInputCode.swift
//  Fiero
//
//  Created by Marcelo Diefenbach on 28/08/22.
//

import Foundation
import SwiftUI

struct ManualInputCodeScreen: View {
    @Environment(\.presentationMode) var presentationMode

    @State private var inviteCode: String = ""
    @State var isPresentingNewPassword: Bool = false

    var body: some View {
        ZStack {
            Tokens.Colors.Background.dark.value.ignoresSafeArea()
            VStack (spacing: Tokens.Spacing.xxxs.value){
                Spacer()
                Text("Informe o código do desafio para participar da competição")
                    .font(Tokens.FontStyle.largeTitle.font(weigth: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, Tokens.Spacing.xs.value)
                
                CustomTextFieldView(
                    type: .none,
                    style: .primary,
                    placeholder: "Código do desafio",
                    keyboardType: .default,
                    isSecure: false,
                    isLowCase: true ,
                    isWrong: .constant(false),
                    text: self.$inviteCode)
                
                ButtonComponent(
                    style: .primary(isEnabled: true),
                    text: "Entrar no desafio",
                    action: {
                        //TODO: - verify if code is valid and go to confirmation screen
                        
                    })
            }.padding(.horizontal, Tokens.Spacing.defaultMargin.value)
            .padding(.bottom, Tokens.Spacing.defaultMargin.value)
        }
    }
}

struct ManualInputCodeScreen_Previews: PreviewProvider {
    static var previews: some View {
        ManualInputCodeScreen()
    }
}

