//
//  WinScoreSelectionView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 19/07/22.
//

import SwiftUI
import Combine

//MARK: QCAmountWinRulesView
struct WinScoreSelectionView: View {
    
    //MARK: - Variables Setup
    @Environment(\.dismiss) var dismiss
    @Environment(\.sizeCategory) var sizeCategory
    
    @StateObject var viewModel: WinScoreSelectionViewModel = WinScoreSelectionViewModel(service: CombineAPIServiceImpl())
   
    @State private var subscriptions: Set<AnyCancellable> = []
    @State var goal: String = ""
    @State var pushNextView: Bool = false
    @State var isPresentingAlert: Bool = false
    @State var quickChallenge: QuickChallenge?
    
    var isOnline: Bool
    var primaryColor: Color
    var secondaryColor: Color
    var challengeType: QCTypeEnum
    var challengeName: String
    var numberOfTeams: Int
    
    var goalMeasure: String {
        switch challengeType {
            case .amount, .volleyball, .healthKit, .truco:
                return "unity"
            case .byTime(let measure):
                return measure
            case .bestOf:
                return "rounds"
        }
    }
    
    var body: some View {
        ZStack{
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
                
                CreationFlowTextViewComponent(text: self.$goal, style: .points) {
                    self.pushNextView.toggle()
                }
                .disabled(self.pushNextView)
                .padding(.top, Tokens.Spacing.xs.value)
                
                Spacer()
                
                ButtonComponent(style: .secondary(isEnabled: true), text: "Criar desafio", action: {
                    self.viewModel.createChallenge(name: self.challengeName, challengeType: self.challengeType, goal: self.goal, goalMeasure: self.goalMeasure, online: self.isOnline, numberOfTeams: self.numberOfTeams, maxTeams: self.numberOfTeams)
                })
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, Tokens.Spacing.xxxs.value)
                .padding(.horizontal, Tokens.Spacing.xxxs.value)
                
                Button(action: {
                    self.dismiss()
                }, label: {
                    Text("Voltar")
                        .bold()
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                })
                .padding(.bottom)
                .padding(.horizontal, Tokens.Spacing.xxxs.value)
                
                NavigationLink("", isActive: self.$pushNextView) {
                    ChallengeCreatedView()
                }
            }
            .alert(self.viewModel.error?.description ?? "" , isPresented: self.$isPresentingAlert, presenting: self.viewModel.error, actions: { error in
                Button(role: .cancel, action: {
                    self.isPresentingAlert = false
                    self.viewModel.isPresentingAlert = false
                }, label: {
                    Text("OK")
                })
            }, message: { error in
                switch error {
                    case .failedToCreateChallenge, .APIError(_):
                        Text("Não conseguimos criar o seu desafio, tente mais tarde.")
                    case .negativeAmount:
                        Text("Você precisa informar um número maior que 0")
                    case .invalidInput:
                        Text("Você precisa informar o número de pontos para a vitória")
                }
            })
            .onChange(of: self.viewModel.isPresentingAlert, perform: { isPresentingAlert in
                self.isPresentingAlert = isPresentingAlert
            })
            .onChange(of: self.viewModel.createdChallenge, perform: { quickChallenge in
                if let challenge = quickChallenge {
                    self.quickChallenge = challenge
                    self.pushNextView.toggle()
                }
            })
            .navigationBarHidden(true)
        }
    }
}

struct QuantityChallengeWinRulesView_Previews: PreviewProvider {
    static var previews: some View {
        WinScoreSelectionView(isOnline: false, primaryColor: .red, secondaryColor: .red, challengeType: .amount, challengeName: "", numberOfTeams: 0)
    }
}
