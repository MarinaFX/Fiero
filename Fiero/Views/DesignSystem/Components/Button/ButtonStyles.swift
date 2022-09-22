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
    case black(isEnabled: Bool)
    case tertiary(isEnabled: Bool)
    case destructive(isEnabled: Bool)
    
    //MARK: - Button variables
    var backgroundColor: Color {
        switch self {
        case .primary(let isEnabled):
            return isEnabled ? Tokens.Colors.Brand.Primary.pure.value : Tokens.Colors.Neutral.Low.light.value
        case .secondary(let isEnabled):
            return isEnabled ? Tokens.Colors.Neutral.High.pure.value : Tokens.Colors.Neutral.Low.light.value
        case .black:
            return isEnabled ? .clear : Tokens.Colors.Neutral.Low.dark.value;
        case .tertiary:
            return Tokens.Colors.Highlight.seven.value
        case .destructive:
            return isEnabled ? .clear : Tokens.Colors.Neutral.Low.dark.value
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
        case .black(let isEnabled):
            return isEnabled
        case .tertiary(let isEnabled):
            return isEnabled
        case .destructive(let isEnabled):
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
        case .black(isEnabled: let isEnabled):
            return isEnabled ? Tokens.Colors.Neutral.High.pure.value : Tokens.Colors.Neutral.High.dark.value
        case .tertiary(let isEnabled):
            return isEnabled ? Tokens.Colors.Neutral.High.pure.value : Tokens.Colors.Neutral.Low.pure.value
        case .destructive(isEnabled: let isEnabled):
            return isEnabled ? Tokens.Colors.Highlight.wrong.value : Tokens.Colors.Highlight.wrong.value
        }
    }
    
    var font: Font {
        return Tokens.FontStyle.callout.font(weigth: .bold)
    }
}
