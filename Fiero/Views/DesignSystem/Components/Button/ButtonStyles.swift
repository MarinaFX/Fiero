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
    
    //MARK: - Button variables
    var backgroundColor: Color {
        switch self {
        case .primary(let isEnabled):
            return isEnabled ? Tokens.Colors.Brand.Primary.pure.value : Tokens.Colors.Neutral.Low.light.value
        case .secondary(let isEnabled):
            return isEnabled ? Tokens.Colors.Neutral.High.pure.value : Tokens.Colors.Neutral.Low.light.value
        }
    }
    
    var padding: Double {
        return Tokens.Spacing.xxxs.value
    }
    
    var borderRadius: CGFloat {
        return Tokens.Border.BorderRadius.small.value
    }
    
    var isEnabled: Bool {
        switch self {
        case .primary(let isEnabled):
            return isEnabled
        case .secondary(let isEnabled):
            return isEnabled
        }
    }
    
    //MARK: - Font variables
    var fontColor: Color {
        switch self {
        case .primary(let isEnabled):
            return isEnabled ? Tokens.Colors.Neutral.High.pure.value : Tokens.Colors.Neutral.High.dark.value
        case .secondary(let isEnabled):
            return isEnabled ? Tokens.Colors.Neutral.Low.pure.value : Tokens.Colors.Neutral.High.dark.value
        }
    }
    
    var font: Font {
        return Tokens.FontStyle.callout.font(weigth: .bold)
    }
}
