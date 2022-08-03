//
//  QCNamingView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 19/07/22.
//

import SwiftUI
//MARK: QCNamingView
struct QCNamingView: View {
    //MARK: - Variables Setup
    @Environment(\.presentationMode) var presentationMode

    @State private var isNavActiveForAmount: Bool = false
    @State var challengeName: String = ""
    
    var primaryColor: Color
    var secondaryColor: Color
    var challengeType: QCType
        
    //MARK: - Body
    var body: some View {
        VStack {
            //MARK: - Header
            CustomProgressBar(currentPage: .first, primaryColor: self.primaryColor, secondaryColor: self.secondaryColor)
                .padding()
            
            Text("Nomeie seu \ndesafio")
                .multilineTextAlignment(.center)
                .font(Tokens.FontStyle.title.font(weigth: .bold, design: .rounded))
                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                .padding(.top, Tokens.Spacing.xxxs.value)
                .padding(.bottom, Tokens.Spacing.quarck.value)
            
            Text("de quantidade")
                .font(Tokens.FontStyle.callout.font())
                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)

            //MARK: Keyboard
            PermanentKeyboard(text: self.$challengeName, keyboardType: .default, onCommit: {
                isNavActiveForAmount.toggle()
            })
            .disabled(self.isNavActiveForAmount)
            .frame(height: UIScreen.main.bounds.height * 0.4)
            
            Spacer()
            
            //MARK: - Bottom Buttons
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Voltar")
                    .bold()
                    .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
            })
            .padding(.bottom, Tokens.Spacing.xxxs.value)

            ButtonComponent(style: .secondary(isEnabled: true), text: "Começar desafio!", action: {
                isNavActiveForAmount.toggle()
            })
            .padding(.bottom, Tokens.Spacing.xs.value)
            .padding(.horizontal, Tokens.Spacing.xxxs.value)
            
            NavigationLink("", isActive: $isNavActiveForAmount) {
                QCSelectParticipantsView(primaryColor: self.primaryColor, secondaryColor: self.secondaryColor, challengeType: self.challengeType, challengeName: self.challengeName)
            }
            .hidden()
        }
        .makeDarkModeFullScreen()
        .navigationBarHidden(true)
    }
}

struct QuickChallengeNamingView_Previews: PreviewProvider {
    static var previews: some View {
        QCNamingView(primaryColor: .red, secondaryColor: .white, challengeType: .amount)
    }
}
