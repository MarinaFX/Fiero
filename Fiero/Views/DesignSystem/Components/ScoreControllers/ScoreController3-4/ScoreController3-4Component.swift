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
    @State private(set) var isLongPressing = false
    @State private(set) var timer: Timer?

    @Binding var playerScore: Double

    private(set) var foreGroundColor: Color
    private(set) var playerName: String
    private(set) var challengeId: String
    private(set) var teamId: String
    private(set) var memberId: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Tokens.Border.BorderRadius.small.value)
                .foregroundColor(foreGroundColor)
            HStack {
                Button(action: {
                    print("tap")
                    if(self.isLongPressing){
                        //End of a longpress gesture, so stop our fastforwarding
                        self.isLongPressing.toggle()
                        self.timer?.invalidate()
                    } else {
                        //Regular tap
                        self.playerScore -= 1
                    }
                }, label: {
                    Image(systemName: "minus.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Tokens.Colors.Neutral.Low.pure.value)
                    
                })
                .simultaneousGesture(LongPressGesture(minimumDuration: 0.2).onEnded { _ in
                    print("long press")
                    self.isLongPressing = true
                    //Fastforward has started
                    self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
                        self.playerScore -= 1
                    })
                })
                Spacer()
                VStack {
                    Text("\(playerScore, specifier: "%.0f")")
                        .font(Tokens.FontStyle.largeTitle.font())
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                    
                    Text(playerName)
                        .font(Tokens.FontStyle.callout.font())
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                }
                Spacer()
                Button(action: {
                    if(self.isLongPressing){
                        //End of a longpress gesture, so stop our fastforwarding
                        self.isLongPressing.toggle()
                        self.timer?.invalidate()
                    } else {
                        //Regular tap
                        self.playerScore += 1
                    }
                }, label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.black)
                })
                .simultaneousGesture(LongPressGesture(minimumDuration: 0.2).onEnded { _ in
                    self.isLongPressing = true
                    //Fastforward has started
                    self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
                        self.playerScore += 1
                    })
                })
            }
            .padding(.horizontal, Tokens.Spacing.xs.value)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity , alignment: .center)
        .onDisappear(perform: {
            self.quickChallengeViewModel.patchScore(challengeId: self.challengeId, teamId: self.teamId, memberId: self.memberId, score: self.playerScore)
        })
    }
}

struct ScoreController3_4Component_Previews: PreviewProvider {
    static var previews: some View {
        ScoreController3_4Component(playerScore: .constant(2.0), foreGroundColor: .red, playerName: "", challengeId: "", teamId: "", memberId: "")
    }
}
