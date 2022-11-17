//
//  OnlineOngoingChallengeView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 17/11/22.
//

import Foundation
import SwiftUI
import Combine

struct OnlineOngoingChallengeView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                Text("Me diga aonde você vai \nque eu vou varrendo")
                    .multilineTextAlignment(.center)
                    .lineLimit(5)
                    .font(Tokens.FontStyle.largeTitle.font(weigth: .bold, design: .default))
                    .padding(.bottom, Tokens.Spacing.nano.value)
                    .padding(.top, UIScreen.main.bounds.height * 0.06)
                
                Text("10 dias para o final do desafio")
                    .padding(.bottom, Tokens.Spacing.xs.value)
                
                Text("Você")
                    .font(Tokens.FontStyle.title2.font(weigth: .regular, design: .default))
                
                PlayerScoreControllerView()
                    .padding(.bottom, Tokens.Spacing.xs.value)
                
                Text("Lideres")
                    .font(Tokens.FontStyle.title2.font(weigth: .regular, design: .default))
                
                LeaderboardView()
                    .cornerRadius(Tokens.Border.BorderRadius.small.value)
                    .padding(.bottom, Tokens.Spacing.xs.value)
                
                Text("Sua posição")
                    .font(Tokens.FontStyle.title2.font(weigth: .regular, design: .default))
                
                VStack(spacing: Tokens.Spacing.nano.value) {
                    ScoreList(style: .owner, position: 15, name: "Você", points: 99)
                    ScoreList(style: .player, position: 15, name: "Você", points: 99)
                    ScoreList(style: .player, position: 15, name: "Você", points: 99)
                }
                .padding(.horizontal, Tokens.Spacing.defaultMargin.value)
                .padding(.bottom, Tokens.Spacing.sm.value)
                
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarTrailing ,content: {
                        Button(action: {
                            
                        }, label: {
                            Image(systemName: "arrow.triangle.2.circlepath")
                        })
                    })
                })
            }
        }
        .environment(\.colorScheme, .dark)
        .makeDarkModeFullScreen()
    }
}

struct PlayerScoreControllerView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: Tokens.Border.BorderRadius.small.value)
            .padding(.horizontal, 32)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.1)
            .foregroundColor(Tokens.Colors.Neutral.Low.pure.value)
            .overlay(content: {
                HStack {
                    Button(action: {
                        
                    }, label: {
                        Circle()
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .padding(.horizontal, 48)
                            .overlay(content: {
                                Image(systemName: "minus")
                                    .foregroundColor(.black)
                            })
                    })
                    
                    Spacer()
                    
                    Text("1234")
                        .font(Tokens.FontStyle.largeTitle.font(weigth: .bold, design: .default))
                    
                    Spacer()
                    
                    Button(action: {
                        
                    }, label: {
                        Circle()
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .padding(.horizontal, 48)
                            .overlay(content: {
                                Image(systemName: "plus")
                                    .foregroundColor(.black)
                            })
                    })
                }
            })
    }
}

struct OnlineOngoingChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        OnlineOngoingChallengeView()
    }
}
