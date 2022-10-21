//
//  QCAmountWinRulesView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 19/07/22.
//

import SwiftUI
import Combine

//MARK: QCAmountWinRulesView
struct QCAmountWinRulesView: View {
    enum ErrorState: CustomStringConvertible {
        case failedToCreateChallenge
        case negativeAmount
        case invalidInput
        
        
        var description: String {
            switch self {
                case .failedToCreateChallenge:
                    return "Oops, muito desafiador"
                case .negativeAmount:
                    return "Valor Inválido"
                case .invalidInput:
                    return "Valor Inválido"
            }
        }
    }
    //MARK: - Variables Setup
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var quickChallengeViewModel: QuickChallengeViewModel
   
    @State private var subscriptions: Set<AnyCancellable> = []
    @State private var errorState: ErrorState?
    
    @State var goal: String = ""
    @State var pushNextView: Bool = false
    @State var isPresentingAlert: Bool = false
    @State var quickChallenge: QuickChallenge = QuickChallenge(id: "", name: "", invitationCode: "", type: "", goal: 0, goalMeasure: "", finished: false, ownerId: "", online: false, alreadyBegin: false, maxTeams: 0, createdAt: "", updatedAt: "", teams: [], owner: User(email: "", name: ""))
    
    var primaryColor: Color
    var secondaryColor: Color
    var challengeType: QCTypeEnum
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
                CustomProgressBar(currentPage: .fourth)
                    .padding()
                
                Text("Defina os pontos necessários para a vitória")
                    .font(Tokens.FontStyle.title.font(weigth: .semibold, design: .default))
                    .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                    .multilineTextAlignment(.center)
                    .padding(.top, Tokens.Spacing.xxxs.value)
                    .padding(.bottom, Tokens.Spacing.quarck.value)
                    .padding(.horizontal, Tokens.Spacing.defaultMargin.value)
                
                Spacer()
                
                PermanentKeyboard(text: self.$goal, keyboardType: .numberPad)
                
                Spacer()
                
                ButtonComponent(style: .secondary(isEnabled: true), text: "Criar desafio", action: {
                    if let goal = Int(self.goal) {
                        if goal > 0 {
                            self.quickChallengeViewModel.createQuickChallenge(name: self.challengeName, challengeType: self.challengeType, goal: goal, goalMeasure: self.goalMeasure, numberOfTeams: self.challengeParticipants, maxTeams: self.challengeParticipants)
                                .sink(receiveCompletion: { completion in
                                    switch completion {
                                        case .failure:
                                            self.errorState = .failedToCreateChallenge
                                            self.isPresentingAlert.toggle()
                                        case .finished:
                                            print("Request completed successfully")
                                    }
                                }, receiveValue: { _ in })
                                .store(in: &subscriptions)
                        } else {
                            self.errorState = .negativeAmount
                            self.isPresentingAlert.toggle()
                        }
                    }
                    else {
                        self.errorState = .invalidInput
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
                    QCChallengeCreatedView(quickChallenge: self.$quickChallenge, challengeType: self.challengeType, challengeName: self.challengeName, challengeParticipants: self.challengeParticipants, goal: Int(self.goal) ?? 999)
                }
            }
            .alert(self.errorState?.description ?? "" , isPresented: self.$isPresentingAlert, presenting: self.errorState, actions: { error in
                Button(role: .cancel, action: {
                    self.isPresentingAlert = false
                }, label: {
                    Text("OK")
                })
            }, message: { error in
                switch error {
                    case .failedToCreateChallenge:
                        Text("Não conseguimos criar o seu desafio, tente mais tarde.")
                    case .negativeAmount:
                        Text("Você precisa informar um número maior que 0")
                    case .invalidInput:
                        Text("Você precisa informar o número de pontos para a vitória")
                }
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
