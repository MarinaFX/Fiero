//
//  OngoingWithPause.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 10/10/22.
//

import SwiftUI

struct OngoingWithPause: View {
    @State var didTapPauseButton: Bool = false
    @State var didFinishChallenge: Bool = false
    
    @Binding var quickChallenge: QuickChallenge
    @Binding var isShowingAlertOnDetailsScreen: Bool
    
    var body: some View {
        ZStack {
            OngoingScreen(quickChallenge: self.$quickChallenge, didTapPauseButton: self.$didTapPauseButton, isShowingAlertOnDetailsScreen: self.$isShowingAlertOnDetailsScreen)
            if self.didTapPauseButton {
                PauseScreen(didTapPauseButton: self.$didTapPauseButton, didFinishChallenge: self.$didFinishChallenge, quickChallenge: self.$quickChallenge)
                if self.didFinishChallenge {
                    HomeView()
                }
            }
        }
        .navigationBarHidden(true)
    }
}
