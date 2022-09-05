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
    @State var isPresentingLoading: Bool = false
    
    @Binding var quickChallenge: QuickChallenge
    
    //MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                Tokens.Colors.Background.dark.value.edgesIgnoringSafeArea(.all)
                VStack {
                    //MARK: - Top Components
                    ZStack {
                        VStack(spacing: Tokens.Spacing.xxs.value) {
                            VStack {
                                Text("Desafio de quantidade")
                                    .multilineTextAlignment(.center)
                                    .font(descriptionFont)
                                    .foregroundColor(color)
                                    .fixedSize(horizontal: false, vertical: true)
                                
                                Text(quickChallenge.name)
                                    .font(.system(size: 40))
                                    .fontWeight(.heavy)
                                    .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                            }.padding(.top, Tokens.Spacing.sm.value)
                            
                            VStack {
                                Text("Objetivo")
                                    .multilineTextAlignment(.center)
                                    .font(descriptionFont)
                                    .foregroundColor(color)
                                    .fixedSize(horizontal: false, vertical: true)
                                
                                Text("\(quickChallenge.goal) pontos")
                                    .font(.system(size: 40))
                                    .fontWeight(.heavy)
                                    .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                            }.padding(.bottom, Tokens.Spacing.sm.value)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Tokens.Colors.Neutral.High.pure.value, lineWidth: 2)
                    )
                    .padding(.horizontal, Tokens.Spacing.defaultMargin.value)
                    .padding(.bottom, Tokens.Spacing.sm.value)

                    //MARK: - Mid Components
                    Text("Participantes")
                        .font(titleFont2)
                        .foregroundColor(color)
                    
                    GroupComponent(scoreboard: true, style: [.participantDefault(isSmall: true)], quickChallenge: $quickChallenge)
                        .padding(.horizontal, Tokens.Spacing.defaultMargin.value)
                    
                    //MARK: - Bottom Components
                    Spacer()
                    VStack(spacing: quarkSpacing) {
                        if self.quickChallenge.maxTeams == 2 {
                            NavigationLink("", isActive: self.$presentDuelOngoingChallenge) {
                                DuelScreenView(quickChallenge: $quickChallenge)
                            }.hidden()
                        }
                        else {
                            NavigationLink("", isActive: self.$present3or4OngoingChallenge) {
                                Ongoing3Or4WithPauseScreenView(quickChallenge: self.$quickChallenge, didTapPauseButton: false)
                            }.hidden()
                        }
                        
                        ButtonComponent(style: .secondary(isEnabled: true),
                                        text: self.quickChallenge.alreadyBegin ?
                                        "Continuar Desafio" : "Começar desafio!") {
                            self.isPresentingLoading.toggle()
                            print(quickChallenge.teams.count)
                            self.quickChallengeViewModel.beginChallenge(challengeId: self.quickChallenge.id, alreadyBegin: true)
                                .sink(receiveCompletion: { completion in
                                    switch completion {
                                    case .finished:
                                        if self.quickChallenge.maxTeams == 2 {
                                            self.isPresentingLoading.toggle()
                                            self.presentDuelOngoingChallenge.toggle()
                                        }
                                        else {
                                            self.isPresentingLoading.toggle()
                                            self.present3or4OngoingChallenge.toggle()
                                        }
                                    case .failure:
                                        quickChallengeViewModel.detailsAlertCases = .failureStartChallenge
                                        self.isPresentingAlert.toggle()
                                        self.isPresentingLoading.toggle()
                                        print(self.isPresentingLoading)
                                    }
                                }, receiveValue: { _ in })
                                .store(in: &subscriptions)
                        }
                        
                        ButtonComponent(style: .black(isEnabled: true),
                                        text: "Voltar para meus desafios") {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }.padding(.horizontal, Tokens.Spacing.defaultMargin.value)
                }
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
                            Haptics.shared.play(.heavy)
                        }, label: {
                            Image(systemName: "trash")
                                .font(Tokens.FontStyle.callout.font(weigth: .bold))
                                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                        })
                    }
                }
                if isPresentingLoading {
                    ZStack {
                        Tokens.Colors.Neutral.Low.pure.value.edgesIgnoringSafeArea(.all).opacity(0.9)
                        VStack {
                            Spacer()
                            //TODO: - change name of animation loading
                            LottieView(fileName: "loading", reverse: false).frame(width: 200, height: 200)
                            Spacer()
                        }
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
    var smallSpacing: CGFloat {
        return Tokens.Spacing.xxxs.value
    }
    var extraExtraExtraSmallSpacing: CGFloat {
        return Tokens.Spacing.xxxs.value
    }
    var largeSpacing: CGFloat {
        return Tokens.Spacing.lg.value
    }
    var titleFont2: Font {
        return Tokens.FontStyle.title2.font(weigth: .bold)
    }
    var titleFont: Font {
        return Tokens.FontStyle.title.font(weigth: .bold)
    }
    var largeTitleFont: Font {
        return Tokens.FontStyle.largeTitle.font(weigth: .bold)
    }
    var descriptionFont: Font {
        return Tokens.FontStyle.callout.font()
    }
}

//MARK: - Previews
struct ChallengeDetailsScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeDetailsView(quickChallenge: .constant(QuickChallenge(id: "", name: "", invitationCode: "", type: "", goal: 0, goalMeasure: "", finished: false, ownerId: "", online: false, alreadyBegin: false, maxTeams: 0, createdAt: "", updatedAt: "", teams: [Team(id: "id", name: "Naty", quickChallengeId: "id", createdAt: "", updatedAt: ""), Team(id: "id2", name: "player2", quickChallengeId: "id", createdAt: "", updatedAt: "")], owner: User(email: "a@naty.pq", name: "naty"))))
            .environmentObject(QuickChallengeViewModel())
    }
}

