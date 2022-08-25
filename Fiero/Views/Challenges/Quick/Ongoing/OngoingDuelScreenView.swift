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
            firstBackgroundColor
            VStack(spacing: 0) {
                ZStack {
                    firstBackgroundColor
                    VStack(spacing: Tokens.Spacing.lg.value) {
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
                        
                        DuelScoreComponent(style: .first, playerScore: Binding(self.$quickChallenge.teams[0].members)?.first?.score ?? .constant(10), challengeId: self.quickChallenge.id, teamId: self.quickChallenge.teams[0].id, memberId: self.quickChallenge.teams[0].members?.first?.id ?? "ID NOT FOUND", playerName: self.quickChallenge.teams[0].name)
                            .padding(.horizontal, Tokens.Spacing.lg.value)
                        Image("Olhos")
                    }
                }
                    
                ZStack {
                    secondBackgroundColor
                    VStack(spacing: Tokens.Spacing.lg.value) {
                        DuelScoreComponent(style: .first, playerScore: Binding(self.$quickChallenge.teams[1].members)?.first?.score ?? .constant(10), challengeId: self.quickChallenge.id, teamId: self.quickChallenge.teams[1].id, memberId: self.quickChallenge.teams[1].members?.first?.id ?? "ID NOT FOUND", playerName: self.quickChallenge.teams[1].name)
                            .padding(.horizontal, Tokens.Spacing.lg.value)
                        Image("Olhos")
                    }
                }
            }
        }
        .ignoresSafeArea(.all, edges: .all)
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
                owner: User(email: "teste", name: "teste"))))
    }
}
