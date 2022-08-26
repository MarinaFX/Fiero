//
//  ScoreController3-4Component.swift
//  Fiero
//
//  Created by Lucas Dimer Justo on 09/08/22.
//

import SwiftUI

struct ScoreController3_4Component: View {
    @EnvironmentObject var quickChallengeViewModel: QuickChallengeViewModel
    
    @State private(set) var timeWithoutClick: Int = 0
    @State private(set) var waitingForSync: Bool = false

    private(set) var foreGroundColor: Color
    private(set) var playerName: String
    private(set) var challengeId: String
    private(set) var teamId: String
    private(set) var memberId: String
    
    @Binding var playerScore: Double

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Tokens.Border.BorderRadius.small.value)
                .foregroundColor(foreGroundColor)
            HStack {
                Button {
                    self.playerScore -= 1
                    self.waitingForSync = true
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Tokens.Colors.Neutral.Low.pure.value)
                }
                Spacer()
                VStack {
                    Text("\(playerScore, specifier: "%.0f")")
                        .font(Tokens.FontStyle.largeTitle.font())
                        .foregroundColor(Tokens.Colors.Neutral.Low.pure.value)
                    
                    Text(playerName)
                        .font(Tokens.FontStyle.callout.font())
                        .foregroundColor(Tokens.Colors.Neutral.Low.pure.value)
                }
                Spacer()
                Button {
                    print("öi")
                    self.playerScore += 1
                    self.waitingForSync = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.black)
                }
                
            }
            .padding(.horizontal, Tokens.Spacing.xs.value)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity , alignment: .center)
        .onDisappear(perform: {
            self.quickChallengeViewModel.patchScore(challengeId: self.challengeId, teamId: self.teamId, memberId: self.memberId, score: self.playerScore)
        })
    }
    
    func syncScore() {
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { timer in
            print("waitingForSyn: \(self.waitingForSync)")
            if self.waitingForSync {
                print("salvaai")
                self.quickChallengeViewModel.patchScore(challengeId: self.challengeId, teamId: self.teamId, memberId: self.memberId, score: self.playerScore)
                self.waitingForSync = false
            }
            print("saved score: \(self.playerScore)")
            
        }
    }
}

struct ScoreController3_4Component_Previews: PreviewProvider {
    static var previews: some View {
        ScoreController3_4Component(foreGroundColor: .red, playerName: "", challengeId: "", teamId: "", memberId: "", playerScore: .constant(2.0))
    }
}
