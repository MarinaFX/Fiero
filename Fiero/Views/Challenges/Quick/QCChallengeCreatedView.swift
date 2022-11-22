//
//  QCChallengeCreatedView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 19/07/22.
//

import SwiftUI
import Combine

/**
 Remaining fixes:
 - Fix dismiss to challenge details instead of created view when going back to challenge details or finishing challenge - view hierarchy
 */

//MARK: QCChallengeCreatedView
struct QCChallengeCreatedView: View {
    //MARK: - Variables Setup
    @EnvironmentObject var quickChallengeViewModel: QuickChallengeViewModel
    
    @State var didPushToHomeScreen: Bool = false
    @State var isPresentingChallenge: Bool = false
    @State var isPresentingAlert: Bool = false
    @State var subscriptions: Set<AnyCancellable> = []
    
    @Binding var quickChallenge: QuickChallenge
    
    @State private var ended: Bool = false

    
    var challengeType: QCTypeEnum
    var challengeName: String
    var challengeParticipants: Int
    var goal: Int
    var goalMeasure: String {
        switch challengeType {
            case .amount:
                return "unity"
            case .byTime(let measure):
                return measure
            case .bestOf:
                return "rounds"
        }
    }

    //MARK: - Body
    var body: some View {
        VStack {
            Spacer()
            
            LottieView(fileName: "success-loop", reverse: false, loop: true, ended: $ended).frame(width: 350 , height: 200)
            
            Text("Desafio criado com sucesso")
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .font(Tokens.FontStyle.largeTitle.font(weigth: .semibold, design: .default))
                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                .padding(.top, Tokens.Spacing.sm.value)
                .padding(.horizontal, Tokens.Spacing.defaultMargin.value)
            
            Spacer()
            
            //MARK: - Bottom Buttons
            ButtonComponent(style: .secondary(isEnabled: true), text: "Começar desafio!", action: {
                
                self.quickChallengeViewModel.beginChallenge(challengeId: self.quickChallenge.id, alreadyBegin: true)
                    .sink(receiveCompletion: { completion in
                        switch completion {
                            case .failure(_):
                                self.isPresentingAlert.toggle()
                            case .finished:
                                self.isPresentingChallenge.toggle()
                        }
                    }, receiveValue: { _ in ()})
                    .store(in: &subscriptions)
            })
            .hidden()
            .padding(.bottom, Tokens.Spacing.nano.value)
            .padding(.horizontal, Tokens.Spacing.xxxs.value)
            
            Button(action: {
                RootViewController.popToRootViewController()
            }, label: {
                Text("Ir para a tela de criação")
                    .bold()
                    .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
            })
            .padding(.bottom, Tokens.Spacing.xxxs.value)
            
            NavigationLink("", isActive: self.$isPresentingChallenge) {
                OngoingWithPause(quickChallenge: self.$quickChallenge, isShowingAlertOnDetailsScreen: self.$isPresentingAlert)
            }
            .hidden()
        }
        .onTapGesture {
            RootViewController.popToRootViewController()
        }
        .alert(isPresented: self.$isPresentingAlert, content: {
            return Alert(title: Text(DetailsAlertCases.failureStartChallenge.title),
                         message: Text(DetailsAlertCases.failureStartChallenge.message),
                         dismissButton: .cancel(Text(DetailsAlertCases.failureStartChallenge.primaryButtonText), action: {
                self.isPresentingAlert = false
            }))
        })
        .makeDarkModeFullScreen(color: Color(red: 0.345, green: 0.322, blue: 0.855, opacity: 1))
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }
}

struct QuickChallengeCreatedView_Previews: PreviewProvider {
    static var previews: some View {
        QCChallengeCreatedView(quickChallenge: .constant(QuickChallenge(id: "", name: "", invitationCode: "", type: "", goal: 0, goalMeasure: "", finished: false, ownerId: "", online: false, alreadyBegin: false, maxTeams: 0, createdAt: "", updatedAt: "", teams: [], owner: User(email: "", name: ""))), challengeType: .amount, challengeName: "", challengeParticipants: 0, goal: 0)
            .previewDevice(PreviewDevice(rawValue: "iPhone 8 Plus"))
            .environmentObject(QuickChallengeViewModel())
    }
}
