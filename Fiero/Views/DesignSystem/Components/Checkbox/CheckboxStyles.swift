//
//  CheckboxStates.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 07/07/22.
//

import SwiftUI

enum CheckboxStyles {
    case unchecked(isDark: Bool)
    case checked(isDark: Bool)
    
    //TODO: - Modify Tokens .value
    
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
        case .unchecked(let isDark):
            return isDark ? Tokens.Colors.Neutral.High.pure.value : Tokens.Colors.Neutral.Low.pure.value
        case .checked(let isDark):
            return isDark ? Tokens.Colors.Neutral.High.pure.value : Tokens.Colors.Neutral.Low.pure.value
        }
    }
    
    var imageName: String {
        switch self {
        case .unchecked:
            return "square"
        case .checked:
            return "checkmark.square"
        }
    }
    
    var padding: Double {
        return Tokens.Spacing.nano.value
    }
}
