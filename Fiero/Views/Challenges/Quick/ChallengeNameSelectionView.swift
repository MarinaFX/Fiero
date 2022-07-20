//
//  ChallengeNameSelectionView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 19/07/22.
//

import SwiftUI

struct ChallengeNameSelectionView: View {
    @State var challengeName: String = ""
    
    var primaryColor: Color
    var secondaryColor: Color
    var challengeType: QCType
    
    @State private var isNavActiveQuickest: Bool = false
    @State private var isNavActiveHighest: Bool = false
    @State private var isNavActiveBestOf: Bool = false
    
    var body: some View {
        VStack {
            CustomProgressBar(currentPage: .first, primaryColor: self.primaryColor, secondaryColor: self.secondaryColor)
                .padding()
            
            Text("Nomeie seu \ndesafio")
                .multilineTextAlignment(.center)
                .font(Tokens.FontStyle.title.font(weigth: .bold, design: .rounded))
                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                .padding(.top)
            
            Text("de quantidade")
                .font(Tokens.FontStyle.callout.font())
                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
            
            PermanentKeyboard(text: self.$challengeName, keyboardType: .default) {
                switch challengeType {
                    case .quickest:
                        isNavActiveQuickest.toggle()
                    case .highest:
                        isNavActiveHighest.toggle()
                    case .bestOf:
                        isNavActiveBestOf.toggle()
                }
            }
                .frame(height: UIScreen.main.bounds.height * 0.5)
            
            NavigationLink("", isActive: $isNavActiveHighest) {
                ChallengeParticipantsSelectionView(primaryColor: self.primaryColor, secondaryColor: self.secondaryColor, challengeType: .highest(""), challengeName: self.challengeName)
            }
            .hidden()
            
            NavigationLink("", isActive: $isNavActiveQuickest) {
                ChallengeParticipantsSelectionView(primaryColor: self.primaryColor, secondaryColor: self.secondaryColor, challengeType: .quickest, challengeName: self.challengeName)
            }
            .hidden()
            
            NavigationLink("", isActive: $isNavActiveBestOf) {
                BestOfChallengeWinRulesView(primaryColor: self.primaryColor, secondaryColor: self.secondaryColor, challengeType: .bestOf, challengeName: self.challengeName)
            }
            .hidden()
        }
        .onChange(of: self.challengeName, perform: { newValue in
            print(newValue)
        })
        .makeDarkModeFullScreen()
        .navigationBarHidden(true)
    }
}

struct QuickChallengeNamingView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeNameSelectionView(primaryColor: .red, secondaryColor: .white, challengeType: .quickest)
    }
}
