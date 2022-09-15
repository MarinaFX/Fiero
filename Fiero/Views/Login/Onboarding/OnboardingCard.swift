//
//  OnboardingCard.swift
//  Fiero
//
//  Created by Marcelo Diefenbach on 28/08/22.
//

import Foundation
import SwiftUI

struct OnboardingCard: View {
    
    @State var image: String
    @Binding private(set) var isFirstLogin: Bool
    @State var final: Bool = false
    @State var onboardingId: Int = 0
    @State private var animationAmount = 0.0
    
    var body: some View {
        if onboardingId == 3 {
            ZStack {
                VStack {
                    Image(image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width, alignment: .center)
//                        .padding(.horizontal, Tokens.Spacing.md.value)
                        //.padding(.bottom, Tokens.Spacing.lg.value)
                    ButtonComponent(style: .tertiary(isEnabled: true),
                                    text: "Quero começar!",
                                    action: {
                        self.isFirstLogin.toggle()
                    })
                    .padding(.horizontal, Tokens.Spacing.defaultMargin.value)
                    .padding(.bottom, Tokens.Spacing.md.value)
                }
            }
        } else if onboardingId == 2 {
            ZStack {
                VStack {
                    Image(image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: UIScreen.main.bounds.height * 0.8, alignment: .center)
                        .frame(width: UIScreen.main.bounds.width * 0.8, alignment: .center)
//                        .padding(.horizontal, Tokens.Spacing.md.value)
                }
            }
        } else if onboardingId == 1 {
            ZStack {
                VStack {
                    Image(image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: UIScreen.main.bounds.height, alignment: .center)
                        .frame(width: UIScreen.main.bounds.width, alignment: .center)
                        .padding(.bottom, Tokens.Spacing.sm.value)
//                        .padding(.horizontal, Tokens.Spacing.md.value)
                }
            }
        }
    }
}

struct OnboardingCard_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingCard(image: "Pontuacao", isFirstLogin: .constant(true))
    }
}

