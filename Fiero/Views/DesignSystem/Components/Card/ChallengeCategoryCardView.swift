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
            if !isAvailable {
                VStack{
                    Spacer()
                    Text("Em breve")
                        .padding(.horizontal, Tokens.Spacing.xxs.value)
                        .padding(.vertical, Tokens.Spacing.nano.value)
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                        .background(Tokens.Colors.Highlight.three.value)
                        .cornerRadius(Tokens.Border.BorderRadius.normal.value)
                        .font(Tokens.FontStyle.title3.font(weigth: .bold, design: .default))
                }.padding(.bottom, Tokens.Spacing.lg.value + Tokens.Spacing.md.value)
            }
            VStack(spacing: Tokens.Spacing.nano.value) {
                if isAvailable {
                    GifImage("quantity")
                        .frame(width: 250, height: 350)
                }
                Text(self.title)
                    .font(Tokens.FontStyle.title.font())
                    .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                
                Text(self.subtitle)
                    .multilineTextAlignment(.center)
                    .font(Tokens.FontStyle.callout.font())
                    .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                    .padding(.bottom, 40)
            }
            .padding(.horizontal, Tokens.Spacing.xxxs.value)
        }
        .frame(maxWidth: .infinity)
        .frame(height: UIScreen.main.bounds.height * 0.69)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

struct ChallengeCategoryCardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Algum texto em large title")
                .foregroundColor(.white)
                .font(Tokens.FontStyle.largeTitle.font())

            ChallengeCategoryCardView(title: "Quantidade", subtitle: "Vence quem fizer algo mais vezes", isAvailable: false)
                .padding(.horizontal, Tokens.Spacing.sm.value)
        }
        .background(Tokens.Colors.Background.dark.value)
    }
}
