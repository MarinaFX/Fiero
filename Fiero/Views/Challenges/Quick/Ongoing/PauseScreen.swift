//
//  PauseScreen.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 11/08/22.
//

import SwiftUI

struct PauseScreen: View {
    @Binding var didTapPauseButton: Bool
    @Binding var didFinishChallenge: Bool
    @EnvironmentObject var quickChallengeViewModel: QuickChallengeViewModel
    @Binding var quickChallenge: QuickChallenge
    
    //MARK: Colors
    var backgroundColor: Color {
        return Tokens.Colors.Neutral.Low.pure.value
    }
    var textColor: Color {
        return Tokens.Colors.Neutral.High.pure.value
    }
    //MARK: Spacings
    var spacingXXS: Double {
        return Tokens.Spacing.xxs.value
    }
    var spacingDefaultMargin: Double {
        return Tokens.Spacing.defaultMargin.value
    }
    //MARK: Font
    var textFont: Font {
        return Tokens.FontStyle.largeTitle.font(weigth: .bold)
    }
    
    var body: some View {
        ZStack {
            backgroundColor
                .opacity(0.8)
            VStack(spacing: spacingXXS) {
                Spacer()
                Text("Truco")
                    .foregroundColor(textColor)
                    .font(textFont)
                ButtonComponent(style: .primary(isEnabled: true), text: "Retornar ao desafio") {
                    self.didTapPauseButton.toggle()
                }
                ButtonComponent(style: .secondary(isEnabled: true), text: "Ir para a lista de desafios") {
                    self.didFinishChallenge.toggle()
                    RootViewController.popToRootViewController()
                    //call func from ViewModel to update players scores
                    
                    //call func from ViewModel to finish the challenge
                    self.quickChallengeViewModel.finishChallenge(challengeId: quickChallenge.id, finished: true)
                }
            }
            .padding(.horizontal, spacingDefaultMargin)
            .padding(.bottom, 150)
        }
        .background(Color.clear)
        .ignoresSafeArea()
    }
}

struct PauseScreen_Previews: PreviewProvider {
    static var previews: some View {
        PauseScreen(didTapPauseButton: .constant(false), didFinishChallenge: .constant(false), quickChallenge: .constant(QuickChallenge(id: "teste", name: "Truco", invitationCode: "teste", type: "Quantidade", goal: 3, goalMeasure: "unity", finished: false, ownerId: "teste", online: false, alreadyBegin: true, maxTeams: 4, createdAt: "teste", updatedAt: "teste", teams:
                                                                                                                                [
                                                                                                                                    Team(id: "teste1", name: "player1", quickChallengeId: "teste", ownerId: "teste", createdAt: "", updatedAt: "", members: [Member(id: "", score: 22, userId: "", teamId: "", beginDate: "", botPicture: "player1", createdAt: "", updatedAt: "")]),
                                                                                                                                    Team(id: "teste2", name: "player2", quickChallengeId: "teste", ownerId: "teste", createdAt: "", updatedAt: "", members: [Member(id: "", score: 12, userId: "", teamId: "", beginDate: "", botPicture: "player2", createdAt: "", updatedAt: "")]),
                                                                                                                                    Team(id: "teste3", name: "player3", quickChallengeId: "teste", ownerId: "teste", createdAt: "", updatedAt: "", members: [Member(id: "", score: 43, userId: "", teamId: "", beginDate: "", botPicture: "player3", createdAt: "", updatedAt: "")]),
                                                                                                                                    Team(id: "teste4", name: "player4", quickChallengeId: "teste", ownerId: "teste", createdAt: "", updatedAt: "", members: [Member(id: "", score: 200, userId: "", teamId: "", beginDate: "", botPicture: "player4", createdAt: "", updatedAt: "")])
                                                                                                                                ],
                                                                                                                                                                            owner: User(email: "teste", name: "teste"))))
    }
}
