//
//  ChallengeCategorySelectionView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 18/07/22.
//

import SwiftUI

struct ChallengeCategorySelectionView: View {
    
    var body: some View {
        VStack {
            Text("Escolha um novo desafio rápido")
            .multilineTextAlignment(.center)
            .font(Tokens.FontStyle.largeTitle.font(weigth: .bold, design: .rounded))
            .padding(.horizontal, Tokens.Spacing.xs.value)
            .padding(.vertical, Tokens.Spacing.sm.value)
            .foregroundColor(Tokens.Colors.Neutral.High.pure.value)

            TabView {
                ChallengeCategoryCardView(title: "Tempo", subtitle: "Vence quem fizer mais rápido.")
                    .padding(.horizontal, Tokens.Spacing.sm.value)
                
                ChallengeCategoryCardView(title: "Quantidade", subtitle: "Vence quem fizer algo mais vezes.")
                    .padding(.horizontal, Tokens.Spacing.sm.value)
                
                ChallengeCategoryCardView(title: "Rounds", subtitle: "Vence quem acumular mais rodadas vitoriosas.")
                    .padding(.horizontal, Tokens.Spacing.sm.value)
                
            }
            .padding(.bottom)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        }
        .makeDarkModeFullScreen()
    }
}

struct QuickChallengeCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeCategorySelectionView()
    }
}
