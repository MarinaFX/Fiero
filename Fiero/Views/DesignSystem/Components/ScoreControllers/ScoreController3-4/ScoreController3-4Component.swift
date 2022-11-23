//
//  ScoreController.swift
//  Fiero
//
//  Created by Lucas Dimer Justo on 09/08/22.
//

import SwiftUI
import Combine

struct ScoreController: View {
    @EnvironmentObject var quickChallengeViewModel: QuickChallengeViewModel
    
    @State private(set) var timeWithoutClick: Int = 0
    @State private(set) var waitingForSync: Bool = false
    @State private(set) var isLongPressing = false
    @State private(set) var timer: Timer?
    
    @State private var subscriptions: Set<AnyCancellable> = []

    @Binding var playerScore: Double
    @Binding var quickChallenge: QuickChallenge
    @Binding var isFinished: Bool
    @Binding var isShowingAlertOnDetailsScreen: Bool

    private(set) var playerName: LocalizedStringKey
    private(set) var challengeId: String
    private(set) var teamId: String
    private(set) var memberId: String

    var buttonFrame: CGFloat {
        return 40
    }
    var color: Color {
        return Tokens.Colors.Neutral.High.pure.value
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Tokens.Border.BorderRadius.normal.value)
                .foregroundColor(Tokens.Colors.Neutral.Low.pure.value)
                .opacity(0.2)
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: "minus.circle.fill")
                        .resizable()
                        .foregroundColor(color)
                        .frame(width: buttonFrame, height: buttonFrame)
                        .onTapGesture {
                            self.playerScore -= 1
                            if playerScore == Double(quickChallenge.goal) && !quickChallenge.finished {
                                self.timer?.invalidate()
                                isLongPressing = false
                                isFinished = true
                            }

                            HapticsController.shared.activateHaptics(hapticsfeedback: .light)
                            
                            SoundPlayer.playSound(soundName: Sounds.negativePoint, soundExtension: Sounds.negativePoint.soundExtension, soundType: SoundTypes.action)
                            Haptics.shared.play(.light)
                        }

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
                                            if playerScore == Double(quickChallenge.goal) && !quickChallenge.finished {
                                                self.timer?.invalidate()
                                                isLongPressing = false
                                                isFinished = true
                                            }
                                            HapticsController.shared.activateHaptics(hapticsfeedback: .light)
                                        })
                                    }
                                })
                        )
                    Spacer()
                        
                    Text("\(playerScore, specifier: "%.0f")")
                            .font(Tokens.FontStyle.largeTitle.font(weigth: .bold))
                            .foregroundColor(color)
                    
                    Spacer()
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .foregroundColor(color)
                        .frame(width: buttonFrame, height: buttonFrame)
                        .onTapGesture {
                            self.playerScore += 1
                            if playerScore == Double(quickChallenge.goal) && !quickChallenge.finished {
                                self.timer?.invalidate()
                                isLongPressing = false
                                isFinished = true
                            }

                            HapticsController.shared.activateHaptics(hapticsfeedback: .light)

                            SoundPlayer.playSound(soundName: Sounds.positivePoint, soundExtension: Sounds.positivePoint.soundExtension, soundType: SoundTypes.action)
                            Haptics.shared.play(.light)
                        }

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
                                            if playerScore == Double(quickChallenge.goal) && !quickChallenge.finished {
                                                self.timer?.invalidate()
                                                isLongPressing = false
                                                isFinished = true
                                            }
                                            HapticsController.shared.activateHaptics(hapticsfeedback: .light)
                                        })
                                    }
                                })
                        )
                }
                .padding(.horizontal, Tokens.Spacing.defaultMargin.value)
                .padding(.top, Tokens.Spacing.defaultMargin.value)
                
                Text(playerName)
                    .font(Tokens.FontStyle.callout.font())
                    .foregroundColor(color)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, Tokens.Spacing.quarck.value)
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity , alignment: .center)
        .onDisappear(perform: {
            self.quickChallengeViewModel.patchScore(challengeId: self.challengeId, teamId: self.teamId, memberId: self.memberId, score: self.playerScore)
                .sink(receiveCompletion: { completion in
                    switch completion {
                        case .finished:
                            print("finished successfully")
                        case .failure(_):
                            self.quickChallengeViewModel.detailsAlertCases = .failureWhileSavingPoints
                            self.isShowingAlertOnDetailsScreen = true
                    }
                }, receiveValue: { _ in })
                .store(in: &subscriptions)
        })
    }
}

struct ScoreController_Previews: PreviewProvider {
    static var previews: some View {
        ScoreController(playerScore: .constant(2.0),
                                    quickChallenge: .constant(QuickChallenge(id: "",
                                                                             name: "",
                                                                             invitationCode: "",
                                                                             type: "",
                                                                             goal: 0,
                                                                             goalMeasure: "",
                                                                             finished: false,
                                                                             ownerId: "",
                                                                             online: false,
                                                                             alreadyBegin: false,
                                                                             maxTeams: 0,
                                                                             createdAt: "",
                                                                             updatedAt: "",
                                                                             teams: [],
                                                                             owner: User(email: "",
                                                                                         name: ""))),
                                    isFinished: .constant(false),
                                    isShowingAlertOnDetailsScreen: .constant(false),
                                    playerName: "",
                                    challengeId: "",
                                    teamId: "",
                                    memberId: "")
    }
}
