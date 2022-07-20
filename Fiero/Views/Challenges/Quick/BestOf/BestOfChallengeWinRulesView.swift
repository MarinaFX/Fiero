//
//  BestOfChallengeWinRulesView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 20/07/22.
//

import SwiftUI

struct BestOfChallengeWinRulesView: View {
    private var primaryColor: Color = Color(red: 0.278, green: 0.758, blue: 0.557, opacity: 1)
    
    private var secondaryColor: Color = Color(red: 0.173, green: 0.157, blue: 0.89, opacity: 1)
    
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
        BestOfChallengeWinRulesView()
    }
}
