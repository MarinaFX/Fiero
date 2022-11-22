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
    
    @State private var ended: Bool = false
    
    var title: LocalizedStringKey
    var subtitle: LocalizedStringKey
    
    var body: some View {
        ZStack {
            style.cardBackgroundColor
                .cornerRadius(style.cardCornerRadius)
            
            VStack(spacing: style.vStackSpacing) {
                Spacer()
                
                ZStack {
                    if style == .amount {
                        LottieView(fileName: "quantity2", reverse: false, loop: true, aspectFill: false, isPaused: !isPlaying, ended: $ended).opacity(ended ? 1 : 0)
                            .padding(.bottom, style.lottieSpacing)
                        LottieView(fileName: "quantity", reverse: false, loop: false, aspectFill: false, isPaused: !isPlaying, ended: $ended).opacity(ended ? 0 : 1)
                            .padding(.bottom, style.lottieSpacing)
                    }
                    else {
                        LottieView(fileName: style.lottieName, reverse: false, loop: style.lottieLoop, isPaused: !isPlaying, ended: $ended)
                            .padding(.bottom, style.lottieSpacing)
                    }
                }
                
                Text(title)
                    .font(style.titleFont)
                    .foregroundColor(style.textColor)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, style.titleSpacing)
                
                Text(subtitle)
                    .font(style.subtitleFont)
                    .foregroundColor(style.textColor)
                    .multilineTextAlignment(.center)
                    .lineLimit(5)
                    .padding(.bottom, style.subtitleSpacing)
                
                if style != .blocked {
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
