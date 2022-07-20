//
//  ChallengeParticipantsSelectionView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 19/07/22.
//

import SwiftUI

struct ChallengeParticipantsSelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            CustomProgressBar(currentPage: .second)
                .padding()
            
            Text("Quantas pessoas estão \nnesse desafio?")
                .multilineTextAlignment(.center)
                .font(Tokens.FontStyle.title.font(weigth: .bold, design: .rounded))
                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                .padding(.top)
            
            Spacer()
            
            TabView {
                ChallengeParticipantsSelectionCardView(amount: "2")
                    .padding(Tokens.Spacing.sm.value)
                
                ChallengeParticipantsSelectionCardView(amount: "3")
                    .padding(Tokens.Spacing.sm.value)
                
                ChallengeParticipantsSelectionCardView(amount: "4")
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
        .makeDarkModeFullScreen()
    }
}

struct ChallengeParticipantsSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeParticipantsSelectionView()
    }
}
