//
//  ChallengeMetricSelectionCardView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 20/07/22.
//

import SwiftUI

struct ChallengeMetricSelectionCardView: View {
    enum CardType {
        case icon
        case text
    }
    var primaryColor: Color = .green
    var iconName: String = ""
    var description: String = ""
    var type: CardType = .icon
    
    var body: some View {
        ZStack {
            primaryColor
            
            if type == .icon {
                VStack {
                    Image(systemName: iconName)
                        .font(Tokens.FontStyle.largeTitle.font(weigth: .bold, design: .default))
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                        .padding()
                    
                    Text(description)
                        .font(Tokens.FontStyle.callout.font(weigth: .bold, design: .default))
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                }
            }
            else {
                VStack {
                    Text(description)
                        .font(Tokens.FontStyle.largeTitle.font(weigth: .bold, design: .default))
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: UIScreen.main.bounds.height * 0.2)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.Border.BorderRadius.small.value))
    }
}

struct ChallengeMetricSelectionCardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ChallengeMetricSelectionCardView(primaryColor: .green, iconName: "timer", description: "Timer", type: .text).padding(Tokens.Spacing.lg.value)
            
            ChallengeMetricSelectionCardView(primaryColor: .red, iconName: "stopwatch.fill", description: "Cronometanos", type: .icon).padding(Tokens.Spacing.sm.value)
        }
    }
}
