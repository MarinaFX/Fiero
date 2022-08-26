//
//  BestOfChallengeWinRulesView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 20/07/22.
//

import SwiftUI

struct BestOfChallengeWinRulesView: View {
    
    @State var goalMeasure: Int = 3
    
    var primaryColor: Color
    var secondaryColor: Color
    var challengeType: QCType
    var challengeName: String

    var body: some View {
        VStack {
            CustomProgressBar(currentPage: .second, primaryColor: self.primaryColor, secondaryColor: self.secondaryColor)
                .padding()
            
            Text("Melhor de")
                .font(Tokens.FontStyle.largeTitle.font(weigth: .semibold, design: .rounded))
                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                .padding(.bottom, Tokens.Spacing.nano.value)
            
            Text("Número máximo de partidas pra que \nalguém ou algum time seja vencedor.")
                .multilineTextAlignment(.center)
                .font(Tokens.FontStyle.callout.font(weigth: .regular, design: .default))
                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
            
            Spacer()
            
            HStack {
                ChallengeMetricSelectionCardView(primaryColor: self.secondaryColor, description: "3", type: .text)
                
                ChallengeMetricSelectionCardView(primaryColor: self.primaryColor, description: "5", type: .text)
            }
            .padding(Tokens.Spacing.xxxs.value)
            
            Spacer()
        }
        .makeDarkModeFullScreen()
    }
}

struct BestOfChallengeWinRulesView_Previews: PreviewProvider {
    static var previews: some View {
        BestOfChallengeWinRulesView(primaryColor: .red, secondaryColor: .red, challengeType: .bestOf, challengeName: "")
    }
}
