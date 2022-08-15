//
//  PauseScreen.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 11/08/22.
//

import SwiftUI

struct PauseScreen: View {
    @Binding var didTapPauseButton: Bool
    
    //MARK: Colors
    var backgroundColor: Color {
        return Tokens.Colors.Neutral.Low.pure.value
    }
    var textColor: Color {
        return Tokens.Colors.Neutral.High.pure.value
    }
    //MARK: Spacings
    var spacingXXS: Double {
        return Tokens.Spacing.xxs.value
    }
    var spacingDefaultMargin: Double {
        return Tokens.Spacing.defaultMargin.value
    }
    //MARK: Font
    var textFont: Font {
        return Tokens.FontStyle.largeTitle.font(weigth: .bold)
    }
    
    var body: some View {
        ZStack {
            backgroundColor
                .opacity(0.8)
            VStack(spacing: spacingXXS) {
                Spacer()
                Text("Truco")
                    .foregroundColor(textColor)
                    .font(textFont)
                ButtonComponent(style: .primary(isEnabled: true), text: "Retornar ao desafio") {
                    self.didTapPauseButton.toggle()
                }
                ButtonComponent(style: .secondary(isEnabled: true), text: "Finalizar desafio") {
                }
            }
            .padding(.horizontal, spacingDefaultMargin)
            .padding(.bottom, 150)
        }
        .background(Color.clear)
        .ignoresSafeArea()
    }
}

struct PauseScreen_Previews: PreviewProvider {
    static var previews: some View {
        PauseScreen(didTapPauseButton: .constant(false))
    }
}
