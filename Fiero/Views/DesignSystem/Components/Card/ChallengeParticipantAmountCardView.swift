//
//  ChallengeParticipantAmountCardView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 19/07/22.
//

import SwiftUI

struct ChallengeParticipantAmountCardView: View {
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
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

struct ChallengeParticipantAmountCardView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeParticipantAmountCardView()
            .padding(Tokens.Spacing.sm.value)
    }
}
