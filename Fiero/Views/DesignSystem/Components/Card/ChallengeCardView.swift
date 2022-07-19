//
//  ChallengeCardView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 18/07/22.
//

import SwiftUI

struct ChallengeCardView: View {
    var title: String
    var subtitle: String
    
    var body: some View {
        ZStack {
            Tokens.Colors.Neutral.Low.dark.value
            
            VStack(spacing: Tokens.Spacing.nano.value) {
                Text(self.title)
                    .font(Tokens.FontStyle.title.font())
                    .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                
                Text(self.subtitle)
                    .multilineTextAlignment(.center)
                    .font(Tokens.FontStyle.callout.font())
                    .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
            }
            .padding(.horizontal, Tokens.Spacing.xxxs.value)
        }
        .frame(maxWidth: .infinity)
        .frame(height: UIScreen.main.bounds.height * 0.69)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

struct ChallengeCardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Algum texto em large title")
                .foregroundColor(.white)
                .font(Tokens.FontStyle.largeTitle.font())

            ChallengeCardView(title: "Quantidade", subtitle: "Vence quem fizer algo mais vezes")
                .padding(.horizontal, Tokens.Spacing.sm.value)
        }
        .background(Tokens.Colors.Background.dark.value)
    }
}
