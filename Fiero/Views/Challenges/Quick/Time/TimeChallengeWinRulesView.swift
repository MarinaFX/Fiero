//
//  TimeChallengeWinRulesView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 20/07/22.
//

import SwiftUI

struct TimeChallengeWinRulesView: View {
    private var primaryColor: Color = Color(red: 1, green: 0.349, blue: 0.408, opacity: 1)
    
    private var secondaryColor: Color = Color(red: 0.251, green: 0.612, blue: 0.522, opacity: 1)
    
    var body: some View {
        VStack {
            CustomProgressBar(currentPage: .second, primaryColor: self.primaryColor, secondaryColor: self.secondaryColor)
                .padding()
            
            Text("Tempo")
                .font(Tokens.FontStyle.largeTitle.font(weigth: .semibold, design: .rounded))
                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                .padding(.bottom, Tokens.Spacing.nano.value)
            
            Text("Cronômetro: quem faz em menos tempo?")
                .font(Tokens.FontStyle.callout.font(weigth: .regular, design: .default))
                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
            
            Text("Timer: Quem faz mais com o mesmo tempo?")
                .font(Tokens.FontStyle.callout.font(weigth: .regular, design: .default))
                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
            
            Spacer()
            
            HStack {
                ChallengeMetricSelectionCardView(primaryColor: self.primaryColor, iconName: "stopwatch.fill", description: "Cronômetro", type: .icon)
                
                ChallengeMetricSelectionCardView(primaryColor: self.secondaryColor, iconName: "timer", description: "Timer", type: .icon)
            }
            .padding(Tokens.Spacing.xxxs.value)
            
            Spacer()
        }
        .makeDarkModeFullScreen()
    }
}

struct TimeChallengeWinRulesView_Previews: PreviewProvider {
    static var previews: some View {
        TimeChallengeWinRulesView()
    }
}
