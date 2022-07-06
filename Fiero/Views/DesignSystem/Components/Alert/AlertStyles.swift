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
            return Tokens.Colors.Neutral.High.pure.value
        case .secondary:
            return Tokens.Colors.Brand.Primary.pure.value
        }
    }
    var borderRadius: CGFloat {
        return Tokens.Border.BorderRadius.small.value
    }
    
    //MARK: Font variables
    var fontSize: CGFloat {
        return Tokens.Fonts.Size.xs.value
    }
    var fontColor: Color {
        switch self {
        case .primary:
            return Tokens.Colors.Neutral.Low.pure.value
        case .secondary:
            return Tokens.Colors.Neutral.High.pure.value
        }
    }
    var fontFamily: Font.Design {
        return Tokens.Fonts.Familiy.support.value
    }
    var fontWeight: Font.Weight {
        return Tokens.Fonts.Weight.regular.value
    }
    var padding: Double{
        return Tokens.Spacing.nano.value
    }
}
