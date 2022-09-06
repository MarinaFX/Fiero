//
//  OnboardingCard.swift
//  Fiero
//
//  Created by Marcelo Diefenbach on 28/08/22.
//

import Foundation
import SwiftUI

struct OnboardingCard: View {
    
    @State var title: String
    @State var subtitle: String
    
    var body: some View {
        ZStack {
//            Tokens.Colors.Highlight.one.value.ignoresSafeArea()
            VStack {
                Text(title)
                    .font(Tokens.FontStyle.largeTitle.font(weigth: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                    .padding(.bottom, Tokens.Spacing.quarck.value)
                Text(subtitle)
                    .font(Tokens.FontStyle.callout.font(weigth: .regular))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
        
            }
        }
    }
}

struct OnboardingCard_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingCard(title: "Crie desafios", subtitle: "E tenha controle sobre os pontos \nde todos os participantes")
    }
}

