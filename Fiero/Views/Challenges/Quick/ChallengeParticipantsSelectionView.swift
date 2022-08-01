//
//  ChallengeParticipantsSelectionView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 19/07/22.
//

import SwiftUI

struct ChallengeParticipantsSelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var challengeParticipants: Int = 2
    @State var tabViewSelection: Int = 2
    @State var pushNextView: Bool = false
    
    var primaryColor: Color
    var secondaryColor: Color
    var challengeType: QCType
    var challengeName: String

    var body: some View {
        VStack {
            CustomProgressBar(currentPage: .second, primaryColor: self.primaryColor, secondaryColor: self.secondaryColor)
                .padding()
            
            Text("Quantas pessoas estão \nnesse desafio?")
                .multilineTextAlignment(.center)
                .font(Tokens.FontStyle.title.font(weigth: .bold, design: .rounded))
                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                .padding(.top)
            
            Spacer()
            
            TabView(selection: self.$tabViewSelection) {
                ChallengeParticipantsSelectionCardView(amount: "2")
                    .padding(Tokens.Spacing.sm.value)
                    .tag(2)
                
                ChallengeParticipantsSelectionCardView(amount: "3")
                    .padding(Tokens.Spacing.sm.value)
                    .tag(3)
                
                ChallengeParticipantsSelectionCardView(amount: "4")
                    .padding(Tokens.Spacing.sm.value)
                    .tag(4)
                
            }
            .tabViewStyle(PageTabViewStyle())
            
            Spacer()
            
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Voltar")
                    .bold()
                    .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
            })
            
            ButtonComponent(style: .secondary(isEnabled: true), text: "Esses são os desafiantes!", action: {
                self.pushNextView.toggle()
            })
            .padding(.bottom)
            .padding(.horizontal, Tokens.Spacing.xxxs.value)
            
            if challengeType == .quickest {
                NavigationLink("", isActive: self.$pushNextView, destination: {
                    QuantityChallengeWinRulesView(primaryColor: self.primaryColor, secondaryColor: self.secondaryColor, challengeType: self.challengeType, challengeName: self.challengeName, challengeParticipants: self.challengeParticipants)
                })
            }
            if challengeType == .highest("") {
                NavigationLink("", isActive: self.$pushNextView, destination: {
                    TimeChallengeWinRulesView(primaryColor: self.primaryColor, secondaryColor: self.secondaryColor, challengeType: .highest(""), challengeName: self.challengeName, challengeParticipants: self.challengeParticipants)
                })
            }
        }
        .onAppear(perform: {
            print("nome do desafio vindo da tela anterior\(self.challengeName)")
        })
        .onChange(of: self.tabViewSelection, perform: { tabViewSelection in
            self.challengeParticipants = tabViewSelection
        })
        .makeDarkModeFullScreen()
        .navigationBarHidden(true)
    }
}

struct ChallengeParticipantsSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeParticipantsSelectionView(primaryColor: .red, secondaryColor: .red, challengeType: .quickest, challengeName: "")
    }
}
