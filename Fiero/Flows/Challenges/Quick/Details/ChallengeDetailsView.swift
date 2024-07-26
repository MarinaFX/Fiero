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
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var quickChallengeViewModel: QuickChallengeViewModel
    
    @State private var subscriptions: Set<AnyCancellable> = []
    @State private var ended: Bool = false
    @State var isPresentingAlert: Bool = false
    @State var isPresentingOngoing: Bool = false
    @State var isPresentingLoading: Bool = false
    
    @Binding var quickChallenge: QuickChallenge
    
    //MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                Color("background").ignoresSafeArea()
                
                NavigationLink("", isActive: self.$isPresentingOngoing) {
                    OngoingWithPause(quickChallenge: self.$quickChallenge, isShowingAlertOnDetailsScreen: self.$isPresentingAlert)
                }
                .hidden()
                
                ScrollView(showsIndicators: false) {
                    //MARK: - Top Components
                    VStack {
                        VStack(alignment: .center, spacing: extraExtraSmallSpacing) {
                            VStack(alignment: .center, spacing: nanoSpacing) {
                                Text("Desafio de quantidade")
                                    .font(descriptionFont)
                                    .foregroundColor(foregroundColor)
                                    .padding(.top, smallSpacing)
                                
                                Text(quickChallenge.name)
                                    .font(largeTitleFont)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(foregroundColor)
                                    .padding(.horizontal, nanoSpacing)
                            }
                            
                            VStack(alignment: .center, spacing: nanoSpacing) {
                                Text("Objetivo")
                                    .font(descriptionFont)
                                    .foregroundColor(foregroundColor)
                                
                                Text("\(quickChallenge.goal) pontos")
                                    .font(largeTitleFont)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(foregroundColor)
                                    .padding(.bottom, smallSpacing)
                                    .padding(.horizontal, nanoSpacing)
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.9)
                        .overlay(
                            RoundedRectangle(cornerRadius: borderSmall)
                                .stroke(foregroundColor, lineWidth: 2)
                        )
                        .padding(.top, nanoSpacing)
                        .padding(.bottom, smallSpacing)
                    }
                    
                    //MARK: - Mid Components
                    Text("Participantes")
                        .font(titleFont2)
                        .foregroundColor(foregroundColor)
                    
                    GroupComponent(scoreboard: true, style: [.participantDefault(isSmall: true)], quickChallenge: $quickChallenge)
                        .padding(.horizontal, defaultMarginSpacing)
                        .padding(.bottom, smallSpacing)
                    
                    //MARK: - Bottom Components
                    if !self.quickChallenge.finished {
                        ButtonComponent(style: .secondary(isEnabled: true),
                                        text: self.quickChallenge.alreadyBegin ?
                                        "Continuar desafio" : "Começar desafio!") {
                            self.isPresentingLoading.toggle()
                            self.quickChallengeViewModel.beginChallenge(challengeId: self.quickChallenge.id, alreadyBegin: true)
                                .sink(receiveCompletion: { completion in
                                    switch completion {
                                    case .finished:
                                        self.isPresentingLoading.toggle()
                                        self.isPresentingOngoing.toggle()
                                    case .failure:
                                        quickChallengeViewModel.detailsAlertCases = .failureStartChallenge
                                        self.isPresentingAlert.toggle()
                                        self.isPresentingLoading.toggle()
                                        print(self.isPresentingLoading)
                                    }
                                }, receiveValue: { _ in })
                                .store(in: &subscriptions)
                        }
                                        .padding(.horizontal, defaultMarginSpacing)
                    } else {
                        ButtonComponent(style: .secondary(isEnabled: false),
                                        text: "Desafio finalizado", action: {})
                        .padding(.horizontal, defaultMarginSpacing)
                    }
                    
                    ButtonComponent(style: .black(isEnabled: true),
                                    text: "Voltar para meus desafios") {
                        self.dismiss()
                    }
                }
                .padding(.vertical, nanoSpacing)
                //MARK: - Alert
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
                                        self.dismiss()
                                    case .failure(let error):
                                        print(error)
                                        self.quickChallengeViewModel.detailsAlertCases = .failureDeletingChallenge
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
                            self.dismiss()
                        }))
                    case .failureWhileSavingPoints:
                        return Alert(title: Text(DetailsAlertCases.failureWhileSavingPoints.title),
                                     message: Text(DetailsAlertCases.failureWhileSavingPoints.message),
                                     dismissButton: .cancel(Text(DetailsAlertCases.failureWhileSavingPoints.primaryButtonText), action: {
                            self.isPresentingAlert = false
                            self.dismiss()
                        }))
                    case .failureDeletingChallenge:
                            return Alert(title: Text("Failed to delete challenge"), message: Text("Something went wrong and we couldn't delete your challenge."), dismissButton: .cancel(Text("ok"), action: {
                                self.isPresentingAlert = false
                                self.dismiss()
                            }))
                    }
                })
                //MARK: - Navigation
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigation) {
                        Button {
                            self.dismiss()
                        } label: {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("backButtonText")
                            }
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            self.quickChallengeViewModel.detailsAlertCases = .deleteChallenge
                            self.isPresentingAlert.toggle()
                            HapticsController.shared.activateHaptics(hapticsfeedback: .heavy)
                        }, label: {
                            Image(systemName: "trash.fill")
                                .font(descriptionFontBold)
                                .foregroundColor(foregroundColor)
                        })
                    }
                }
                //MARK: - Loading
                if isPresentingLoading {
                    ZStack {
                        loadingBackgroundColor
                            .edgesIgnoringSafeArea(.all)
                            .opacity(0.9)
                        VStack {
                            Spacer()
                            //TODO: - change name of animation loading
                            LottieView(fileName: "loading", reverse: false, loop: false, ended: $ended).frame(width: 200, height: 200)
                            Spacer()
                        }
                    }
                }
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
    
    //MARK: - DS Tokens
    
    //MARK: Color
    var backgroundColor: Color {
        return Tokens.Colors.Background.dark.value
    }
    var foregroundColor: Color {
        return Tokens.Colors.Neutral.High.pure.value
    }
    var loadingBackgroundColor: Color {
        return Tokens.Colors.Neutral.Low.pure.value
    }
    //MARK: Spacing
    var nanoSpacing: CGFloat {
        return Tokens.Spacing.nano.value
    }
    var smallSpacing: CGFloat {
        return Tokens.Spacing.sm.value
    }
    var extraExtraSmallSpacing: CGFloat {
        return Tokens.Spacing.xxs.value
    }
    var defaultMarginSpacing: CGFloat {
        return Tokens.Spacing.defaultMargin.value
    }
    //MARK: Border
    var borderSmall: CGFloat {
        return Tokens.Border.BorderRadius.small.value
    }
    //MARK: Font
    var descriptionFont: Font {
        return Tokens.FontStyle.callout.font()
    }
    var descriptionFontBold: Font {
        return Tokens.FontStyle.callout.font(weigth: .bold)
    }
    var titleFont2: Font {
        return Tokens.FontStyle.title2.font(weigth: .bold)
    }
    var largeTitleFont: Font {
        return Tokens.FontStyle.largeTitle.font(weigth: .heavy)
    }
}

//MARK: - Previews
struct ChallengeDetailsScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeDetailsView(quickChallenge: .constant(QuickChallenge(id: "", name: "Girls Challenge part 1", invitationCode: "", type: "", goal: 0, goalMeasure: "", finished: false, ownerId: "", online: false, alreadyBegin: false, maxTeams: 0, createdAt: "", updatedAt: "", teams: [Team(id: "id", name: "Naty", quickChallengeId: "id", createdAt: "", updatedAt: ""), Team(id: "id2", name: "player2", quickChallengeId: "id", createdAt: "", updatedAt: "")], owner: User(email: "a@naty.pq", name: "naty"))))
            .environmentObject(QuickChallengeViewModel())
    }
}

