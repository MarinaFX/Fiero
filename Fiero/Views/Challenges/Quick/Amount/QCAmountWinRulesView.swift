//
//  QCAmountWinRulesView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 19/07/22.
//

import SwiftUI

struct QCAmountWinRulesView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var quickChallengeViewModel: QuickChallengeViewModel
    
    @State var goal: String = ""
    @State var pushNextView: Bool = false
    @State var isPresentingAlert: Bool = false
    @State var serverResponse: ServerResponse = .unknown
    @State var quickChallenge: QuickChallenge = QuickChallenge(id: "", name: "", invitationCode: "", type: "", goal: 0, goalMeasure: "", finished: false, ownerId: "", online: false, alreadyBegin: false, maxTeams: 0, createdAt: "", updatedAt: "", teams: [], owner: User(email: "", name: ""))
    
    var primaryColor: Color
    var secondaryColor: Color
    var challengeType: QCType
    var challengeName: String
    var challengeParticipants: Int
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
    
    var body: some View {
        ZStack{
            Tokens.Colors.Background.dark.value.ignoresSafeArea()
            VStack {
                CustomProgressBar(currentPage: .third)
                    .padding()
                
                Text("Vitória")
                    .font(Tokens.FontStyle.largeTitle.font(weigth: .semibold, design: .default))
                    .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                    .padding(.top, Tokens.Spacing.xxxs.value)
                    .padding(.bottom, Tokens.Spacing.quarck.value)
                
                Text("Número de pontos necessários pra que \nalguém seja vencedor.")
                    .multilineTextAlignment(.center)
                    .font(Tokens.FontStyle.callout.font(weigth: .regular, design: .default))
                    .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                
                Spacer()
                
                PermanentKeyboard(text: self.$goal, keyboardType: .decimalPad)
                
                Spacer()
                
                ButtonComponent(style: .secondary(isEnabled: true), text: "Criar desafio", action: {
                    if let goal = Int(self.goal) {
                        if goal > 0 {
                            self.quickChallengeViewModel.createQuickChallenge(name: self.challengeName, challengeType: self.challengeType, goal: goal, goalMeasure: self.goalMeasure, numberOfTeams: self.challengeParticipants, maxTeams: self.challengeParticipants)
                        } else {
                            self.isPresentingAlert.toggle()
                        }
                    }
                    else {
                        self.isPresentingAlert.toggle()
                    }
                })
                .padding(.bottom, Tokens.Spacing.xxxs.value)
                .padding(.horizontal, Tokens.Spacing.xxxs.value)
                
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Voltar")
                        .bold()
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                })
                .padding(.bottom)
                .padding(.horizontal, Tokens.Spacing.xxxs.value)
                
                NavigationLink("", isActive: self.$pushNextView) {
                    QCChallengeCreatedView(serverResponse: Binding.constant(self.quickChallengeViewModel.serverResponse), quickChallenge: self.$quickChallenge, challengeType: self.challengeType, challengeName: self.challengeName, challengeParticipants: self.challengeParticipants, goal: Int(self.goal) ?? 999)
                }
            }
            .alert(isPresented: self.$isPresentingAlert, content: {
                Alert(title: Text("Valor inválido"),
                      message: Text("Você precisa informar o número de pontos para a vitória"),
                      dismissButton: .cancel(Text("OK"), action: { self.isPresentingAlert = false })
                )
            })
            .onChange(of: self.quickChallengeViewModel.newlyCreatedChallenge, perform: { quickChallenge in
                self.quickChallenge = quickChallenge
                
                self.pushNextView.toggle()
            })
            .navigationBarHidden(true)
        }
    }
}

struct QuantityChallengeWinRulesView_Previews: PreviewProvider {
    static var previews: some View {
        QCAmountWinRulesView(primaryColor: .red, secondaryColor: .red, challengeType: .amount, challengeName: "", challengeParticipants: 0)
    }
}
