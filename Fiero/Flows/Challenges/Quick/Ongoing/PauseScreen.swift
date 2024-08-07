//
//  PauseScreen.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 11/08/22.
//

import SwiftUI

struct PauseScreen: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var quickChallengeViewModel: QuickChallengeViewModel

    @Binding var didTapPauseButton: Bool
    @Binding var didFinishChallenge: Bool
    @Binding var quickChallenge: QuickChallenge
    @State var isShowingAlert: Bool = false

    
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
            VStack(alignment: .center,spacing: Tokens.Spacing.nano.value) {
                Spacer()
                Text(self.quickChallenge.name)
                    .foregroundColor(textColor)
                    .font(textFont)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, Tokens.Spacing.xxxs.value)
                ButtonComponent(style: .primary(isEnabled: true), text: "Continuar desafio") {
                    self.didTapPauseButton.toggle()
                }
                ButtonComponent(style: .secondary(isEnabled: true), text: "Visão geral do desafio") {
                    self.dismiss()
                }
                ButtonComponent(style: .black(isEnabled: true), text: "Finalizar desafio") {
                    isShowingAlert.toggle()
                }
                .alert(isPresented: self.$isShowingAlert, content: {
                    Alert(title: Text("Finalizar desafio"),
                          message: Text("Você tem certeza que deseja finalizar este desafio?"), primaryButton: .destructive(Text("Finalizar desafio"), action: {
                        quickChallengeViewModel.finishChallenge(challengeId: quickChallenge.id, finished: true)
                        self.dismiss()
                    }), secondaryButton: .cancel(Text("Cancelar")))
                })
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
