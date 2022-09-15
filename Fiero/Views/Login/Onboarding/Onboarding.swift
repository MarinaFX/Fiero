//
//  Onboarding.swift
//  Fiero
//
//  Created by Marcelo Diefenbach on 28/08/22.
//

import Foundation
import SwiftUI

struct OnboardingScreen: View {

    @Binding private(set) var isFirstLogin: Bool
    
    var body: some View {
        ZStack {
            Tokens.Colors.Background.dark.value.ignoresSafeArea()
            VStack {
                HStack {
                    VStack {
                        TabView{
                            OnboardingCard(image: "Desafie", isFirstLogin: self.$isFirstLogin, onboardingId: 1)
                            OnboardingCard(image: "Pontuacao", isFirstLogin: self.$isFirstLogin, onboardingId: 2)
                            OnboardingCard(image: "Multiplos", isFirstLogin: self.$isFirstLogin, final: true, onboardingId: 3)
                        }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                        .padding(.bottom, Tokens.Spacing.defaultMargin.value)
                    }
                }
            }
            VStack {
                HStack {
                    Spacer()
                    Text("Pular")
                        .font(Tokens.FontStyle.callout.font(weigth: .regular))
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                        .onTapGesture {
                            self.isFirstLogin.toggle()
                        }
                        .padding(.top ,Tokens.Spacing.defaultMargin.value)
                        .padding(.horizontal, Tokens.Spacing.defaultMargin.value)
                }
                Spacer()
            }
        }
    }
}

struct OnboardingScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingScreen(isFirstLogin: .constant(false))
    }
}

