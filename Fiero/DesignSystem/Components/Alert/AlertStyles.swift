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
    
    var padding: Double{
        return Tokens.Spacing.nano.value
    }
    
    //MARK: Font variables
    var font: Font {
        return Tokens.FontStyle.callout.font()
    }
    
    var fontColor: Color {
        switch self {
        case .primary:
            return Tokens.Colors.Neutral.Low.pure.value
        case .secondary:
            return Tokens.Colors.Neutral.High.pure.value
        }
    }
}
