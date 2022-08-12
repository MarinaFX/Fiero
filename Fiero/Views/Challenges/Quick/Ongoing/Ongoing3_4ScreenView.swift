//
//  Ongoing3_4ScreenView.swift
//  Fiero
//
//  Created by Lucas Dimer Justo on 11/08/22.
//

import SwiftUI

struct Ongoing3_4ScreenView: View {
    @State var quickChallenge: QuickChallenge
    
    var body: some View {
        ZStack {
            Tokens.Colors.Highlight.one.value
            VStack {
                Text(quickChallenge.type)
                    .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                    .font(Tokens.FontStyle.callout.font(weigth: .regular))
                    .padding(.top, 57.5)
                
                Text(quickChallenge.name)
                    .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                    .font(Tokens.FontStyle.largeTitle.font(weigth: .bold))
                    .padding(.top, Tokens.Spacing.nano.value)
                    .padding(.bottom, Tokens.Spacing.xxxs.value)
                
                GroupComponent(scoreboard: true, style: quickChallenge.teams.map({ team in
                        ParticipantStyles.participantDefault(isSmall: true)
                }), quickChallenge: $quickChallenge)
                .padding([.horizontal], Tokens.Spacing.xxxs.value)
                
                VStack(spacing: Tokens.Spacing.quarck.value) {
                    ForEach($quickChallenge.teams) { team in
                        ScoreController3_4Component(
                            foreGroundColor: Member.getColor(playerName: team.wrappedValue.name),
                            playerName: team.wrappedValue.name,
                            playerScore: Binding(team.members)?.first?.score ?? .constant(0))
                        .padding(.horizontal, Tokens.Spacing.xxxs.value)
                    }
                }
                
                ButtonComponent(style: .secondary(isEnabled: true), text: "Finalizar desafio") {
                    //call func from ViewModel to update players scores
                    
                    //call func from ViewModel to finish the challenge
                }
                .padding(.bottom, Tokens.Spacing.md.value)
                .padding(.top, Tokens.Spacing.xxs.value)
                .padding(.horizontal, Tokens.Spacing.xxxs.value)
            }
            
        }
        .ignoresSafeArea()
    }
}

struct Ongoing3_4ScreenView_Previews: PreviewProvider {
    static var previews: some View {
        Ongoing3_4ScreenView(quickChallenge: QuickChallenge(id: "teste", name: "Truco", invitationCode: "teste", type: "Quantidade", goal: 3, goalMeasure: "unity", finished: false, ownerId: "teste", online: false, alreadyBegin: true, maxTeams: 4, createdAt: "teste", updatedAt: "teste", teams:
                [
                    Team(id: "teste1", name: "player1", quickChallengeId: "teste", ownerId: "teste", createdAt: "", updatedAt: "", members: [Member(id: "", score: 22, userId: "", teamId: "", beginDate: "", botPicture: "player1", createdAt: "", updatedAt: "")]),
                    Team(id: "teste2", name: "player2", quickChallengeId: "teste", ownerId: "teste", createdAt: "", updatedAt: "", members: [Member(id: "", score: 12, userId: "", teamId: "", beginDate: "", botPicture: "player2", createdAt: "", updatedAt: "")]),
                    Team(id: "teste3", name: "player3", quickChallengeId: "teste", ownerId: "teste", createdAt: "", updatedAt: "", members: [Member(id: "", score: 43, userId: "", teamId: "", beginDate: "", botPicture: "player3", createdAt: "", updatedAt: "")]),
                    Team(id: "teste4", name: "player4", quickChallengeId: "teste", ownerId: "teste", createdAt: "", updatedAt: "", members: [Member(id: "", score: 200, userId: "", teamId: "", beginDate: "", botPicture: "player4", createdAt: "", updatedAt: "")])
                ],
                owner: User(email: "teste", name: "teste")))
    }
}
