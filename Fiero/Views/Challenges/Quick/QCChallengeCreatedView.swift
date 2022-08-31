//
//  QCChallengeCreatedView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 19/07/22.
//

import SwiftUI
//MARK: QCChallengeCreatedView
struct QCChallengeCreatedView: View {
    //MARK: - Variables Setup
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var quickChallengeViewModel: QuickChallengeViewModel
    @State var didPushToHomeScreen: Bool = false
    @State var presentDuelChallenge: Bool = false
    @State var present3Or4Challenge: Bool = false
    @State var isPresentingAlert: Bool = false
    @Binding var serverResponse: ServerResponse
    @Binding var quickChallenge: QuickChallenge
    
    var challengeType: QCType
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
    
    var title: String {
        if self.quickChallengeViewModel.serverResponse.statusCode != 201 &&
            self.quickChallengeViewModel.serverResponse.statusCode != 200 {
            return "Não conseguimos \ncriar seu desafio"
        }
        
        return "Desafio criado com sucesso"
    }

    //MARK: - Body
    var body: some View {
        VStack {
            Spacer()
            
            Image("Olhos")
                .padding(.top, Tokens.Spacing.sm.value * 1.5)
            
            Text(self.title)
                .multilineTextAlignment(.center)
                .font(Tokens.FontStyle.largeTitle.font(weigth: .semibold, design: .default))
                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                .padding(.top, Tokens.Spacing.sm.value)
            
            Spacer()
            
            //MARK: - Bottom Buttons
            if self.serverResponse.statusCode == 201 ||
                self.serverResponse.statusCode == 200 {
                
                ButtonComponent(style: .secondary(isEnabled: true), text: "Começar desafio!", action: {
                    if quickChallenge.maxTeams == 2 {
                        //TODO: - Do logic
//                        presentDuelChallenge.toggle()
                    }
                    else {
                        //TODO: - Do logic
//                        present3Or4Challenge.toggle()
                    }
                })
                .padding(.bottom, Tokens.Spacing.nano.value)
                .padding(.horizontal, Tokens.Spacing.xxxs.value)
                
                Button(action: {
                    RootViewController.popToRootViewController()
                }, label: {
                    Text("Ir para lista de desafios")
                        .bold()
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                })
                .padding(.bottom, Tokens.Spacing.xxxs.value)
                
                NavigationLink("", isActive: self.$presentDuelChallenge) {
                    DuelScreenView(quickChallenge: $quickChallenge)
                }
                .hidden()
                
                NavigationLink("", isActive: self.$present3Or4Challenge) {
                    Ongoing3Or4WithPauseScreenView(quickChallenge: self.$quickChallenge, didTapPauseButton: false, didFinishChallenge: false)
                }
                .hidden()
                
            } else {
                ButtonComponent(style: .secondary(isEnabled: true), text: "Tentar novamente", action: {
                    self.quickChallengeViewModel.createQuickChallenge(name: self.challengeName, challengeType: self.challengeType, goal: self.goal, goalMeasure: self.goalMeasure, numberOfTeams: self.challengeParticipants, maxTeams: self.challengeParticipants)
                })
                .padding(.bottom, Tokens.Spacing.xxxs.value)
                .padding(.horizontal, Tokens.Spacing.xxxs.value)
                
                Button(action: {
                    RootViewController.popToRootViewController()
                }, label: {
                    Text("Voltar para o início")
                        .bold()
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                })
                .padding(.bottom, Tokens.Spacing.xxxl.value)
            }
        }
        .alert(isPresented: self.$isPresentingAlert, content: {
            Alert(title: Text("Erro"),
                  message: Text(self.quickChallengeViewModel.serverResponse.description),
                  dismissButton: .cancel(Text("OK"), action: { self.isPresentingAlert = false })
            )
        })
        .onChange(of: self.quickChallengeViewModel.challengesList, perform: { _ in
            if self.quickChallengeViewModel.serverResponse.statusCode != 201 &&
                self.quickChallengeViewModel.serverResponse.statusCode != 200 {
                self.isPresentingAlert.toggle()
            }
        })
        .makeDarkModeFullScreen(color: Color(red: 0.345, green: 0.322, blue: 0.855, opacity: 1))
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }
}

struct QuickChallengeCreatedView_Previews: PreviewProvider {
    static var previews: some View {
        QCChallengeCreatedView(serverResponse: .constant(.badRequest), quickChallenge: .constant(QuickChallenge(id: "", name: "", invitationCode: "", type: "", goal: 0, goalMeasure: "", finished: false, ownerId: "", online: false, alreadyBegin: false, maxTeams: 0, createdAt: "", updatedAt: "", teams: [], owner: User(email: "", name: ""))), challengeType: .amount, challengeName: "", challengeParticipants: 0, goal: 0)
            .previewDevice(PreviewDevice(rawValue: "iPhone 8 Plus"))
            .environmentObject(QuickChallengeViewModel())
    }
}
