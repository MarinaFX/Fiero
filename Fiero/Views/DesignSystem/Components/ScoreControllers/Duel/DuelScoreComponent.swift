//
 //  ScoreControllerDuel.swift
 //  Fiero
 //
 //  Created by João Gabriel Biazus de Quevedo on 04/08/22.
 //

import SwiftUI
import Combine

struct DuelScoreComponent: View {
    @EnvironmentObject var quickChallengeViewModel: QuickChallengeViewModel

    @State private(set) var style: ScoreControllerStyle
    @State private(set) var maxValue: Int?
    @State private(set) var isLongPressing = false
    @State private(set) var timer: Timer?
    
    @State private var subscriptions: Set<AnyCancellable> = []

    @Binding var playerScore: Double
    @Binding var isShowingAlertOnDetailsScreen: Bool

    private(set) var challengeId: String
    private(set) var teamId: String
    private(set) var memberId: String
    
    var playerName: String

     var body: some View {
         ZStack{
             RoundedRectangle(cornerRadius: style.borderRadius)
                 .foregroundColor(style.backgroundColor)
                 .opacity(0.2)

             VStack(alignment:.center, spacing: Tokens.Spacing.nano.value ) {
                 HStack() {
                     Button(action: {
                         if(self.isLongPressing){
                             //End of a longpress gesture, so stop our fastforwarding
                             self.isLongPressing.toggle()
                             self.timer?.invalidate()
                         } else {
                            //Regular tap
                             self.playerScore -= 1
                             Haptics.shared.play(.light)
                         }
                     }, label: {
                         Image(systemName: style.minusIcon)
                             .resizable()
                             .frame(width: 40, height: 40)
                             .foregroundColor(style.buttonColor)
                         
                     })
                     .simultaneousGesture(LongPressGesture(minimumDuration: 0.2).onEnded { _ in
                         self.isLongPressing = true
                         //Fastforward has started
                         self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
                             self.playerScore -= 1
                             Haptics.shared.play(.light)
                         })
                     })
                     .padding(.leading, style.spacing)

                     Spacer()

                     Text("\(self.playerScore, specifier: "%.0f")")
                         .foregroundColor(style.buttonColor)
                         .font(style.numberFont)

                     Spacer()
                     Button(action: {
                         if(self.isLongPressing){
                             //End of a longpress gesture, so stop our fastforwarding
                             self.isLongPressing.toggle()
                             self.timer?.invalidate()
                             
                         } else {
                             //Regular tap
                             self.playerScore += 1
                             Haptics.shared.play(.light)
                         }
                     }, label: {
                         Image(systemName: style.plusIcon)
                             .resizable()
                             .frame(width: 40, height: 40)
                             .foregroundColor(style.buttonColor)
                         
                     })
                     .simultaneousGesture(LongPressGesture(minimumDuration: 0.2).onEnded { _ in
                         self.isLongPressing = true
                         //Fastforward has started
                         self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
                             self.playerScore += 1
                             Haptics.shared.play(.light)
                         })
                     })
                     .padding(.trailing, style.spacing)
                 }
                 .padding(.vertical, style.spacingVertical)

                 Text("\(playerName)")
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
        DuelScoreComponent(style: .first, maxValue: 0, playerScore: .constant(0.0), isShowingAlertOnDetailsScreen: .constant(false), challengeId: "", teamId: "", memberId: "", playerName: "")
    }
}
