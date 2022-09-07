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
    @State private var animationAmount = 0.0
    
    var body: some View {
        if final {
            ZStack {
                VStack {
                    Image(image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: .infinity, alignment: .center)
                        .padding(.horizontal, Tokens.Spacing.md.value)
                        .padding(.bottom, Tokens.Spacing.lg.value)
                    ButtonComponent(style: .secondary(isEnabled: true),
                                    text: "Fazer login",
                                    action: {
                        self.isFirstLogin.toggle()
                    }).padding(.horizontal, Tokens.Spacing.defaultMargin.value)
                }
            }
        } else {
            ZStack {
                VStack {
                    Image(image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: .infinity, alignment: .center)
                        .padding(.horizontal, Tokens.Spacing.md.value)
                }
            }
        }
    }
}

struct OnboardingCard_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingCard(image: "crie", isFirstLogin: .constant(true))
    }
}

