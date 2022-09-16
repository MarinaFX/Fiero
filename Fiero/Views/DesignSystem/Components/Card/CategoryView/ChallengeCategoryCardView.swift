//
//  ChallengeCategoryCardView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 18/07/22.
//

import SwiftUI

struct ChallengeCategoryCardView: View {
    
    @State var style: CardCategoryStyles
    @Binding var isPlaying: Bool
    
    var title: String
    var subtitle: String
    
    var body: some View {
        ZStack {
            style.cardBackgroundColor
                .cornerRadius(style.cardCornerRadius)
            
            VStack(spacing: style.vStackSpacing) {
                LottieView(fileName: style.lottieName, reverse: false, loop: style.lottieLoop, isPaused: !isPlaying)
                    .padding(.bottom, style.lottieSpacing)
                
                Text(title)
                    .font(style.titleFont)
                    .foregroundColor(style.textColor)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, style.titleSpacing)
                
                Text(subtitle)
                    .font(style.subtitleFont)
                    .foregroundColor(style.textColor)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .padding(.bottom, style.subtitleSpacing)
                
                if style == .amount {
                    Text("Escolher esse")
                        .padding(.horizontal, style.horizontalButtonSpacing)
                        .padding(.vertical, style.verticalButtonSpacing)
                        .foregroundColor(style.textColor)
                        .background(style.buttonBackgroundColor)
                        .cornerRadius(style.buttonCornerRadius)
                        .font(style.buttonFont)
                    Spacer ()
                }
                Spacer ()
            }
            .padding(.bottom, style.cardSpacing)
        }
    }
}

struct ChallengeCategoryCardView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeCategoryCardView(style: .amount, isPlaying: .constant(true), title: "Quantidade", subtitle: "Vence quem fizer algo mais vezes")
            .padding(.horizontal, Tokens.Spacing.sm.value)
    }
}
