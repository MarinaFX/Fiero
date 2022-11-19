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
    @State private var originalScore: Double = 0.0
    @State private var timeRemaining = 15
    
    @Binding var quickChallenge: QuickChallenge
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
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
                
                PlayerScoreControllerView(quickChallenge: self.$quickChallenge, originalScore: self.$originalScore, teamId: self.quickChallenge.getTeamIdByMemberId(memberUserId: UserDefaults.standard.string(forKey: UDKeysEnum.userID.description) ?? ""))
                    .padding(.bottom, Tokens.Spacing.xs.value)
                
                Text("Lideres")
                    .font(Tokens.FontStyle.title2.font(weigth: .regular, design: .default))
                
                LeaderboardView(quickChallenge: self.$quickChallenge)
                    .cornerRadius(Tokens.Border.BorderRadius.small.value)
                    .padding(.bottom, Tokens.Spacing.xs.value)
                
                Text("Sua posição")
                    .font(Tokens.FontStyle.title2.font(weigth: .regular, design: .default))
                
                VStack(spacing: Tokens.Spacing.nano.value) {
                    RankedPlayersView(quickChallenge: self.$quickChallenge, userPosition: self.quickChallenge.getTeamPositionAtRanking(teamId: self.quickChallenge.getTeamIdByMemberId(memberUserId: UserDefaults.standard.string(forKey: UDKeysEnum.userID.description) ?? "")))
                }
                .padding(.horizontal, Tokens.Spacing.defaultMargin.value)
                .padding(.bottom, Tokens.Spacing.sm.value)
                
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarTrailing ,content: {
                        Button(action: {
                            guard let userId = UserDefaults.standard.string(forKey: UDKeysEnum.userID.description) else { return }
                            
                            let memberId = self.quickChallenge.getMemberIdByUserId(userId: userId)
                            
                            let teamId = self.quickChallenge.getTeamIdByMemberId(memberUserId: userId)
                            
                            let position = self.quickChallenge.getTeamIndexById(teamId: teamId)
                            
                            guard let actualScore = self.quickChallenge.teams[position].members?[0].score else { return }
                            
                            if actualScore != originalScore {
                                self.quickChallengeViewModel.patchScore(challengeId: self.quickChallenge.id, teamId: teamId, memberId: memberId, score: actualScore)
                                    .flatMap({ _ in
                                        return self.quickChallengeViewModel.getChallenge(by: self.quickChallenge.id)
                                    })
                                    .sink(receiveCompletion: { completion in
                                        switch completion {
                                            case .failure(_):
                                                self.timeRemaining = 15
                                            case .finished:
                                                print("updated view scores")
                                        }
                                    }, receiveValue: { quickChallenge in
                                        self.quickChallenge = quickChallenge
                                        self.originalScore = actualScore
                                        self.timeRemaining = 15
                                    })
                                    .store(in: &subscriptions)
                            }
                            else {
                                self.quickChallengeViewModel.getChallenge(by: self.quickChallenge.id)
                                    .sink(receiveCompletion: { completion in
                                        switch completion {
                                            case .failure(_):
                                                self.timeRemaining = 15
                                            case .finished:
                                                print("updated view scores")
                                        }
                                    }, receiveValue: { quickChallenge in
                                        self.quickChallenge = quickChallenge
                                        self.timeRemaining = 15
                                    })
                                    .store(in: &subscriptions)
                            }
                        }, label: {
                            Image(systemName: "arrow.triangle.2.circlepath")
                        })
                    })
                })
            }
        }
        .onReceive(self.timer, perform: { time in
            if self.timeRemaining > 0 {
                print(self.timeRemaining)
                self.timeRemaining -= 1
            }
            else {
                guard let userId = UserDefaults.standard.string(forKey: UDKeysEnum.userID.description) else { return }
                
                let memberId = self.quickChallenge.getMemberIdByUserId(userId: userId)
                
                let teamId = self.quickChallenge.getTeamIdByMemberId(memberUserId: userId)
                
                let position = self.quickChallenge.getTeamIndexById(teamId: teamId)
                
                guard let actualScore = self.quickChallenge.teams[position].members?[0].score else { return }
                
                self.quickChallengeViewModel.patchScore(challengeId: self.quickChallenge.id, teamId: teamId, memberId: memberId, score: actualScore)
                    .flatMap({ _ in
                        return self.quickChallengeViewModel.getChallenge(by: self.quickChallenge.id)
                    })
                    .sink(receiveCompletion: { completion in
                        switch completion {
                            case .failure(_):
                                self.timeRemaining = 15
                            case .finished:
                                print("updated view scores")
                        }
                    }, receiveValue: { quickChallenge in
                        self.quickChallenge = quickChallenge
                        self.timeRemaining = 15
                    })
                    .store(in: &subscriptions)
            }
        })
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
                ScoreList(style: .owner, position: userPosition + 1, name: self.quickChallenge.getRanking()[userPosition].name, quickChallenge: self.$quickChallenge)
                
                ScoreList(style: .player, position: userPosition + 2, name: self.quickChallenge.getRanking()[userPosition+1].name, quickChallenge: self.$quickChallenge)
                
                ScoreList(style: .player, position: userPosition + 3, name: self.quickChallenge.getRanking()[userPosition+2].name, quickChallenge: self.$quickChallenge)
            }
            else {
                if userPosition == self.quickChallenge.teams.count - 1 {
                    ScoreList(style: .player, position: userPosition - 1, name: self.quickChallenge.getRanking()[userPosition-2].name, quickChallenge: self.$quickChallenge)
                    
                    ScoreList(style: .player, position: userPosition, name: self.quickChallenge.getRanking()[userPosition-1].name, quickChallenge: self.$quickChallenge)
                    
                    ScoreList(style: .owner, position: userPosition + 1, name: self.quickChallenge.getRanking()[userPosition].name, quickChallenge: self.$quickChallenge)
                }
                else {
                    ScoreList(style: .player, position: userPosition, name: self.quickChallenge.getRanking()[userPosition-1].name, quickChallenge: self.$quickChallenge)
                    
                    ScoreList(style: .owner, position: userPosition + 1, name: self.quickChallenge.getRanking()[userPosition].name, quickChallenge: self.$quickChallenge)
                    
                    ScoreList(style: .player, position: userPosition + 2, name: self.quickChallenge.getRanking()[userPosition+1].name, quickChallenge: self.$quickChallenge)
                }
            }
        }
        else {
            if self.quickChallenge.teams.count == 2 {
                if userPosition == 0 {
                    ScoreList(style: .owner, position: userPosition + 1, name: self.quickChallenge.getRanking()[userPosition].name, quickChallenge: self.$quickChallenge)
                    
                    ScoreList(style: .player, position: userPosition + 2, name: self.quickChallenge.getRanking()[userPosition+1].name, quickChallenge: self.$quickChallenge)
                }
                else {
                    ScoreList(style: .player, position: userPosition, name: self.quickChallenge.getRanking()[userPosition-1].name, quickChallenge: self.$quickChallenge)
                    
                    ScoreList(style: .owner, position: userPosition + 1, name: self.quickChallenge.getRanking()[userPosition].name, quickChallenge: self.$quickChallenge)
                }
            }
            else {
                ScoreList(style: .owner, position: userPosition + 1, name: self.quickChallenge.getRanking()[userPosition].name, quickChallenge: self.$quickChallenge)
            }
        }
    }
}

