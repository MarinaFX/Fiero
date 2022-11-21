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
    @Environment(\.dismiss) var dismissView
    @EnvironmentObject var quickChallengeViewModel: QuickChallengeViewModel
    
    @State var subscriptions: Set<AnyCancellable> = []
    @State private var originalScore: Double = 0.0
    @State private var timeRemaining = 1
    
    @Binding var quickChallenge: QuickChallenge
    
    @State var isFinished: Bool = false
    
    let timeThreshold = 1
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
                
                Text("\(quickChallenge.goal) pontos")
                    .padding(.bottom, Tokens.Spacing.xs.value)
                
                Text("playerLabel")
                    .font(Tokens.FontStyle.title2.font(weigth: .regular, design: .default))
                
                PlayerScoreControllerView(quickChallenge: self.$quickChallenge, originalScore: self.$originalScore, isFinished: $isFinished, teamId: self.quickChallenge.getTeamIdByMemberId(memberUserId: UserDefaults.standard.string(forKey: UDKeysEnum.userID.description) ?? ""))
                    .padding(.bottom, Tokens.Spacing.xs.value)
                
                Text("leadersLabel")
                    .font(Tokens.FontStyle.title2.font(weigth: .regular, design: .default))
                
                LeaderboardView(quickChallenge: self.$quickChallenge)
                    .cornerRadius(Tokens.Border.BorderRadius.small.value)
                    .padding(.bottom, Tokens.Spacing.xs.value)
                
                Text("positionLabel")
                    .font(Tokens.FontStyle.title2.font(weigth: .regular, design: .default))
                
                VStack(spacing: Tokens.Spacing.nano.value) {
                    RankedPlayersView(quickChallenge: self.$quickChallenge, userPosition: self.quickChallenge.getTeamPositionAtRanking(teamId: self.quickChallenge.getTeamIdByMemberId(memberUserId: UserDefaults.standard.string(forKey: UDKeysEnum.userID.description) ?? "")))
                }
                .padding(.horizontal, Tokens.Spacing.defaultMargin.value)
                .padding(.bottom, Tokens.Spacing.sm.value)
                
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarLeading, content: {
                        Button(role: .cancel, action: {
                            guard let userId = UserDefaults.standard.string(forKey: UDKeysEnum.userID.description) else { return }
                            
                            let memberId = self.quickChallenge.getMemberIdByUserId(userId: userId)
                            
                            let teamId = self.quickChallenge.getTeamIdByMemberId(memberUserId: userId)
                            
                            let position = self.quickChallenge.getTeamIndexById(teamId: teamId)
                            
                            guard let actualScore = self.quickChallenge.teams[position].members?[0].score else { return }
                            
                            if !quickChallenge.finished {
                                self.quickChallengeViewModel.patchScore(challengeId: self.quickChallenge.id, teamId: teamId, memberId: memberId, score: actualScore)
                                    .flatMap({ _ in
                                        return self.quickChallengeViewModel.getChallenge(by: self.quickChallenge.id)
                                    })
                                    .sink(receiveCompletion: { completion in
                                        switch completion {
                                            case .failure(_):
                                                self.timeRemaining = self.timeThreshold
                                            case .finished:
                                                self.dismissView()
                                        }
                                    }, receiveValue: { quickChallenge in
                                        self.quickChallenge = quickChallenge
                                        self.originalScore = actualScore
                                        self.timeRemaining = self.timeThreshold
                                    })
                                    .store(in: &subscriptions)
                            } else {
                                self.dismissView()
                            }
                            
                        }, label: {
                            HStack {
                                Image(systemName: "chevron.left")
                                
                                Text("Back")
                            }
                        })
                    })
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
                                                self.timeRemaining = self.timeThreshold
                                            case .finished:
                                                print("updated view scores")
                                        }
                                    }, receiveValue: { quickChallenge in
                                        self.quickChallenge = quickChallenge
                                        self.originalScore = actualScore
                                        self.timeRemaining = self.timeThreshold
                                    })
                                    .store(in: &subscriptions)
                            }
                            else {
                                self.quickChallengeViewModel.getChallenge(by: self.quickChallenge.id)
                                    .sink(receiveCompletion: { completion in
                                        switch completion {
                                            case .failure(_):
                                                self.timeRemaining = self.timeThreshold
                                            case .finished:
                                                print("updated view scores")
                                        }
                                    }, receiveValue: { quickChallenge in
                                        self.quickChallenge = quickChallenge
                                        self.timeRemaining = self.timeThreshold
                                    })
                                    .store(in: &subscriptions)
                            }
                        }, label: {
                            Image(systemName: "arrow.triangle.2.circlepath")
                        })
                    })
                })
            }
            NavigationLink("", isActive: $isFinished) {
                WinScreen(isFinished: $isFinished, winnerName: "Alpaca")
            }.hidden()
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
                                self.timeRemaining = self.timeThreshold
                            case .finished:
                                print("updated view scores")
                        }
                    }, receiveValue: { quickChallenge in
                        self.quickChallenge = quickChallenge
                        self.timeRemaining = self.timeThreshold
                    })
                    .store(in: &subscriptions)
            }
        })
        .navigationBarBackButtonHidden()
        .environment(\.colorScheme, .dark)
        .onChange(of: isFinished, perform: { _ in
            quickChallengeViewModel.finishChallenge(challengeId: quickChallenge.id, finished: true)
        })
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
    @Binding var isFinished: Bool
    
    let teamId: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: Tokens.Border.BorderRadius.small.value)
            .padding(.horizontal, 32)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.1)
            .foregroundColor(Tokens.Colors.Neutral.Low.dark.value)
            .overlay(content: {
                HStack {
                    if !quickChallenge.finished {
                        Button(action: {
                            let position = self.quickChallenge.getTeamIndexById(teamId: teamId)
                            if position >= 0 {
                                self.quickChallenge.teams[position].members?[0].score -= 1
                            }
                            if self.quickChallenge.teams[position].members?[0].score == Double(quickChallenge.goal) && !quickChallenge.finished {
                                isFinished = true
                            }
                        }, label: {
                            Image(systemName: "minus.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                                .padding(.horizontal, 48)
                            })
                    }
                    
                    Spacer()
                    
                    Text(String(format: "%.0f", self.quickChallenge.teams.first(where: { $0.ownerId == UserDefaults.standard.string(forKey: UDKeysEnum.userID.description)})?.getTotalScore() ?? -1.0))
                        .font(Tokens.FontStyle.largeTitle.font(weigth: .bold, design: .default))
                    
                    Spacer()
                    
                    if !quickChallenge.finished {
                        Button(action: {
                            let position = self.quickChallenge.getTeamIndexById(teamId: teamId)
                            if position >= 0 {
                                self.quickChallenge.teams[position].members?[0].score += 1
                            }
                            if self.quickChallenge.teams[position].members?[0].score == Double(quickChallenge.goal) && !quickChallenge.finished {
                                isFinished = true
                            }
                        }, label: {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                                .padding(.horizontal, 48)
                        })
                    }
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
