//
 //  ScoreControllerDuel.swift
 //  Fiero
 //
 //  Created by João Gabriel Biazus de Quevedo on 04/08/22.
 //

import SwiftUI

struct DuelScoreComponent: View {
    @EnvironmentObject var quickChallengeViewModel: QuickChallengeViewModel

    @State private var timer: Timer?

    @State var style: ScoreControllerStyle
    @State var maxValue: Int
    @State var count: Int = 0
    
    @State var isLongPressing = false

    @Binding var playerScore: Double

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
                            if count > 0 {
                                self.count -= 1
                            }
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
                             if count > 0 {
                                self.count -= 1
                             }
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
                             if count < maxValue{
                                self.count += 1
                             }
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
                             if count < maxValue{
                                self.count += 1
                             }
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
         })
         .frame(height: 120)
     }
 }

struct DuelScoreComponent_Previews: PreviewProvider {
    static var previews: some View {
        DuelScoreComponent(style: .first, playerScore: .constant(0.0), challengeId: "", teamId: "", memberId: "", playerName: "")
    }
}