struct PlayerScoreControllerView: View {
    
    @Binding var quickChallenge: QuickChallenge
    @Binding var originalScore: Double
    
    let teamId: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: Tokens.Border.BorderRadius.small.value)
            .padding(.horizontal, 32)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.1)
            .foregroundColor(Tokens.Colors.Neutral.Low.pure.value)
            .overlay(content: {
                HStack {
                    Button(action: {
                        let position = self.quickChallenge.getTeamIndexById(teamId: teamId)
                        if position >= 0 {
                            self.quickChallenge.teams[position].members?[0].score -= 1
                        }
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
                        let position = self.quickChallenge.getTeamIndexById(teamId: teamId)
                        if position >= 0 {
                            self.quickChallenge.teams[position].members?[0].score += 1
                        }
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
            .onAppear(perform: {
                let position = self.quickChallenge.getTeamIndexById(teamId: teamId)
                if position >= 0 {
                    self.originalScore = self.quickChallenge.teams[position].members?[0].score ?? -1.0
                }
            })
    }
}

struct OnlineOngoingChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        OnlineOngoingChallengeView(quickChallenge: .constant(QuickChallenge(id: "", name: "", type: "", goal: 0, goalMeasure: "", finished: false, ownerId: "", online: false, alreadyBegin: false, maxTeams: 0, createdAt: "", updatedAt: "", teams: [], owner: User(email: "", name: ""))))
    }
}
