//
//  OngoingDuelScreenView.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 08/08/22.
//

import SwiftUI

struct OngoingDuelScreenView: View {
    
    @Binding var quickChallenge: QuickChallenge
    @Binding var didTapPauseButton: Bool
    @Binding var isShowingAlertOnDetailsScreen: Bool
    
    @State var isFinished: Bool = false
    @State var isPresentingLoading: Bool = false
    
    //MARK: - Tokens
    var firstBackgroundColor: Color {
        return Tokens.Colors.Highlight.four.value
    }
    var secondBackgroundColor: Color {
        return Tokens.Colors.Highlight.one.value
    }
    var buttonColor: Color {
        return Tokens.Colors.Neutral.High.pure.value
    }
    var vStackPadding: Double {
        return Tokens.Spacing.defaultMargin.value
    }
    var vStackSpacing: Double {
        return Tokens.Spacing.lg.value
    }
    var pauseNameButton: String {
        return "pause.circle.fill"
    }
    var eyesName: String {
        return "Olhos"
    }
    
    //MARK: - Body
    var body: some View {
        ZStack {
            firstBackgroundColor.ignoresSafeArea()
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    
                    Button {
                        self.didTapPauseButton.toggle()
                        Haptics.shared.play(.light)
                    } label: {
                        Image(systemName: pauseNameButton)
                            .resizable()
                            .foregroundColor(buttonColor)
                            .frame(width: 50, height: 50)
                    }
                }
                .padding(.horizontal, vStackPadding)
                
                ZStack {
                    firstBackgroundColor.ignoresSafeArea()
                    VStack(spacing: vStackSpacing) {
                        
                        DuelScoreComponent(style: .first,
                                           maxValue: self.quickChallenge.goal,
                                           isFinished: $isFinished,
                                           quickChallenge: $quickChallenge,
                                           playerScore: Binding(self.$quickChallenge.teams[0].members)?.first?.score ?? .constant(10),
                                           
                                           isShowingAlertOnDetailsScreen: self.$isShowingAlertOnDetailsScreen,
                                           
                                           challengeId: self.quickChallenge.id,
                                           
                                           teamId: self.quickChallenge.teams[0].id,
                                           
                                           memberId: self.quickChallenge.teams[0].members?.first?.id ?? "ID NOT FOUND",
                                           
                                           playerName: Member.getName(playerName: self.quickChallenge.teams[0].name))
                        .padding(.horizontal, vStackSpacing)
                        Image(eyesName)
                    }
                    NavigationLink("", isActive: $isFinished) {
                        WinScreen(isFinished: $isFinished)
                    }
                    .hidden()
                }
                
                ZStack {
                    secondBackgroundColor.ignoresSafeArea()
                    VStack(spacing: vStackSpacing) {
                        DuelScoreComponent(style: .first,
                                           maxValue: self.quickChallenge.goal,
                                           isFinished: $isFinished,
                                           quickChallenge: $quickChallenge,
                                           playerScore: Binding(self.$quickChallenge.teams[1].members)?.first?.score ?? .constant(10),
                                           
                                           isShowingAlertOnDetailsScreen: self.$isShowingAlertOnDetailsScreen,
                                           
                                           challengeId: self.quickChallenge.id,
                                           
                                           teamId: self.quickChallenge.teams[1].id,
                                           
                                           memberId: self.quickChallenge.teams[1].members?.first?.id ?? "ID NOT FOUND",
                                           
                                           playerName: Member.getName(playerName: self.quickChallenge.teams[1].name))
                        .padding(.horizontal, vStackSpacing)
                        Image(eyesName)
                    }
                }
            }
            if isPresentingLoading {
                ZStack {
                    Tokens.Colors.Neutral.Low.pure.value.edgesIgnoringSafeArea(.all).opacity(0.9)
                    VStack {
                        Spacer()
                        //TODO: - change name of animation loading
                        LottieView(fileName: "loading", reverse: false, loop: false).frame(width: 200, height: 200)
                        Spacer()
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct OngoingDuelScreenView_Previews: PreviewProvider {
    static var previews: some View {
        DuelScreenView(quickChallenge: .constant(QuickChallenge(id: "teste", name: "Truco", invitationCode: "teste", type: "Quantidade", goal: 3, goalMeasure: "unity", finished: false, ownerId: "teste", online: false, alreadyBegin: true, maxTeams: 4, createdAt: "teste", updatedAt: "teste", teams:
                                                                    [
                                                                        Team(id: "teste1", name: "player1", quickChallengeId: "teste", ownerId: "teste", createdAt: "", updatedAt: "", members: [Member(id: "", score: 22, userId: "", teamId: "", beginDate: "", botPicture: "player1", createdAt: "", updatedAt: "")]),
                                                                        Team(id: "teste2", name: "player2", quickChallengeId: "teste", ownerId: "teste", createdAt: "", updatedAt: "", members: [Member(id: "", score: 12, userId: "", teamId: "", beginDate: "", botPicture: "player2", createdAt: "", updatedAt: "")]),
                                                                        Team(id: "teste3", name: "player3", quickChallengeId: "teste", ownerId: "teste", createdAt: "", updatedAt: "", members: [Member(id: "", score: 43, userId: "", teamId: "", beginDate: "", botPicture: "player3", createdAt: "", updatedAt: "")]),
                                                                        Team(id: "teste4", name: "player4", quickChallengeId: "teste", ownerId: "teste", createdAt: "", updatedAt: "", members: [Member(id: "", score: 200, userId: "", teamId: "", beginDate: "", botPicture: "player4", createdAt: "", updatedAt: "")])
                                                                    ],
                                                                owner: User(email: "teste", name: "teste"))), isShowingAlertOnDetailsScreen: .constant(true))
    }
}
