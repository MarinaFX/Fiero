//
//  OngoingDuelScreenView.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 08/08/22.
//

import SwiftUI

struct OngoingDuelScreenView: View {
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ZStack {
                    Tokens.Colors.Highlight.one.value
                    VStack(spacing: Tokens.Spacing.xxs.value) {
                        HStack {
                            Spacer()
                            
                            Button {
                                print("pause")
                            } label: {
                                Image(systemName: "pause.circle.fill")
                                    .resizable()
                                    .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                                    .frame(width: 40, height: 40)
                            }
                        }
                        .padding()

                        Image("Olhos")
                        DuelScoreComponent(style: .first, maxValue: 10, count: 2, playerName: "Alpaca Enfurecida")
                    }
                    .padding(.top, Tokens.Spacing.xxs.value)
                }
                
                ZStack {
                    Tokens.Colors.Highlight.two.value
                    VStack(spacing: Tokens.Spacing.xxs.value) {
                        DuelScoreComponent(style: .second, maxValue: 10, count: 2, playerName: "Alpaca Enfurecida")
                        Image("Olhos")
                    }
                    .padding(.bottom, Tokens.Spacing.xxl.value)
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct OngoingDuelScreenView_Previews: PreviewProvider {
    static var previews: some View {
        OngoingDuelScreenView()
    }
}
