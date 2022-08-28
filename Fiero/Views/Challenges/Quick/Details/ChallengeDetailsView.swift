//
//  ChallengeDetailsView.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 20/07/22.
//

import SwiftUI
import Combine

//MARK: ChallengeDetailsView
struct ChallengeDetailsView: View {
    //MARK: - Variables Setup
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var quickChallengeViewModel: QuickChallengeViewModel
    
    @State private var subscriptions: Set<AnyCancellable> = []
    
    @State var isPresentingAlert: Bool = false
    @State var presentDuelOngoingChallenge: Bool = false
    @State var present3or4OngoingChallenge: Bool = false
    
    @Binding var quickChallenge: QuickChallenge
    
    //MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                Tokens.Colors.Background.dark.value.edgesIgnoringSafeArea(.all)
                //MARK: - Top Components
                VStack {
                    VStack(spacing: largeSpacing) {
                        VStack (alignment: .center, spacing: nanoSpacing) {
                            HStack(spacing: nanoSpacing) {
                                Text("⚡️")
                                    .font(titleFont)
                                    .foregroundColor(color)
                                
                                Text(quickChallenge.name)
                                    .font(titleFont)
                                    .foregroundColor(color)
                            }
                            
                            Text("Vence quem fizer algo mais vezes \naté bater a pontuação de: ")
                                .multilineTextAlignment(.center)
                                .font(descriptionFont)
                                .foregroundColor(color)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Text("\(quickChallenge.goal)")
                                .font(titleFont)
                                .foregroundColor(color)
                        }
                        
                        //MARK: - Mid Components
                        VStack(spacing: extraExtraExtraSmallSpacing) {
                            Text("Participantes")
                                .font(titleFont)
                                .foregroundColor(color)
                            
                            if quickChallenge.teams.count >= 3 {
                                GroupComponent(scoreboard: true, style: [.participantDefault(isSmall: true)], quickChallenge: $quickChallenge)
                            } else {
                                GroupComponent(scoreboard: true, style: [.participantDefault(isSmall: false)], quickChallenge: $quickChallenge)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    //MARK: - Bottom Components
                    VStack(spacing: quarkSpacing) {
                        if self.quickChallenge.maxTeams == 2 {
                            NavigationLink("", isActive: self.$presentDuelOngoingChallenge) {
                                DuelScreenView(quickChallenge: $quickChallenge)
                            }
                            .hidden()
                        }
                        else {
                            NavigationLink("", isActive: self.$present3or4OngoingChallenge) {
                                Ongoing3Or4WithPauseScreenView(quickChallenge: self.$quickChallenge, didTapPauseButton: false)
                            }
                            .hidden()
                        }
                        
                        ButtonComponent(style: .secondary(isEnabled: true),
                                        text: "Começar desafio!") {
                            print(quickChallenge.teams.count)
                            self.quickChallengeViewModel.beginChallenge(challengeId: self.quickChallenge.id, alreadyBegin: true)
                                .sink(receiveCompletion: { completion in
                                    switch completion {
                                    case .finished:
                                        if self.quickChallenge.maxTeams == 2 {
                                            self.presentDuelOngoingChallenge.toggle()
                                        }
                                        else {
                                            self.present3or4OngoingChallenge.toggle()
                                        }
                                    case .failure:
                                        quickChallengeViewModel.detailsAlertCases = .failureStartChallenge
                                        self.isPresentingAlert.toggle()
                                    }
                                }, receiveValue: { _ in })
                                .store(in: &subscriptions)
                        }
                        
                        ButtonComponent(style: .black(isEnabled: true),
                                        text: "Voltar para lista") {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .padding(.bottom, largeSpacing)
                }
                .padding(.horizontal)
                .alert(isPresented: self.$isPresentingAlert, content: {
                    switch quickChallengeViewModel.detailsAlertCases {
                    case .deleteChallenge:
                        return Alert(title: Text(DetailsAlertCases.deleteChallenge.title),
                                     message: Text(DetailsAlertCases.deleteChallenge.message),
                                     primaryButton: .cancel(Text(DetailsAlertCases.deleteChallenge.primaryButtonText), action: {
                            self.isPresentingAlert = false
                        }), secondaryButton: .destructive(Text("Apagar desafio"), action: {
                            self.quickChallengeViewModel.deleteChallenge(by: quickChallenge.id)
                                .sink { completion in
                                    switch completion {
                                    case .finished:
                                        self.presentationMode.wrappedValue.dismiss()
                                    case .failure(let error):
                                        print(error)
                                        self.quickChallengeViewModel.detailsAlertCases = .deleteChallenge
                                        self.isPresentingAlert.toggle()
                                    }
                                } receiveValue: { _ in }
                                .store(in: &subscriptions)
                        }))
                    case .failureStartChallenge:
                        return Alert(title: Text(DetailsAlertCases.failureStartChallenge.title),
                                     message: Text(DetailsAlertCases.failureStartChallenge.message),
                                     dismissButton: .cancel(Text(DetailsAlertCases.failureStartChallenge.primaryButtonText), action: {
                            self.isPresentingAlert = false
                            self.presentationMode.wrappedValue.dismiss()
                        }))
                    }
                })
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            self.quickChallengeViewModel.detailsAlertCases = .deleteChallenge
                            self.isPresentingAlert.toggle()
                        }, label: {
                            Image(systemName: "trash")
                                .font(Tokens.FontStyle.callout.font(weigth: .bold))
                                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                        })
                    }
                }
            }.accentColor(Color.white)
        }
        
    }
    
    //MARK: - DS Tokens
    var color: Color {
        return Tokens.Colors.Neutral.High.pure.value
    }
    var quarkSpacing: CGFloat {
        return Tokens.Spacing.quarck.value
    }
    var nanoSpacing: CGFloat {
        return Tokens.Spacing.nano.value
    }
    var extraExtraExtraSmallSpacing: CGFloat {
        return Tokens.Spacing.xxxs.value
    }
    var largeSpacing: CGFloat {
        return Tokens.Spacing.lg.value
    }
    var titleFont: Font {
        return Tokens.FontStyle.title2.font(weigth: .bold)
    }
    var descriptionFont: Font {
        return Tokens.FontStyle.caption.font()
    }
}

//MARK: - Previews
struct ChallengeDetailsScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeDetailsView(quickChallenge: .constant(QuickChallenge(id: "", name: "", invitationCode: "", type: "", goal: 0, goalMeasure: "", finished: false, ownerId: "", online: false, alreadyBegin: false, maxTeams: 0, createdAt: "", updatedAt: "", teams: [Team(id: "id", name: "Naty", quickChallengeId: "id", createdAt: "", updatedAt: ""), Team(id: "id2", name: "player2", quickChallengeId: "id", createdAt: "", updatedAt: "")], owner: User(email: "a@naty.pq", name: "naty"))))
            .environmentObject(QuickChallengeViewModel())
    }
}

