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
    @EnvironmentObject var quickChallengeViewModel: QuickChallengeViewModel
    
    @State var subscriptions: Set<AnyCancellable> = []
    
    @Binding var quickChallenge: QuickChallenge
    
    private var score: Double {
        return self.quickChallenge.teams.filter({ $0.members?.first?.userId == UserDefaults.standard.string(forKey: UDKeysEnum.userID.description)}).first?.members?.first?.score ?? -1.0
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                Text(self.quickChallenge.name)
                    .multilineTextAlignment(.center)
                    .lineLimit(5)
                    .font(Tokens.FontStyle.largeTitle.font(weigth: .bold, design: .default))
                    .padding(.bottom, Tokens.Spacing.nano.value)
                    .padding(.top, UIScreen.main.bounds.height * 0.06)
                
                Text("10 dias para o final do desafio")
                    .padding(.bottom, Tokens.Spacing.xs.value)
                
                Text("Você")
                    .font(Tokens.FontStyle.title2.font(weigth: .regular, design: .default))
                
                PlayerScoreControllerView(quickChallenge: self.$quickChallenge)
                    .padding(.bottom, Tokens.Spacing.xs.value)
                
                Text("Lideres")
                    .font(Tokens.FontStyle.title2.font(weigth: .regular, design: .default))
                
                LeaderboardView(quickChallenge: self.$quickChallenge)
                    .cornerRadius(Tokens.Border.BorderRadius.small.value)
                    .padding(.bottom, Tokens.Spacing.xs.value)
                
                Text("Sua posição")
                    .font(Tokens.FontStyle.title2.font(weigth: .regular, design: .default))
                
                VStack(spacing: Tokens.Spacing.nano.value) {
                    RankedPlayersView(quickChallenge: self.$quickChallenge, userPosition: self.quickChallenge.getTeamPositionAtRanking(teamId: self.quickChallenge.getTeamIdByMemberId(memberId: UserDefaults.standard.string(forKey: UDKeysEnum.userID.description) ?? "")))
                }
                .padding(.horizontal, Tokens.Spacing.defaultMargin.value)
                .padding(.bottom, Tokens.Spacing.sm.value)
                
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarTrailing ,content: {
                        Button(action: {
                            self.quickChallengeViewModel.getChallenge(by: self.quickChallenge.id)
                                .sink(receiveCompletion: { _ in
                                }, receiveValue: { quickChallenge in
                                    self.quickChallenge = quickChallenge
                                })
                                .store(in: &subscriptions)
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

struct RankedPlayersView: View {
    
    @Binding var quickChallenge: QuickChallenge
    
    var userPosition: Int = 0
    
    var body: some View {
        if self.quickChallenge.teams.count >= 3 {
            if userPosition == 0 {
                ScoreList(style: .owner, position: userPosition + 1, name: self.quickChallenge.getRanking()[userPosition].name, points: Int(self.quickChallenge.getRanking()[userPosition].getTotalScore()))
                
                ScoreList(style: .player, position: userPosition + 2, name: self.quickChallenge.getRanking()[userPosition+1].name, points: Int(self.quickChallenge.getRanking()[userPosition+1].getTotalScore()))
                
                ScoreList(style: .player, position: userPosition + 3, name: self.quickChallenge.getRanking()[userPosition+2].name, points: Int(self.quickChallenge.getRanking()[userPosition+2].getTotalScore()))
            }
            else {
                if userPosition == self.quickChallenge.teams.count - 1 {
                    ScoreList(style: .player, position: userPosition - 1, name: self.quickChallenge.getRanking()[userPosition-2].name, points: Int(self.quickChallenge.getRanking()[userPosition-2].getTotalScore()))
                    
                    ScoreList(style: .player, position: userPosition, name: self.quickChallenge.getRanking()[userPosition-1].name, points: Int(self.quickChallenge.getRanking()[userPosition-1].getTotalScore()))
                    
                    ScoreList(style: .owner, position: userPosition + 1, name: self.quickChallenge.getRanking()[userPosition].name, points: Int(self.quickChallenge.getRanking()[userPosition].getTotalScore()))
                }
                else {
                    ScoreList(style: .player, position: userPosition, name: self.quickChallenge.getRanking()[userPosition-1].name, points: Int(self.quickChallenge.getRanking()[userPosition-1].getTotalScore()))
                    
                    ScoreList(style: .owner, position: userPosition + 1, name: self.quickChallenge.getRanking()[userPosition].name, points: Int(self.quickChallenge.getRanking()[userPosition].getTotalScore()))
                    
                    ScoreList(style: .player, position: userPosition + 2, name: self.quickChallenge.getRanking()[userPosition+1].name, points: Int(self.quickChallenge.getRanking()[userPosition+1].getTotalScore()))
                }
            }
        }
        else {
            if self.quickChallenge.teams.count == 2 {
                if userPosition == 0 {
                    ScoreList(style: .owner, position: userPosition + 1, name: self.quickChallenge.getRanking()[userPosition].name, points: Int(self.quickChallenge.getRanking()[userPosition].getTotalScore()))
                    
                    ScoreList(style: .player, position: userPosition + 2, name: self.quickChallenge.getRanking()[userPosition+1].name, points: Int(self.quickChallenge.getRanking()[userPosition+1].getTotalScore()))
                }
                else {
                    ScoreList(style: .player, position: userPosition, name: self.quickChallenge.getRanking()[userPosition-1].name, points: Int(self.quickChallenge.getRanking()[userPosition-1].getTotalScore()))
                    
                    ScoreList(style: .owner, position: userPosition + 1, name: self.quickChallenge.getRanking()[userPosition].name, points: Int(self.quickChallenge.getRanking()[userPosition].getTotalScore()))
                }
            }
            else {
                ScoreList(style: .owner, position: userPosition + 1, name: self.quickChallenge.getRanking()[userPosition].name, points: Int(self.quickChallenge.getRanking()[userPosition].getTotalScore()))
            }
        }
    }
}

struct PlayerScoreControllerView: View {
    
    @Binding var quickChallenge: QuickChallenge
    
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
                    
                    Text(String(format: "%.0f", self.quickChallenge.teams.first(where: { $0.ownerId == UserDefaults.standard.string(forKey: UDKeysEnum.userID.description)})?.getTotalScore() ?? -1.0))
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
        OnlineOngoingChallengeView(quickChallenge: .constant(QuickChallenge(id: "", name: "", type: "", goal: 0, goalMeasure: "", finished: false, ownerId: "", online: false, alreadyBegin: false, maxTeams: 0, createdAt: "", updatedAt: "", teams: [], owner: User(email: "", name: ""))))
    }
}
