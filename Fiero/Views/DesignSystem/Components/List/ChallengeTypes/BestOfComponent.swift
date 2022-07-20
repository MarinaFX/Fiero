/**
 Custom ChallengeType proposed on Fiero's Design System. This view considers ChallengeType variation style of  BestOfThree and BestOfFive
 
 - Author:
 Natália Brocca dos Santos
 
 - parameters:
    - status: This is an array of status of the RoundScoreComponent
 */

import SwiftUI

struct BestOfComponent: View {
    @State var status: [RoundScoreStyle]
    
    var body: some View {
        HStack {
            ForEach(0..<status.count, id: \.self) { index in
                RoundScoreComponent(style: status[index])
            }
        }
    }
}

struct BestOfComponent_Previews: PreviewProvider {
    static var previews: some View {
        BestOfComponent(status: [.win, .lose, .empty])
    }
}

