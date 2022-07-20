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
                self.quickChallengeViewModel.createQuickChallenge(name: "", challengeType: .quickest, goal: 0, goalMeasure: "", userId: "")
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
    }
}

struct QuickChallengeCreatedView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeCreatedView()
    }
}
