/**
 Custom ChallengeType proposed on Fiero's Design System. This view considers both ChallengeType variation styles (Quantity, Timer and StopWatch)
 
 - Author:
 Natália Brocca dos Santos
 
 - parameters:
    - style: The Style variation to be used (Quantity, Timer or StopWatch).
    - currentScore: The text of the user's current score/time.
    - limitScore: The text of the Challenge limit score/time.
 */

import SwiftUI

struct QuantityTimeComponent: View {
    @State var style: QuantityTimeStyles
    @State var currentScore: String
    @State var limitScore: String
    
    var body: some View {
        HStack {
            Image(systemName: style.image)
                .font(style.iconFont)
                .foregroundColor(style.color)
            
            Text(currentScore)
                .font(style.textFont)
                .foregroundColor(style.color)
            
            Text("/")
                .font(style.textFont)
                .foregroundColor(style.color)
            
            Text(limitScore)
                .font(style.textFont)
                .foregroundColor(style.color)
        }
    }
}

struct QuantityTimeComponent_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
            QuantityTimeComponent(style: .quantity, currentScore: "200", limitScore: "500")
        }
    }
}
