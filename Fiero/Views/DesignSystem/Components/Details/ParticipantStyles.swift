//
//  ParticipantStyles.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 20/07/22.
//

import SwiftUI

enum ParticipantStyles {
    case participantDefault
    case participantLooser
    
    //MARK: Images
    var image: String {
        return "🦊"
    }
    //MARK: Colors
    var backgroundImage: Color {
        return Color("ParticipantColor")
    }
    var textAndPointsColor: Color {
        return Tokens.Colors.Neutral.Low.pure.value
    }
    //MARK: Border
    var borderRadius: CGFloat {
        return Tokens.Border.BorderRadius.circular.value
    }
    //MARK: Spacing
    var spacing: CGFloat {
        return Tokens.Spacing.nano.value
    }
    //MARK: Font
    var textFont: Font {
        return Tokens.FontStyle.callout.font()
    }
    var pointsFont: Font {
        return Tokens.FontStyle.title3.font(weigth: .bold)
    }
    
    
}
