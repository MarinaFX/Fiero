//
//  GroupComponent.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 20/07/22.
//

import SwiftUI

struct GroupComponent: View {
    @Environment(\.sizeCategory) var sizeCategory
    
    @State var scoreboard: Bool
    @State var style: [ParticipantStyles]
    @Binding var quickChallenge: QuickChallenge
    
    var body: some View {
        ZStack {
            if scoreboard {
                if self.sizeCategory.isAccessibilityCategory {
                    VStack(spacing: Tokens.Spacing.nano.value) {
                        ForEach($quickChallenge.teams) { team in
                            ParticipantComponent(style: style[0], name: team.name, score: Binding(team.members)?.first?.score ?? .constant(0))
                        }
                    }
                    .padding(.all)
                }
                else {
                    HStack(spacing: Tokens.Spacing.nano.value) {
                        ForEach($quickChallenge.teams) { team in
                            ParticipantComponent(style: style[0], name: team.name, score: Binding(team.members)?.first?.score ?? .constant(0))
                        }
                    }
                    .padding(.all)
                }
            }
            else {
                if self.sizeCategory.isAccessibilityCategory {
                    VStack(spacing: Tokens.Spacing.xxxs.value) {
                        ForEach($quickChallenge.teams) { team in
                            ParticipantComponent(style: style[0], name: team.name, score: Binding(team.members)?.first?.score ?? .constant(0))
                        }
                    }
                    .padding(.all)
                }
                else {
                    HStack(spacing: Tokens.Spacing.xxxs.value) {
                        ForEach($quickChallenge.teams) { team in
                            ParticipantComponent(style: style[0], name: team.name, score: Binding(team.members)?.first?.score ?? .constant(0))
                        }
                    }
                    .padding(.all)
                }
            }
        }.frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: Tokens.Border.BorderRadius.small.value)
                .stroke(Tokens.Colors.Neutral.High.pure.value, lineWidth: 2))
    }
}

struct GroupComponent_Previews: PreviewProvider {
    static var previews: some View {
        GroupComponent(scoreboard: true, style: [ ParticipantStyles.participantDefault(isSmall: true),  ParticipantStyles.participantDefault(isSmall: true),  ParticipantStyles.participantDefault(isSmall: true),  ParticipantStyles.participantDefault(isSmall: true)], quickChallenge: .constant(QuickChallenge(id: "teste", name: "Truco", invitationCode: "teste", type: "Quantidade", goal: 3, goalMeasure: "unity", finished: false, ownerId: "teste", online: false, alreadyBegin: true, maxTeams: 4, createdAt: "teste", updatedAt: "teste", teams:
                                                                                                                                                                                                                                                                                                                    [
                                                                                                                                                                                                                                                                                                                        Team(id: "teste1", name: "player1", quickChallengeId: "teste", ownerId: "teste", createdAt: "", updatedAt: "", members: [Member(id: "", score: 22, userId: "", teamId: "", beginDate: "", botPicture: "player1", createdAt: "", updatedAt: "")]),
                                                                                                                                                                                                                                                                                                                        Team(id: "teste2", name: "player2", quickChallengeId: "teste", ownerId: "teste", createdAt: "", updatedAt: "", members: [Member(id: "", score: 12, userId: "", teamId: "", beginDate: "", botPicture: "player2", createdAt: "", updatedAt: "")]),
                                                                                                                                                                                                                                                                                                                        Team(id: "teste3", name: "player3", quickChallengeId: "teste", ownerId: "teste", createdAt: "", updatedAt: "", members: [Member(id: "", score: 43, userId: "", teamId: "", beginDate: "", botPicture: "player3", createdAt: "", updatedAt: "")])
                                                                                                                                                                                                                                                                                                                    ],
                                                                                                                                                                                                                                                                                                                   owner: User(email: "teste", name: "teste"))))
    }
}