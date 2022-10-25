//
//  OngoingScreen.swift
//  Fiero
//
//  Created by Lucas Dimer Justo on 11/08/22.
//

import SwiftUI

struct OngoingScreen: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var quickChallenge: QuickChallenge
    @Binding var didTapPauseButton: Bool
    @Binding var isShowingAlertOnDetailsScreen: Bool
    
    @State var isFinished: Bool = false
    @State var howManyTimesWinAnimationDidAppear = 0.0
    
    //MARK: - Tokens
    var foregroundColor: Color {
        return Tokens.Colors.Neutral.High.pure.value
    }
    var vStackSpacing: CGFloat {
        return Tokens.Spacing.xxxs.value
    }
    var horizontalSpacing: CGFloat {
        return Tokens.Spacing.xl.value
    }
    var verticalSpacing: CGFloat {
        return Tokens.Spacing.xxxs.value
    }
    var buttonSpacing: CGFloat {
        return Tokens.Spacing.defaultMargin.value
    }
    var hStackPadding: CGFloat {
        return Tokens.Spacing.xs.value
    }
    var pauseButtonName: String {
        return "pause.circle.fill"
    }
    var eyesName: String {
        return "Olhos"
    }
    
    //MARK: - Body
    var body: some View {
        ZStack {
            //MARK: - 4 or more challengers
            if quickChallenge.teams.count >= 4 {
                VStack {
                    Member.getColor(playerName: quickChallenge.teams.first?.name ?? "")
                        .edgesIgnoringSafeArea(.top)
                    
                    Member.getColor(playerName: quickChallenge.teams.last?.name ?? "")
                        .edgesIgnoringSafeArea(.bottom)
                }
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        ForEach(self.$quickChallenge.teams) { team in
                            ZStack {
                                Member.getColor(playerName: team.wrappedValue.name)
                                    .ignoresSafeArea()
                                
                                VStack(spacing: Tokens.Spacing.xxxs.value) {
                                    Image("Olhos")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.09)
                                    
                                    ScoreController(playerScore: Binding(team.members)?.first?.score ?? .constant(0),
                                                                quickChallenge: $quickChallenge,
                                                                isFinished: $isFinished,
                                                                isShowingAlertOnDetailsScreen: self.$isShowingAlertOnDetailsScreen,
                                                                playerName: Member.getName(playerName: team.wrappedValue.name),
                                                                challengeId: quickChallenge.id,
                                                                teamId: team.wrappedValue.id,
                                                                memberId: team.wrappedValue.members?[0].id ?? "")
                                    .frame(height: UIScreen.main.bounds.height * 0.09)
                                }
                                .padding(.horizontal, Tokens.Spacing.xl.value)
                                .padding(.vertical, Tokens.Spacing.xxxs.value)
                            }
                        }
                        if howManyTimesWinAnimationDidAppear <= 1 {
                            NavigationLink("", isActive: $isFinished) {
                                WinScreen(isFinished: $isFinished, winnerName: "Alpaca")
                            }
                            .onAppear(perform: {
                                howManyTimesWinAnimationDidAppear += 1
                                print(howManyTimesWinAnimationDidAppear)
                            })
                            .hidden()
                        }
                    }
                    .edgesIgnoringSafeArea(.bottom)
                }
            }
            else {
                VStack(spacing: 0) {
                    if quickChallenge.teams.count == 2 {
                        //MARK: - Duel
                        ForEach(self.$quickChallenge.teams) { team in
                            ZStack {
                                Member.getColor(playerName: team.wrappedValue.name)
                                    .ignoresSafeArea()
                                
                                VStack(spacing: Tokens.Spacing.xxxs.value) {
                                    Image("Olhos")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height * 0.15)
                                    
                                    ScoreController(playerScore: Binding(team.members)?.first?.score ?? .constant(0),
                                                                quickChallenge: $quickChallenge,
                                                                isFinished: $isFinished,
                                                                isShowingAlertOnDetailsScreen: self.$isShowingAlertOnDetailsScreen,
                                                                playerName: Member.getName(playerName: team.wrappedValue.name),
                                                                challengeId: quickChallenge.id,
                                                                teamId: team.wrappedValue.id,
                                                                memberId: team.wrappedValue.members?[0].id ?? "")
                                    .frame(height: UIScreen.main.bounds.height * 0.19)
                                }
                                .padding(.horizontal, Tokens.Spacing.xl.value)
                                .padding(.vertical, Tokens.Spacing.xxxs.value)
                            }
                        }
                    }
                    else {
                        //MARK: - 3 challengers
                        ForEach(self.$quickChallenge.teams) { team in
                            ZStack {
                                Member.getColor(playerName: team.wrappedValue.name)
                                    .ignoresSafeArea()
                                
                                VStack(spacing: Tokens.Spacing.xxxs.value) {
                                    Image("Olhos")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height * 0.15)
                                    
                                    ScoreController(playerScore: Binding(team.members)?.first?.score ?? .constant(0),
                                                                quickChallenge: $quickChallenge,
                                                                isFinished: $isFinished,
                                                                isShowingAlertOnDetailsScreen: self.$isShowingAlertOnDetailsScreen,
                                                                playerName: Member.getName(playerName: team.wrappedValue.name),
                                                                challengeId: quickChallenge.id,
                                                                teamId: team.wrappedValue.id,
                                                                memberId: team.wrappedValue.members?[0].id ?? "")
                                    .frame(height: UIScreen.main.bounds.height * 0.09)
                                    
                                }
                                .padding(.horizontal, Tokens.Spacing.xl.value)
                                .padding(.vertical, Tokens.Spacing.xxxs.value)
                            }
                        }
                    }
                    if howManyTimesWinAnimationDidAppear <= 1 {
                        NavigationLink("", isActive: $isFinished) {
                            WinScreen(isFinished: $isFinished, winnerName: "Alpaca")
                        }
                        .onAppear(perform: {
                            howManyTimesWinAnimationDidAppear += 1
                            print(howManyTimesWinAnimationDidAppear)
                        })
                        .hidden()
                    }
                }
                .edgesIgnoringSafeArea(.bottom)
            }
            
            HStack {
                Spacer ()
                
                Button {
                    didTapPauseButton.toggle()
                    HapticsController.shared.activateHaptics(hapticsfeedback: .light)
                } label: {
                    Image(systemName: "pause.circle.fill")
                        .resizable()
                        .foregroundColor(foregroundColor)
                        .frame(width: UIScreen.main.bounds.width * 0.1, height: UIScreen.main.bounds.width * 0.1)
                }
                .padding(.trailing, Tokens.Spacing.defaultMargin.value)

            }
            .padding(.top, -(UIScreen.main.bounds.height/2 - Tokens.Spacing.xs.value))
            
        }
    }
}

