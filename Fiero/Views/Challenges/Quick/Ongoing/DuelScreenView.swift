//
//  DuelScreenView.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 12/08/22.
//

import SwiftUI

struct DuelScreenView: View {
    @State var didTapPauseButton: Bool = false
    @State var didFinishChallenge: Bool = false
    @State var isPresentingAlert: Bool = false

    var body: some View {
        ZStack {
            OngoingDuelScreenView(didTapPauseButton: $didTapPauseButton)
            if self.didTapPauseButton {
                PauseScreen(didTapPauseButton: $didTapPauseButton, didFinishChallenge: $didFinishChallenge)
                if self.didFinishChallenge {
                    ChallengesListScreenView()
                }
            }
        }
    }
}

struct DuelScreenView_Previews: PreviewProvider {
    static var previews: some View {
        DuelScreenView()
    }
}
