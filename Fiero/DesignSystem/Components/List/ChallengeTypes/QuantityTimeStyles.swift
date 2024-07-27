/**
 Custom ChallengeType Styles proposed on Fiero's Design System. This view considers both ChallengeType variation styles (Quantity, Timer and StopWatch)
 
 - Author:
 Natália Brocca dos Santos
 
 - **Cases**:
    - quantity
    - timer
    - stopwatch
 */

import SwiftUI

enum QuantityTimeStyles {
    case quantity
    case timer
    case stopwatch
    
    //MARK: Font
    var iconFont: Font {
        return Tokens.FontStyle.callout.font()
    }
    
    var textFont: Font {
        return Tokens.FontStyle.caption.font()
    }
    
    //MARK: Color
    var color: Color {
        return Tokens.Colors.Neutral.High.pure.value
    }
    
    //MARK: Icon
    var image: String {
        switch self {
        case .quantity:
            return "arrow.2.squarepath"
        case .timer:
            return "timer"
        case .stopwatch:
            return "stopwatch"
        }
    }
    
}
