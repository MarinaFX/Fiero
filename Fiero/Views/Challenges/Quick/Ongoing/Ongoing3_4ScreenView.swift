//
//  Ongoing3_4ScreenView.swift
//  Fiero
//
//  Created by Lucas Dimer Justo on 11/08/22.
//

import SwiftUI

struct Ongoing3Or4WithPauseScreenView: View {
    @Binding var quickChallenge: QuickChallenge
    @State var didTapPauseButton: Bool = false
    @State var didFinishChallenge: Bool = false
    
    var body: some View {
        ZStack {
            Ongoing3_4ScreenView(quickChallenge: self.$quickChallenge, didTapPauseButton: self.$didTapPauseButton)
            if self.didTapPauseButton {
                PauseScreen(didTapPauseButton: self.$didTapPauseButton, didFinishChallenge: self.$didFinishChallenge, quickChallenge: self.$quickChallenge)
                if self.didFinishChallenge {
                    HomeView()
                }
            }
        }
    }
}

struct Ongoing3_4ScreenView: View {
    @Binding var quickChallenge: QuickChallenge
    @Binding var didTapPauseButton: Bool
    
    var body: some View {
        ZStack {
            Tokens.Colors.Highlight.one.value
            VStack {
                HStack {
                    Button {
                        self.didTapPauseButton.toggle()
                    } label: {
                        Image(systemName: "pause.circle.fill")
                            .resizable()
                            .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                            .frame(width: 40, height: 40)
                    }
                    .frame(
                          minWidth: 0,
                          maxWidth: .infinity,
                          minHeight: 0,
                          maxHeight: .infinity,
                          alignment: .topTrailing
                        )
                    .padding(.top, Tokens.Spacing.md.value)
                    .padding(.trailing, Tokens.Spacing.defaultMargin.value)
                }
            }
            VStack {
                Text(self.quickChallenge.type)
                    .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                    .font(Tokens.FontStyle.callout.font(weigth: .regular))
                    .padding(.top, 57.5)
                
                Text(self.quickChallenge.name)
                    .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                    .font(Tokens.FontStyle.largeTitle.font(weigth: .bold))
                    .padding(.top, Tokens.Spacing.nano.value)
                    .padding(.bottom, Tokens.Spacing.xxxs.value)
                
                GroupComponent(scoreboard: true, style: self.quickChallenge.teams.map({ team in
                        ParticipantStyles.participantDefault(isSmall: true)
                }), quickChallenge: self.$quickChallenge)
                .frame(height: UIScreen.main.bounds.height * 0.2)
                .padding([.horizontal], Tokens.Spacing.defaultMargin.value)
                
                VStack(spacing: Tokens.Spacing.quarck.value) {
                    ForEach(self.$quickChallenge.teams) { team in
                        ScoreController3_4Component(
                            foreGroundColor: Member.getColor(playerName: team.wrappedValue.name),
                            playerName: team.wrappedValue.name,
                            challengeId: self.quickChallenge.id,
                            teamId: team.wrappedValue.id,
                            memberId: team.wrappedValue.members?[0].id ?? "",
                            playerScore: Binding(team.members)?.first?.score ?? .constant(10))
                        .padding(.horizontal, Tokens.Spacing.defaultMargin.value)
                    }
                }
                
                ButtonComponent(style: .secondary(isEnabled: true), text: "Ir para a lista de desafios") {
                    RootViewController.popToRootViewController()
                }
                .padding(.bottom, Tokens.Spacing.md.value)
                .padding(.top, Tokens.Spacing.xxs.value)
                .padding(.horizontal, Tokens.Spacing.defaultMargin.value)
            }
            
        }
        .navigationBarHidden(true)
        .ignoresSafeArea(.all, edges: .all)
    }
}

struct Ongoing3_4ScreenView_Previews: PreviewProvider {
    
    static var previews: some View {
        Ongoing3Or4WithPauseScreenView(quickChallenge: .constant(QuickChallenge(id: "teste", name: "Truco", invitationCode: "teste", type: "Quantidade", goal: 3, goalMeasure: "unity", finished: false, ownerId: "teste", online: false, alreadyBegin: true, maxTeams: 4, createdAt: "teste", updatedAt: "teste", teams:
                [
                    Team(id: "teste1", name: "player1", quickChallengeId: "teste", ownerId: "teste", createdAt: "", updatedAt: "", members: [Member(id: "", score: 22, userId: "", teamId: "", beginDate: "", botPicture: "player1", createdAt: "", updatedAt: "")]),
                    Team(id: "teste2", name: "player2", quickChallengeId: "teste", ownerId: "teste", createdAt: "", updatedAt: "", members: [Member(id: "", score: 12, userId: "", teamId: "", beginDate: "", botPicture: "player2", createdAt: "", updatedAt: "")]),
                    Team(id: "teste3", name: "player3", quickChallengeId: "teste", ownerId: "teste", createdAt: "", updatedAt: "", members: [Member(id: "", score: 43, userId: "", teamId: "", beginDate: "", botPicture: "player3", createdAt: "", updatedAt: "")]),
                    Team(id: "teste4", name: "player4", quickChallengeId: "teste", ownerId: "teste", createdAt: "", updatedAt: "", members: [Member(id: "", score: 200, userId: "", teamId: "", beginDate: "", botPicture: "player4", createdAt: "", updatedAt: "")])
                ],
                owner: User(email: "teste", name: "teste"))))
    }
}