struct Ongoing3_4ScreenView_Previews: PreviewProvider {
    
    static var previews: some View {
        OngoingWithPause(quickChallenge: .constant(QuickChallenge(id: "teste", name: "Truco", invitationCode: "teste", type: "Quantidade", goal: 3, goalMeasure: "unity", finished: false, ownerId: "teste", online: false, alreadyBegin: true, maxTeams: 4, createdAt: "teste", updatedAt: "teste", teams:
                [
                    Team(id: "teste1", name: "player1", quickChallengeId: "teste", ownerId: "teste", createdAt: "", updatedAt: "", members: [Member(id: "", score: 22, userId: "", teamId: "", beginDate: "", botPicture: "player1", createdAt: "", updatedAt: "")]),
                    Team(id: "teste2", name: "player2", quickChallengeId: "teste", ownerId: "teste", createdAt: "", updatedAt: "", members: [Member(id: "", score: 12, userId: "", teamId: "", beginDate: "", botPicture: "player2", createdAt: "", updatedAt: "")]),
                    Team(id: "teste3", name: "player3", quickChallengeId: "teste", ownerId: "teste", createdAt: "", updatedAt: "", members: [Member(id: "", score: 43, userId: "", teamId: "", beginDate: "", botPicture: "player3", createdAt: "", updatedAt: "")]),
                    Team(id: "teste4", name: "player4", quickChallengeId: "teste", ownerId: "teste", createdAt: "", updatedAt: "", members: [Member(id: "", score: 200, userId: "", teamId: "", beginDate: "", botPicture: "player4", createdAt: "", updatedAt: "")])
                ],
                                                                                owner: User(email: "teste", name: "teste"))), isShowingAlertOnDetailsScreen: .constant(false))
    }
}
