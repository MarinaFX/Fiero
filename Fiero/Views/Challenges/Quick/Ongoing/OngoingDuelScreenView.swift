//
//  OngoingDuelScreenView.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 08/08/22.
//

import SwiftUI

struct OngoingDuelScreenView: View {
    
    @Binding var didTapPauseButton: Bool
    //MARK: Colors
    var firstBackgroundColor: Color {
        return Tokens.Colors.Highlight.one.value
    }
    var secondBackgroundColor: Color {
        return Tokens.Colors.Highlight.two.value
    }
    var buttonColor: Color {
        return Tokens.Colors.Neutral.High.pure.value
    }
    //MARK: Spacings
    var spacingNano: Double {
        return Tokens.Spacing.nano.value
    }
    var spacingXXXS: Double {
        return Tokens.Spacing.xxxs.value
    }
    var spacingXS: Double {
        return Tokens.Spacing.xs.value
    }
    

    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ZStack {
                    firstBackgroundColor
                    VStack(spacing: spacingXS) {
                        HStack {
                            Spacer()
                            
                            Button {
                                self.didTapPauseButton.toggle()
                            } label: {
                                Image(systemName: "pause.circle.fill")
                                    .resizable()
                                    .foregroundColor(buttonColor)
                                    .frame(width: 40, height: 40)
                            }
                        }
                        .padding(.horizontal, spacingXXXS)

                        Image("Olhos")
                        DuelScoreComponent(style: .first, maxValue: 10, count: 2, playerName: "Alpaca Enfurecida")
                    }
                    .padding(.top, spacingNano)
                }
                .padding(.top, Tokens.Spacing.lg.value)
            }
            
            ZStack {
                Tokens.Colors.Highlight.two.value
                    .ignoresSafeArea(.all, edges: .bottom)
                
                ZStack {
                    secondBackgroundColor
                    VStack(spacing: spacingXS) {
                        Image("Olhos")
                        DuelScoreComponent(style: .second, maxValue: 10, count: 2, playerName: "Alpaca Enfurecida")
                    }
                    .padding(.bottom, spacingNano)
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
        DuelScreenView()
    }
}
