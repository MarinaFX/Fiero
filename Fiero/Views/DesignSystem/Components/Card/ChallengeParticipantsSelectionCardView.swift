//
//  ChallengeParticipantsSelectionCardView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 19/07/22.
//

import SwiftUI

struct ChallengeParticipantsSelectionCardView: View {
    @State var amount: String = "0"
    
    var body: some View {
        ZStack {
            Tokens.Colors.Neutral.Low.dark.value
            
            Text(amount)
                .font(.system(size: 200))
                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
        }
        .frame(maxWidth: .infinity)
        .frame(height: UIScreen.main.bounds.height * 0.3)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.Border.BorderRadius.small.value))
    }
}

struct ChallengeParticipantsSelectionCardView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeParticipantsSelectionCardView()
            .padding(Tokens.Spacing.sm.value)
    }
}
