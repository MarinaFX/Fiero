//
//  ScoreControllerDuel.swift
//  Fiero
//
//  Created by João Gabriel Biazus de Quevedo on 04/08/22.
//

import SwiftUI
import Combine
import Lottie

struct DuelScoreComponent: View {
    @EnvironmentObject var quickChallengeViewModel: QuickChallengeViewModel
    
    @State private(set) var style: ScoreControllerStyle
    @State private(set) var maxValue: Int?
    @State private(set) var isLongPressing = false
    @State private(set) var timer: Timer?
    
    @State private var subscriptions: Set<AnyCancellable> = []

    @Binding var isFinished: Bool
    @Binding var quickChallenge: QuickChallenge
    @Binding var playerScore: Double
    @Binding var isShowingAlertOnDetailsScreen: Bool

    private(set) var challengeId: String
    private(set) var teamId: String
    private(set) var memberId: String
    
    var playerName: LocalizedStringKey
    
    var buttonFrame: CGFloat {
        return 40
    }
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: style.borderRadius)
                .foregroundColor(style.backgroundColor)
                .opacity(0.2)
            
            VStack(alignment:.center, spacing: Tokens.Spacing.nano.value ) {
                HStack() {
                    Image(systemName: style.minusIcon)
                        .resizable()
                        .foregroundColor(style.buttonColor)
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
                                            if playerScore == Double(quickChallenge.goal) && !quickChallenge.finished {
                                                self.timer?.invalidate()
                                                isLongPressing = false
                                                isFinished = true
                                            }
                                            Haptics.shared.play(.light)
                                        })
                                    }
                                })
                        )
                    
                    Spacer()
                    
                    Text("\(self.playerScore, specifier: "%.0f")")
                        .foregroundColor(style.buttonColor)
                        .font(style.numberFont)
                    
                    Spacer()
                    
                    Image(systemName: style.plusIcon)
                        .resizable()
                        .foregroundColor(style.buttonColor)
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
                                            if playerScore == Double(quickChallenge.goal) && !quickChallenge.finished {
                                                self.timer?.invalidate()
                                                isLongPressing = false
                                                isFinished = true
                                            }
                                            Haptics.shared.play(.light)
                                        })
                                    }
                                })
                        )
                }
                .padding(.horizontal, Tokens.Spacing.defaultMargin.value)
                .padding(.vertical, style.spacingVertical)
                
                Text(playerName)
                    .foregroundColor(style.buttonColor)
                    .font(style.nameFont)
                    .padding(.horizontal, style.spacingVertical)
            }
            .padding(.vertical, style.spacingAll)
        }
        .onDisappear(perform: {
            self.quickChallengeViewModel.patchScore(challengeId: self.challengeId, teamId: self.teamId, memberId: self.memberId, score: self.playerScore)
                 .sink(receiveCompletion: { completion in
                     switch completion {
                         case .failure(let error):
                             self.quickChallengeViewModel.detailsAlertCases = .failureWhileSavingPoints
                             self.isShowingAlertOnDetailsScreen = true
                             print(error)
                         case .finished:
                             print("finished successfully")
                     }
                 }, receiveValue: { _ in })
                 .store(in: &subscriptions)
             
        })
        .frame(height: 120)
    }
}

struct DuelScoreComponent_Previews: PreviewProvider {
    static var previews: some View {
        DuelScoreComponent(style: .first,
                           maxValue: 0,
                           isFinished: .constant(false),
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
                           playerScore: .constant(0.0),
                           isShowingAlertOnDetailsScreen: .constant(false),
                           challengeId: "",
                           teamId: "",
                           memberId: "",
                           playerName: "")
    }
}
