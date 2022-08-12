//
//  OngoingDuelScreenView.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 08/08/22.
//

import SwiftUI

struct OngoingDuelScreenView: View {
    var body: some View {
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
                        .padding(.top, Tokens.Spacing.xxl.value)
                    }
                    .padding()
                    
                    Image("Olhos")
                    
                    DuelScoreComponent(style: .first, maxValue: 10, count: 2, playerName: "Alpaca Enfurecida")
                }
                .padding(.top, Tokens.Spacing.lg.value)
            }
            
            ZStack {
                Tokens.Colors.Highlight.two.value
                    .ignoresSafeArea(.all, edges: .bottom)
                
                VStack(spacing: Tokens.Spacing.xxs.value) {
                    DuelScoreComponent(style: .second, maxValue: 10, count: 2, playerName: "Alpaca Enfurecida")
                    
                    Image("Olhos")
                        .padding(.bottom, Tokens.Spacing.xl.value)
                }
                .padding(.bottom, Tokens.Spacing.xxxl.value)
            }
        }
        .ignoresSafeArea(.all, edges: .all)
        .navigationBarHidden(true)
    }
}

struct OngoingDuelScreenView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OngoingDuelScreenView()
                .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
            
            OngoingDuelScreenView()
                .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
        }
    }
}
