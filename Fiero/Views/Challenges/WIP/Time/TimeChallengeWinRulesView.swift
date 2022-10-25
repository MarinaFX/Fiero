//
//  TimeChallengeWinRulesView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 20/07/22.
//

import SwiftUI

struct TimeChallengeWinRulesView: View {
    enum QCHighestParameter {
        case stopwatch
        case timer
    }
    
    @State private(set) var challengeParameter: QCHighestParameter = .stopwatch
    @State private var navIsActive: Bool = false
        
    private(set) var primaryColor: Color
    private(set) var secondaryColor: Color
    private(set) var challengeType: QCTypeEnum
    private(set) var challengeName: String
    private(set) var challengeParticipants: Int
    
    var body: some View {
        VStack {
            CustomProgressBar(currentPage: .second)
                .padding()
            
            Text("Tempo")
                .font(Tokens.FontStyle.largeTitle.font(weigth: .semibold, design: .rounded))
                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                .padding(.bottom, Tokens.Spacing.nano.value)
            
            Text("Cronômetro: quem faz em menos tempo?")
                .font(Tokens.FontStyle.callout.font(weigth: .regular, design: .default))
                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
            
            Text("Timer: Quem faz mais com o mesmo tempo?")
                .font(Tokens.FontStyle.callout.font(weigth: .regular, design: .default))
                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
            
            Spacer()
            
            HStack {
                Button(action: {
                    self.challengeParameter = .stopwatch
                    self.navIsActive.toggle()
                }, label: {
                    ChallengeMetricSelectionCardView(primaryColor: self.primaryColor, iconName: "stopwatch.fill", description: "Cronômetro", type: .icon)
                })
                
                Button(action: {
                    self.challengeParameter = .timer
                    self.navIsActive.toggle()
                }, label: {
                    ChallengeMetricSelectionCardView(primaryColor: self.secondaryColor, iconName: "timer", description: "Timer", type: .icon)
                })
            }
            .padding(Tokens.Spacing.xxxs.value)
            
            Spacer()
            
            NavigationLink("", isActive: self.$navIsActive) {
                TimePickerSelectionView(primaryColor: self.primaryColor, secondaryColor: self.secondaryColor, challengeType: self.challengeType, challengeName: self.challengeName, challengeParticipants: self.challengeParticipants)
            }
            .hidden()
            
        }
        .makeDarkModeFullScreen()
        .navigationBarHidden(true)
    }
}

struct TimeChallengeWinRulesView_Previews: PreviewProvider {
    static var previews: some View {
        TimeChallengeWinRulesView(challengeParameter: .stopwatch, primaryColor: .red, secondaryColor: .red, challengeType: .amount, challengeName: "", challengeParticipants: 2)
    }
}
