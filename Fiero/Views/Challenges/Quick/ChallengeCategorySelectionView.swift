//
//  ChallengeCategorySelectionView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 18/07/22.
//

import SwiftUI

struct ChallengeCategorySelectionView: View {
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Escolha um novo desafio rápido")
                .multilineTextAlignment(.center)
                .font(Tokens.FontStyle.largeTitle.font(weigth: .bold, design: .rounded))
                .padding(.horizontal, Tokens.Spacing.xs.value)
                .padding(.vertical, Tokens.Spacing.sm.value)
                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)

                TabView {
                    //highest
                    NavigationLink(destination: ChallengeNameSelectionView(primaryColor: Tokens.Colors.Highlight.three.value, secondaryColor: Tokens.Colors.Highlight.four.value, challengeType: .highest("")), label: {
                        ChallengeCategoryCardView(title: "Tempo", subtitle: "Vence quem fizer a maior pontuação no tempo definido.")
                            .padding(.horizontal, Tokens.Spacing.sm.value)
                    })
                    
                    //quickest
                    NavigationLink(destination: ChallengeNameSelectionView(primaryColor: Tokens.Colors.Highlight.five.value, secondaryColor: Tokens.Colors.Highlight.two.value, challengeType: .quickest), label: {
                        ChallengeCategoryCardView(title: "Quantidade", subtitle: "Vence quem fizer mais rapido a quantidade definida.")
                            .padding(.horizontal, Tokens.Spacing.sm.value)
                    })
                    
                    //bestof
                    NavigationLink(destination: ChallengeNameSelectionView(primaryColor: Tokens.Colors.Highlight.four.value, secondaryColor: Tokens.Colors.Highlight.five.value, challengeType: .bestOf), label: {
                        ChallengeCategoryCardView(title: "Rounds", subtitle: "Vence quem acumular mais rodadas vitoriosas.")
                            .padding(.horizontal, Tokens.Spacing.sm.value)
                    })
                    
                }
                .padding(.bottom)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            }
            .makeDarkModeFullScreen()
        }
        .navigationBarHidden(true)
    }
}

struct QuickChallengeCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeCategorySelectionView()
    }
}
