//
//  AlertStyles.swift
//  Fiero
//
//  Created by João Gabriel Biazus de Quevedo on 06/07/22.
//

import SwiftUI

enum AlertStyle {
    case primary
    case secondary
    
    //MARK: view variables
    var backgroundColor: Color {
        switch self {
        case .primary:
            return Tokens.Colors.Neutral.High.pure.color
        case .secondary:
            return Tokens.Colors.Brand.Primary.pure.color
        }
    }
    var borderRadius: CGFloat {
        return Tokens.Border.BorderRadius.small.borderRadius
    }
    
    //MARK: Font variables
    var fontSize: CGFloat {
        return Tokens.Fonts.Size.xs.size
    }
    var fontColor: Color {
        switch self {
        case .primary:
            return Tokens.Colors.Neutral.Low.pure.color
        case .secondary:
            return Tokens.Colors.Neutral.High.pure.color
        }
    }
    var fontFamily: Font.Design {
        return Tokens.Fonts.Familiy.sfprodisplay.family
    }
    var fontWeight: Font.Weight {
        return Tokens.Fonts.Weight.regular.weight
    }
    var padding: Double{
        return Tokens.Spacing.nano.spacing
    }
}
