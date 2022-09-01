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
            
            VStack {
                
                if !isAvailable {
                    Spacer()
                }
                if isAvailable {
                    LottieView(fileName: "animation", reverse: true)
                        .frame(width: 300, height: 300, alignment: .center)
                }
                VStack(spacing: Tokens.Spacing.quarck.value) {
                    Text(self.title)
                        .font(Tokens.FontStyle.title.font())
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                    
                    Text(self.subtitle)
                        .multilineTextAlignment(.center)
                        .font(Tokens.FontStyle.callout.font())
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                }
          

                if !isAvailable {
                    VStack{
                        Text("Em breve")
                            .padding(.horizontal, Tokens.Spacing.xxs.value)
                            .padding(.vertical, Tokens.Spacing.nano.value)
                            .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                            .cornerRadius(Tokens.Border.BorderRadius.normal.value)
                            .font(Tokens.FontStyle.title3.font(weigth: .bold, design: .default))
                    }
                } else {
                    Text("Escolher esse")
                        .padding(.horizontal, Tokens.Spacing.xxs.value)
                        .padding(.vertical, Tokens.Spacing.nano.value)
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                        .background(Tokens.Colors.Highlight.three.value)
                        .cornerRadius(Tokens.Border.BorderRadius.normal.value)
                        .font(Tokens.FontStyle.title3.font(weigth: .bold, design: .default))
                        .padding(.top, Tokens.Spacing.xxxs.value)
                }
                Spacer()
            }
            .padding(.horizontal, Tokens.Spacing.xxxs.value)
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
