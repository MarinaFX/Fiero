//
//  QuantityChallengeWinRulesView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 19/07/22.
//

import SwiftUI

struct QuantityChallengeWinRulesView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var goal: String = ""
    @State var pushNextView: Bool = false
    
    var primaryColor: Color
    var secondaryColor: Color
    var challengeType: QCType
    var challengeName: String
    var challengeParticipants: Int

    var body: some View {
        VStack {
            CustomProgressBar(currentPage: .third)
                .padding()
            
            Text("Vitória")
                .font(Tokens.FontStyle.largeTitle.font(weigth: .semibold, design: .rounded))
                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                .padding(.bottom, Tokens.Spacing.nano.value)
            
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
            
            ButtonComponent(style: .secondary(isEnabled: true), text: "Começar!", action: {
                self.pushNextView.toggle()
            })
            .padding(.bottom)
            .padding(.horizontal, Tokens.Spacing.xxxs.value)
            
            NavigationLink("", isActive: self.$pushNextView) {
                ChallengeCreatedView(primaryColor: self.primaryColor, secondaryColor: self.secondaryColor, challengeType: self.challengeType, challengeName: self.challengeName, challengeParticipants: self.challengeParticipants, goal: self.goal)
            }
        }
        .onChange(of: self.goal, perform: { goal in
            print(goal)
        })
        .makeDarkModeFullScreen()
        .navigationBarHidden(true)
    }
}

struct QuantityChallengeWinRulesView_Previews: PreviewProvider {
    static var previews: some View {
        QuantityChallengeWinRulesView(primaryColor: .red, secondaryColor: .red, challengeType: .quickest, challengeName: "", challengeParticipants: 0)
    }
}
