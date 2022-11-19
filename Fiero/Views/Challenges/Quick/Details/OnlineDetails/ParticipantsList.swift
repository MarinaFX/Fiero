//
//  ParticipantsList.swift
//  Fiero
//
//  Created by João Gabriel Biazus de Quevedo on 24/10/22.
//

import SwiftUI
import Combine

struct ParticipantsList: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var quickChallengeViewModel: QuickChallengeViewModel
    
    @State private var ended: Bool = false
    @State private var isPresentingInvite: Bool = false
    @State private var subscriptions: Set<AnyCancellable> = []
    
    @Binding var quickChallenge: QuickChallenge
    
    var body: some View {
        if quickChallenge.teams.count > 1 {
            if self.quickChallenge.ownerId == UserDefaults.standard.string(forKey: UDKeysEnum.userID.description) ?? "" {
                List(self.$quickChallenge.teams) { participant in
                    Text(participant.name.wrappedValue)
                        .foregroundColor(foregroundColor)
                    
                    .swipeActions(edge: .trailing, allowsFullSwipe: true, content: {
                        Button(role: .destructive, action: {
                            self.quickChallengeViewModel.remove(participant: participant.wrappedValue.ownerId ?? "", from: self.quickChallenge.id)
                                .sink(receiveCompletion: { _ in }, receiveValue: { quickChallenge in
                                    self.quickChallenge = quickChallenge
                                })
                                .store(in: &subscriptions)
                        }, label: {
                            Label("Delete", systemImage: "trash")
                        })
                    })
                }
                .preferredColorScheme(.dark)
                .listStyle(.plain)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: backButton)
                
            }
            else {
                List(self.$quickChallenge.teams) { participant in
                    Text(participant.name.wrappedValue)
                        .foregroundColor(foregroundColor)
                }
                .preferredColorScheme(.dark)
                .listStyle(.plain)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: backButton)
            }
        } else {
            VStack {
                List {
                    ForEach(self.$quickChallenge.teams) { participant in
                        Text(participant.name.wrappedValue)
                            .foregroundColor(foregroundColor)
                    }
                }
                .disabled(true)
                .preferredColorScheme(.dark)
                .listStyle(.plain)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: backButton)
                .frame(height: 50)
                Spacer()
                LottieView(fileName: "sad", reverse: false, loop: true, ended: $ended).frame(width: 300 , height: 250)
                
                Text("Você parece estar sozinho aqui. Ficou com medo \nde desafiar seus amigos?")
                    .multilineTextAlignment(.center)
                    .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                    .font(Tokens.FontStyle.title.font(weigth: .bold, design: .default))
                    .padding(.horizontal, defaultMarginSpacing)
                Spacer()
                
                ButtonComponent(style: .secondary(isEnabled: true), text: "Convidar Participante", action: {
                    isPresentingInvite = true
                })
                .sheet(isPresented: $isPresentingInvite, content: {
                    InviteChallengerView(inviteCode: quickChallenge.invitationCode ?? "")
                })
                .padding(.horizontal, defaultMarginSpacing)
                .padding(.vertical, extraExtraSmallSpacing)
            }
            .preferredColorScheme(.dark)
        }
    }
    
    var backButton : some View { Button(action: {
            self.dismiss()
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                    Text("Detalhes do desafio")
                }
            }
        }
    
    //MARK: Color
    var backgroundColor: Color {
        return Tokens.Colors.Background.dark.value
    }
    var foregroundColor: Color {
        return Tokens.Colors.Neutral.High.pure.value
    }
    
    //MARK: Spacing
    var defaultMarginSpacing: CGFloat {
        return Tokens.Spacing.defaultMargin.value
    }
    var extraExtraSmallSpacing: CGFloat {
        return Tokens.Spacing.xxxs.value
    }
}

struct ParticipantsList_Previews: PreviewProvider {
    static var previews: some View {
        ParticipantsList(quickChallenge: .constant(QuickChallenge(id: "teste", name: "Truco", invitationCode: "teste", type: "Quantidade", goal: 3, goalMeasure: "unity", finished: false, ownerId: "teste", online: false, alreadyBegin: true, maxTeams: 4, createdAt: "teste", updatedAt: "teste", teams:
                                                                    [
                                                                        Team(id: "teste1", name: "Nome do jogador", quickChallengeId: "teste", ownerId: "teste", createdAt: "", updatedAt: "", members: [Member(id: "", score: 22, userId: "", teamId: "", beginDate: "", botPicture: "player1", createdAt: "", updatedAt: "")]),
                                                                    ],
                                                                                                                owner: User(email: "teste", name: "teste"))))
    }
}
