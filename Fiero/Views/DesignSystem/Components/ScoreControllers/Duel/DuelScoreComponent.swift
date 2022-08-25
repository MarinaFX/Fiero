//
 //  ScoreControllerDuel.swift
 //  Fiero
 //
 //  Created by João Gabriel Biazus de Quevedo on 04/08/22.
 //

import SwiftUI

struct DuelScoreComponent: View {
    @EnvironmentObject var quickChallengeViewModel: QuickChallengeViewModel

    @State var style: ScoreControllerStyle
    
    @Binding var playerScore: Double

    private(set) var challengeId: String
    private(set) var teamId: String
    private(set) var memberId: String
    
    var playerName: String

     var body: some View {
         ZStack{
             RoundedRectangle(cornerRadius: style.borderRadius)
                 .foregroundColor(style.backgroundColor)
                 .opacity(0.2)

             VStack(alignment:.center, spacing: Tokens.Spacing.nano.value ) {
                 HStack() {
                     Button(action: {
                         self.playerScore -= 1
                     }) {
                         Image(systemName: style.minusIcon)
                             .resizable()
                             .frame(width: 40, height: 40)
                             .foregroundColor(style.buttonColor)

                     }
                     .padding(.leading, style.spacing)

                     Spacer()

                     Text("\(self.playerScore, specifier: "%.0f")")
                         .foregroundColor(style.buttonColor)
                         .font(style.numberFont)

                     Spacer()

                     Button(action: {
                         self.playerScore += 1
                     }) {
                         Image(systemName: style.plusIcon)
                             .resizable()
                             .frame(width: 40, height: 40)
                             .foregroundColor(style.buttonColor)
                     }
                     .padding(.trailing, style.spacing)
                 }
                 .padding(.vertical, style.spacingVertical)

                 Text("\(playerName)")
                     .foregroundColor(style.buttonColor)
                     .font(style.nameFont)
                     .padding(.horizontal, style.spacingVertical)
             }
             .padding(.vertical, style.spacingAll)
         }
         .onDisappear(perform: {
             self.quickChallengeViewModel.patchScore(challengeId: self.challengeId, teamId: self.teamId, memberId: self.memberId, score: self.playerScore)
         })
         .frame(height: 120)
     }
 }

struct DuelScoreComponent_Previews: PreviewProvider {
    static var previews: some View {
        DuelScoreComponent(style: .first, playerScore: .constant(0.0), challengeId: "", teamId: "", memberId: "", playerName: "")
    }
}
