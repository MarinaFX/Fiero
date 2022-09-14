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

    var buttonFrame: CGFloat {
        return 40
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Tokens.Border.BorderRadius.small.value)
                .foregroundColor(foreGroundColor)
            HStack {
                Image(systemName: "minus.circle.fill")
                    .resizable()
                    .foregroundColor(.black)
                    .frame(width: buttonFrame, height: buttonFrame)
                    .gesture(
                        DragGesture(minimumDistance: 0, coordinateSpace: .global)
                            .onEnded({ value in
                                self.timer?.invalidate()
                                isLongPressing = false
                            })
                            .onChanged({ value in
                                if !isLongPressing {
                                    isLongPressing = true
                                    self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
                                        self.playerScore -= 1
                                        Haptics.shared.play(.light)
                                    })
                                }
                            })
                    )
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
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .foregroundColor(.black)
                    .frame(width: buttonFrame, height: buttonFrame)
                    .gesture(
                        DragGesture(minimumDistance: 0, coordinateSpace: .global)
                            .onEnded({ value in
                                self.timer?.invalidate()
                                isLongPressing = false
                            })
                            .onChanged({ value in
                                if !isLongPressing {
                                    isLongPressing = true
                                    self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
                                        self.playerScore += 1
                                        Haptics.shared.play(.light)
                                    })
                                }
                            })
                    )
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
