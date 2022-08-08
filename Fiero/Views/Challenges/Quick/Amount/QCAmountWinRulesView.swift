//
//  QCAmountWinRulesView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 19/07/22.
//

import SwiftUI

struct QCAmountWinRulesView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var quickChallengeViewModel: QuickChallengeViewModel = QuickChallengeViewModel()
    @State var serverResponse: ServerResponse = .unknown
    
    @State var goal: String = ""
    @State var pushNextView: Bool = false
    
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
                return measure ?? "No time measure defined"
            case .bestOf:
                return "rounds"
        }
    }

    var body: some View {
        VStack {
            CustomProgressBar(currentPage: .third)
                .padding()
            
            Text("Vitória")
                .font(Tokens.FontStyle.largeTitle.font(weigth: .semibold, design: .rounded))
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
            
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Voltar")
                    .bold()
                    .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
            })
            .padding(.bottom, Tokens.Spacing.xxxs.value)
            
            ButtonComponent(style: .secondary(isEnabled: true), text: "Finalizar criação do desafio", action: {
                
                self.quickChallengeViewModel.createQuickChallenge(name: self.challengeName, challengeType: self.challengeType, goal: Int(self.goal) ?? 0, goalMeasure: self.goalMeasure)
                self.pushNextView.toggle()
            })
            .padding(.bottom)
            .padding(.horizontal, Tokens.Spacing.xxxs.value)
            
            NavigationLink("", isActive: self.$pushNextView) {
                QCChallengeCreatedView()
            }
        }
        .makeDarkModeFullScreen()
        .navigationBarHidden(true)
    }
}

struct QuantityChallengeWinRulesView_Previews: PreviewProvider {
    static var previews: some View {
        QCAmountWinRulesView(primaryColor: .red, secondaryColor: .red, challengeType: .amount, challengeName: "", challengeParticipants: 0)
    }
}
