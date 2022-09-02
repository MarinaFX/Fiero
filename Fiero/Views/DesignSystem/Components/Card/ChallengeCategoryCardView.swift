//
//  ChallengeCategoryCardView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 18/07/22.
//

import SwiftUI

struct ChallengeCategoryCardView: View {
    var title: String
    var subtitle: String
    var isAvailable: Bool
    
    var body: some View {
        ZStack {
            Tokens.Colors.Neutral.Low.dark.value
                .cornerRadius(Tokens.Border.BorderRadius.normal.value)
            
            VStack(spacing: Tokens.Spacing.quarck.value) {
                if isAvailable {
                    LottieView(fileName: "animation", reverse: true)
                    
                    Text(title)
                        .font(Tokens.FontStyle.title.font())
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                    
                    Text(subtitle)
                        .font(Tokens.FontStyle.callout.font())
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: Tokens.Border.BorderRadius.normal.value)
                            .foregroundColor(Tokens.Colors.Highlight.three.value)
                            .frame(width: 150, height: 30)
                        Text("Escolher esse")
                            .font(Tokens.FontStyle.title3.font(weigth: .bold))
                            .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                    }
                    Spacer ()
                }
                else {
                    Spacer ()
                    
                    Text(title)
                        .font(Tokens.FontStyle.title.font())
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                    
                    Text(subtitle)
                        .font(Tokens.FontStyle.callout.font())
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                    
                    Text("Em breve")
                        .font(Tokens.FontStyle.title3.font(weigth: .bold))
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                        .cornerRadius(Tokens.Border.BorderRadius.normal.value)
                }
                
                Spacer ()
            }
        }
    }
}

struct ChallengeCategoryCardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Algum texto em large title")
                .foregroundColor(.white)
                .font(Tokens.FontStyle.largeTitle.font())

            ChallengeCategoryCardView(title: "Quantidade", subtitle: "Vence quem fizer algo mais vezes", isAvailable: true)
                .padding(.horizontal, Tokens.Spacing.sm.value)
        }
        .background(Tokens.Colors.Background.dark.value)
    }
}
