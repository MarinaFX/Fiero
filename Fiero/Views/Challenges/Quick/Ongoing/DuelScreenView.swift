//
//  DuelScreenView.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 12/08/22.
//

import SwiftUI

struct DuelScreenView: View {
    @State var didTapPauseButton: Bool = false
    @State var didFinishChallenge: Bool = false
    @State var isPresentingAlert: Bool = false
    @Binding var quickChallenge: QuickChallenge

    var body: some View {
        ZStack {
            OngoingDuelScreenView(didTapPauseButton: $didTapPauseButton)
            if self.didTapPauseButton {
                PauseScreen(didTapPauseButton: $didTapPauseButton, didFinishChallenge: $didFinishChallenge, quickChallenge: $quickChallenge)
                if self.didFinishChallenge {
                    HomeView()
                }
            }
        }
    }
}

struct DuelScreenView_Previews: PreviewProvider {
    static var previews: some View {
        DuelScreenView(quickChallenge: .constant(QuickChallenge(id: "teste", name: "Truco", invitationCode: "teste", type: "Quantidade", goal: 3, goalMeasure: "unity", finished: false, ownerId: "teste", online: false, alreadyBegin: true, maxTeams: 2, createdAt: "teste", updatedAt: "teste", teams:
                                                                    [
                                                                        Team(id: "teste1", name: "player1", quickChallengeId: "teste", ownerId: "teste", createdAt: "", updatedAt: "", members: [Member(id: "", score: 22, userId: "", teamId: "", beginDate: "", botPicture: "player1", createdAt: "", updatedAt: "")]),
                                                                        Team(id: "teste2", name: "player2", quickChallengeId: "teste", ownerId: "teste", createdAt: "", updatedAt: "", members: [Member(id: "", score: 12, userId: "", teamId: "", beginDate: "", botPicture: "player2", createdAt: "", updatedAt: "")])
                                                                    ],
                                                                                                                owner: User(email: "teste", name: "teste"))))
    }
}
