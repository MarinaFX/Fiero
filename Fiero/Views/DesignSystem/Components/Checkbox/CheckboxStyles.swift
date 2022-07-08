//
//  CheckboxStates.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 07/07/22.
//

import SwiftUI

enum CheckboxStyles {
    case light
    case dark
    
    var fontSize: CGFloat {
        return Tokens.Fonts.Size.xs.value
    }
    
    var fontFamily: Font.Design {
        return Tokens.Fonts.Familiy.support.value
    }
    
    var fontWeight: Font.Weight {
        return Tokens.Fonts.Weight.regular.value
    }
    
    var color: Color {
        switch self {
        case .light:
            return Tokens.Colors.Neutral.Low.pure.value
        case .dark:
            return Tokens.Colors.Neutral.High.pure.value
        }
    }
    
    var padding: Double {
        return Tokens.Spacing.nano.value
    }
}
