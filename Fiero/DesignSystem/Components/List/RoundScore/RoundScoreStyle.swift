//
//  RoundScore.swift
//  Fiero
//
//  Created by João Gabriel Biazus de Quevedo on 15/07/22.
//

import SwiftUI

enum RoundScoreStyle {
    case win
    case lose
    case empty
    
    //MARK: Icon variables
    var icon: String {
        switch self {
        case .win:
            return "checkmark.circle.fill"
        case .lose:
            return "checkmark.circle.fill"
        case .empty:
            return "minus.circle.fill"
            
        }
    }
    var iconFont: Font {
        return Tokens.FontStyle.largeTitle.font(weigth: .regular)
    }
    
    var iconColor: Color {
        return Tokens.Colors.Neutral.Low.pure.value
    }
    
    //MARK: Body variables
    var backgroundColor: Color {
        switch self {
        case .win:
            return Tokens.Colors.Brand.Secondary.pure.value
        case .lose:
            return Tokens.Colors.Brand.Primary.pure.value
        case .empty:
            return Tokens.Colors.Neutral.High.light.value
        }
    }
    var borderWidth: CGFloat {
        return Tokens.Border.BorderWidth.thin.value
    }
    var borderColor: Color {
        return Tokens.Colors.Neutral.Low.pure.value
    }
    
    var borderRadius: CGFloat {
        return Tokens.Border.BorderRadius.circular.value
    }
    
    var spacing: Double{
        return Tokens.Spacing.nano.value
    }
}
