//
//  QuickChallengeWinRulesView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 19/07/22.
//

import SwiftUI

struct QuickChallengeWinRulesView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var winThreshold: String = ""
    
    var body: some View {
        VStack {
            CustomProgressBar(currentPage: .third)
                .padding()
            
            Text("Vitória")
                .font(Tokens.FontStyle.largeTitle.font(weigth: .semibold, design: .rounded))
                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                .padding(.bottom, Tokens.Spacing.nano.value)
            
            Text("Número de pontos necessários pra que \nalguém seja vencedor.")
                .multilineTextAlignment(.center)
                .font(Tokens.FontStyle.callout.font(weigth: .regular, design: .default))
                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
            
            Spacer()
            
            PermanentKeyboard(text: self.$winThreshold, keyboardType: .decimalPad)
            
            Spacer()
            
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Voltar")
                    .bold()
                    .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
            })
            
            ButtonComponent(style: .secondary(isEnabled: true), text: "Começar!", action: {
                
            })
            .padding(.bottom)
            .padding(.horizontal, Tokens.Spacing.xxxs.value)
        }
        .padding(.top, Tokens.Spacing.lg.value)
        .padding(.bottom, Tokens.Spacing.xxs.value)
        .frame(
              minWidth: 0,
              maxWidth: .infinity,
              minHeight: 0,
              maxHeight: .infinity,
              alignment: .top
            )
        .background(Tokens.Colors.Background.dark.value)
        .ignoresSafeArea()
    }
}

struct QuickChallengeWinRulesView_Previews: PreviewProvider {
    static var previews: some View {
        QuickChallengeWinRulesView()
    }
}
