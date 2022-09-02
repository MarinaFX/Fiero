//
//  QCCategorySelectionView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 18/07/22.
//

import SwiftUI

struct QCCategorySelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView{
            VStack {
                Text("Escolha um novo desafio rápido")
                .multilineTextAlignment(.center)
                .font(Tokens.FontStyle.largeTitle.font(weigth: .bold, design: .default))
                .padding(.horizontal, Tokens.Spacing.xs.value)
                .padding(.vertical, Tokens.Spacing.sm.value)
                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)

                TabView {
                    
                    //amount
                    NavigationLink(destination: QCNamingView(primaryColor: Tokens.Colors.Highlight.five.value, secondaryColor: Tokens.Colors.Highlight.two.value, challengeType: .amount), label: {
                        ChallengeCategoryCardView(title: "Quantidade", subtitle: "Vence quem alcançar o objetivo mais rápido.", isAvailable: true)
                            .padding(.horizontal, Tokens.Spacing.sm.value)
                    })
                    
                    //byTime
//                    NavigationLink(destination: EmptyView(), label: {
                        ChallengeCategoryCardView(title: "Tempo", subtitle: "Vence quem fizer a maior \npontuação no tempo definido.", isAvailable: false)
                            .padding(.horizontal, Tokens.Spacing.sm.value)
//                    })
                    
                    //bestof
//                    NavigationLink(destination: EmptyView(), label: {
                        ChallengeCategoryCardView(title: "Rounds", subtitle: "Vence quem acumular \nmais rodadas vitoriosas.", isAvailable: false)
                            .padding(.horizontal, Tokens.Spacing.sm.value)
//                    })
                    
                }
                .padding(.bottom)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                    Haptics.shared.play(.light)
                }, label: {
                    Text("Voltar")
                        .bold()
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                })
                .padding(.bottom, Tokens.Spacing.xxxs.value)
            }
            .makeDarkModeFullScreen()
            .navigationBarHidden(true)

        }
    }
}

struct QuickChallengeCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        QCCategorySelectionView()
    }
}
