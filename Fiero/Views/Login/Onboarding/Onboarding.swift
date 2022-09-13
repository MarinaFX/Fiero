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
                            OnboardingCard(image: "crie", isFirstLogin: self.$isFirstLogin)
                            OnboardingCard(image: "mecanica", isFirstLogin: self.$isFirstLogin)
                            OnboardingCard(image: "defina", isFirstLogin: self.$isFirstLogin, final: true)
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
        .preferredColorScheme(.dark)
    }
}

struct OnboardingScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingScreen(isFirstLogin: .constant(false))
    }
}

