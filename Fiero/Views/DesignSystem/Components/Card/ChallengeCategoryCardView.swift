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
                    LottieView(fileName: "quantity2", reverse: false, loop: true)
                        .padding(.bottom, Tokens.Spacing.xxs.value)
                    
                    Text(title)
                        .font(Tokens.FontStyle.title.font(weigth: .bold, design: .default))
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, Tokens.Spacing.nano.value)
                    
                    Text(subtitle)
                        .font(Tokens.FontStyle.callout.font())
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                        .padding(.bottom, Tokens.Spacing.xxxs.value)
                    
                    Text("Escolher esse")
                        .padding(.horizontal, Tokens.Spacing.xxs.value)
                        .padding(.vertical, Tokens.Spacing.nano.value)
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                        .background(Tokens.Colors.Highlight.three.value)
                        .cornerRadius(Tokens.Border.BorderRadius.normal.value)
                        .font(Tokens.FontStyle.callout.font(weigth: .bold, design: .default))
                    Spacer ()
                }
                else {
                    Spacer ()
                    LottieView(fileName: "blockCategory", reverse: false, loop: false)
                        .padding(.bottom, Tokens.Spacing.xxs.value)
                        .frame(width: UIScreen.main.bounds.width*0.5)
                    Text(title)
                        .font(Tokens.FontStyle.title.font(weigth: .bold, design: .default))
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, Tokens.Spacing.xxxs.value)
                    
                    Text(subtitle)
                        .font(Tokens.FontStyle.callout.font())
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                        .padding(.bottom, Tokens.Spacing.xxxs.value)
                    
//                    Text("Em breve")
//                        .padding(.horizontal, Tokens.Spacing.xxs.value)
//                        .padding(.vertical, Tokens.Spacing.nano.value)
//                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
//                        .font(Tokens.FontStyle.callout.font(weigth: .bold, design: .default))
                    Spacer ()
                }
                
                Spacer ()
            }
            .padding(.bottom, Tokens.Spacing.xxxs.value)
        }
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
