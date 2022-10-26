//
//  EnterWithCode.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 21/10/22.
//

import SwiftUI

struct EnterWithCodeView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var challengeCode: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Tokens.Colors.Background.dark.value
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: Tokens.Spacing.xs.value) {
                    Spacer()
                    
                    Text(LocalizedStringKey("enterWithCodeDescription"))
                        .multilineTextAlignment(.center)
                        .font(Tokens.FontStyle.largeTitle.font(weigth: .bold))
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                        .padding(.horizontal, Tokens.Spacing.lg.value)
                    
                    VStack(spacing: Tokens.Spacing.xxxs.value) {
                        CustomTextFieldView(placeholder: "enterWithCodePlaceholder",
                                            keyboardType: .alphabet,
                                            isSecure: false,
                                            isLowCase: true,
                                            isWrong: .constant(false),
                                            text: $challengeCode)

                        ButtonComponent(style: .primary(isEnabled: true),
                                        text: "enterWithCodeButtonText") {
                            print("enter the challenge")
                        }
                    }
                    .padding(.horizontal, Tokens.Spacing.defaultMargin.value)
                    .padding(.bottom, Tokens.Spacing.sm.value)
                }
                
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarTrailing, content: {
                        Button(action: {
                            self.dismiss()
                        }, label: {
                            Text("Fechar")
                                .foregroundColor(.white)
                        })
                    })
                })
            }
            .navigationTitle(LocalizedStringKey("enterWithCodeNavTitle"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct EnterWithCode_Previews: PreviewProvider {
    static var previews: some View {
        EnterWithCodeView()
    }
}
