//
//  QuickChallengeParticipantAmountView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 19/07/22.
//

import SwiftUI

struct QuickChallengeParticipantAmountView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            CustomProgressBar(currentPage: .second)
            
            Text("Quantas pessoas estão \nnesse desafio?")
                .multilineTextAlignment(.center)
                .font(Tokens.FontStyle.title.font(weigth: .bold, design: .rounded))
                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
            
            Spacer()
            
            TabView {
                ChallengeParticipantAmountCardView(amount: "2")
                    .padding(Tokens.Spacing.sm.value)
                
                ChallengeParticipantAmountCardView(amount: "3")
                    .padding(Tokens.Spacing.sm.value)
                
                ChallengeParticipantAmountCardView(amount: "4")
                    .padding(Tokens.Spacing.sm.value)
                
            }
            .tabViewStyle(PageTabViewStyle())
            
            Spacer()
            
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Voltar")
                    .bold()
                    .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
            })
            
            ButtonComponent(style: .secondary(isEnabled: true), text: "Esses são os desafiantes!", action: {
                
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

struct QuickChallengeParticipantAmountView_Previews: PreviewProvider {
    static var previews: some View {
        QuickChallengeParticipantAmountView()
    }
}