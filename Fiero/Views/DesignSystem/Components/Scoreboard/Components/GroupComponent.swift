//
//  GroupComponent.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 20/07/22.
//

import SwiftUI

struct GroupComponent: View {
    @State var scoreboard: Bool
    @State var style: [ParticipantStyles]
    @Binding var quickChallenge: QuickChallenge
    
    var body: some View {
        ZStack {
            
            if scoreboard {
                ZStack {
                    RoundedRectangle(cornerRadius: Tokens.Border.BorderRadius.small.value)
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                    
                    HStack(spacing: Tokens.Spacing.nano.value) {
                        ForEach($quickChallenge.teams) { team in
                            ParticipantComponent(style: style[0], name: team.name, score: .constant(team.members.wrappedValue?.first?.score ?? 0.0))
                        }
                    }
                    
                }
            }
            else {
                HStack(spacing: Tokens.Spacing.xxxs.value) {
                    ForEach($quickChallenge.teams, id: \.id) { team in
                        ParticipantComponent(style: style[0], name: team.name, score: .constant(team.members.wrappedValue?.first?.score ?? 0.0))
                    }
                }
                .padding(.all)
                .background(RoundedRectangle(cornerRadius: 11).fill(Color.white))
            }
        }
    }
}

struct GroupComponent_Previews: PreviewProvider {
    static var previews: some View {
        GroupComponent(scoreboard: true, style: [ ParticipantStyles.participantDefault(isSmall: true),  ParticipantStyles.participantDefault(isSmall: true),  ParticipantStyles.participantDefault(isSmall: true),  ParticipantStyles.participantDefault(isSmall: true)], quickChallenge: .constant(QuickChallenge(id: "teste", name: "Truco", invitationCode: "teste", type: "Quantidade", goal: 3, goalMeasure: "unity", finished: false, ownerId: "teste", online: false, alreadyBegin: true, maxTeams: 4, createdAt: "teste", updatedAt: "teste", teams:
                                                                            [
                                                                                Team(id: "teste1", name: "player1", quickChallengeId: "teste", ownerId: "teste", createdAt: "", updatedAt: "", members: [Member(id: "", score: 22, userId: "", teamId: "", beginDate: "", botPicture: "player1", createdAt: "", updatedAt: "")]),
                                                                                Team(id: "teste2", name: "player2", quickChallengeId: "teste", ownerId: "teste", createdAt: "", updatedAt: "", members: [Member(id: "", score: 12, userId: "", teamId: "", beginDate: "", botPicture: "player2", createdAt: "", updatedAt: "")]),
                                                                                Team(id: "teste3", name: "player3", quickChallengeId: "teste", ownerId: "teste", createdAt: "", updatedAt: "", members: [Member(id: "", score: 43, userId: "", teamId: "", beginDate: "", botPicture: "player3", createdAt: "", updatedAt: "")]),
                                                                                Team(id: "teste4", name: "player4", quickChallengeId: "teste", ownerId: "teste", createdAt: "", updatedAt: "", members: [Member(id: "", score: 200, userId: "", teamId: "", beginDate: "", botPicture: "player4", createdAt: "", updatedAt: "")])
                                                                            ],
                                                                            owner: User(email: "teste", name: "teste"))))
    }
}
