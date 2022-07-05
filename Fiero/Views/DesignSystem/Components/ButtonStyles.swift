//
//  ButtonStyles.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 05/07/22.
//
import SwiftUI

enum ButtonStyles {
    case primary(isEnabled: Bool)
    case secondary(isEnabled: Bool)
    
    //MARK: Button variables
    var backgroundColor: Color {
        switch self {
        case .primary(let isEnabled):
            return isEnabled ? Tokens.Colors.Brand.Primary.pure.color : Tokens.Colors.Neutral.Low.light.color
        case .secondary(let isEnabled):
            return isEnabled ? Tokens.Colors.Neutral.High.pure.color : Tokens.Colors.Neutral.Low.light.color
        }
    }
    
    var padding: Double {
        return Tokens.Spacing.xxxs.spacing
    }
    
    var borderRadius: CGFloat {
        return Tokens.Border.BorderRadius.small.borderRadius
    }
    
    var isEnabled: Bool {
        switch self {
        case .primary(let isEnabled):
            return isEnabled
        case .secondary(let isEnabled):
            return isEnabled
        }
    }
    
    //MARK: Font variables
    var fontColor: Color {
        switch self {
        case .primary(let isEnabled):
            return isEnabled ? Tokens.Colors.Neutral.High.pure.color : Tokens.Colors.Neutral.High.dark.color
        case .secondary(let isEnabled):
            return isEnabled ? Tokens.Colors.Neutral.Low.pure.color : Tokens.Colors.Neutral.High.dark.color
        }
    }
    
    var fontFamily: Font.Design {
        return Tokens.Fonts.Familiy.sfprodisplay.family
    }
    
    var fontWeight: Font.Weight {
        return Tokens.Fonts.Weight.regular.weight
    }
    
    var fontSize: CGFloat {
        return Tokens.Fonts.Size.xs.size
    }
}
