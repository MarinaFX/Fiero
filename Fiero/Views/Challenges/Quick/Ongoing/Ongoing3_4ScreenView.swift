//
//  Ongoing3_4ScreenView.swift
//  Fiero
//
//  Created by Lucas Dimer Justo on 11/08/22.
//

import SwiftUI

struct Ongoing3Or4WithPauseScreenView: View {
    @State var didTapPauseButton: Bool = false
    @State var didFinishChallenge: Bool = false
    
    @Binding var quickChallenge: QuickChallenge
    @Binding var isShowingAlertOnDetailsScreen: Bool
    
    var body: some View {
        ZStack {
            Ongoing3_4ScreenView(quickChallenge: self.$quickChallenge, didTapPauseButton: self.$didTapPauseButton, isShowingAlertOnDetailsScreen: self.$isShowingAlertOnDetailsScreen)
            if self.didTapPauseButton {
                PauseScreen(didTapPauseButton: self.$didTapPauseButton, didFinishChallenge: self.$didFinishChallenge, quickChallenge: self.$quickChallenge)
                if self.didFinishChallenge {
                    HomeView()
                }
            }
        }
        .navigationBarHidden(true)
    }
}

//MARK: -
struct Ongoing3_4ScreenView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var quickChallenge: QuickChallenge
    @Binding var didTapPauseButton: Bool
    @Binding var isShowingAlertOnDetailsScreen: Bool

    
    @State var isFinished: Bool = false
    
    //MARK: Tokens
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
            VStack(spacing: 0) {
                ForEach(self.$quickChallenge.teams) { team in
                    ZStack {
                        Member.getColor(playerName: team.wrappedValue.name)
                            .ignoresSafeArea()
                        VStack(spacing: Tokens.Spacing.xxxs.value) {
                            Image("Olhos")
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.1)
                            
                            ScoreController3_4Component(playerScore: Binding(team.members)?.first?.score ?? .constant(0),
                                                        quickChallenge: $quickChallenge,
                                                        isFinished: $isFinished,
                                                        isShowingAlertOnDetailsScreen: self.$isShowingAlertOnDetailsScreen,
                                                        playerName: Member.getName(playerName: team.wrappedValue.name),
                                                        challengeId: quickChallenge.id,
                                                        teamId: team.wrappedValue.id,
                                                        memberId: team.wrappedValue.members?[0].id ?? "")
                        }
                        .padding(.horizontal, Tokens.Spacing.xl.value)
                        .padding(.vertical, Tokens.Spacing.xxxs.value)
                    }
                }
                NavigationLink("", isActive: $isFinished) {
                    WinScreen(isFinished: $isFinished, winnerName: "Alpaca")
                }
                .hidden()
            }
            HStack {
                Spacer ()
                Button {
                    didTapPauseButton.toggle()
                    Haptics.shared.play(.light)
                } label: {
                    Image(systemName: "pause.circle.fill")
                        .resizable()
                        .foregroundColor(foregroundColor)
                        .frame(width: 50, height: 50)
                }
                .padding(.trailing, Tokens.Spacing.defaultMargin.value)
                
            }
            .padding(.top, -(UIScreen.main.bounds.height/2 - Tokens.Spacing.xs.value))
            
        }
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
                                                                                owner: User(email: "teste", name: "teste"))), isShowingAlertOnDetailsScreen: .constant(false))
    }
}
