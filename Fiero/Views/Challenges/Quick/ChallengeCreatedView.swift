//
//  ChallengeCreatedView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 19/07/22.
//

import SwiftUI

struct ChallengeCreatedView: View {
    
    @StateObject var quickChallengeViewModel: QuickChallengeViewModel = QuickChallengeViewModel()
    @State var serverResponse: ServerResponse = .unknown
    
    var primaryColor: Color
    var secondaryColor: Color
    var challengeType: QCType
    var challengeName: String
    var challengeParticipants: Int
    var goal: String
    var goalMeasure: String {
        switch challengeType {
            case .quickest:
                return "unity"
            case .highest(let measure):
                return measure ?? "minutes"
            case .bestOf:
                return "rounds"
        }
    }

    var body: some View {
        VStack {
            Spacer()
            
            Image("Olhos")
            
            Text("Desafio criado!")
                .font(Tokens.FontStyle.largeTitle.font(weigth: .semibold, design: .default))
                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                .padding(.top, Tokens.Spacing.md.value)
            
            Spacer()
            
            ButtonComponent(style: .secondary(isEnabled: true), text: "Pronto!", action: {
                let defaults = UserDefaults.standard
                let userID = defaults.string(forKey: "userID")!
                
                self.quickChallengeViewModel.createQuickChallenge(name: challengeName, challengeType: .quickest, goal: Int(self.goal) ?? 0, goalMeasure: self.goalMeasure, userId: userID)
            })
            .padding(.bottom)
            .padding(.horizontal, Tokens.Spacing.xxxs.value)
        }
        .onChange(of: self.quickChallengeViewModel.serverResponse, perform: { serverResponse in
            self.serverResponse = serverResponse
        })
        .padding(.top, Tokens.Spacing.lg.value)
        .padding(.bottom, Tokens.Spacing.xxs.value)
        .frame(
              minWidth: 0,
              maxWidth: .infinity,
              minHeight: 0,
              maxHeight: .infinity,
              alignment: .top
            )
        .background(Color(red: 0.345, green: 0.322, blue: 0.855, opacity: 1))
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }
}

struct QuickChallengeCreatedView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeCreatedView(primaryColor: .red, secondaryColor: .red, challengeType: .quickest, challengeName: "", challengeParticipants: 0, goal: "")
    }
}
