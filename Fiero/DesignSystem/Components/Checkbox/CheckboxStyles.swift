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
   
    //MARK: - Font variables
    var iconFont: Font {
        return Tokens.FontStyle.title3.font()
    }
    
    var textFont: Font {
        return Tokens.FontStyle.callout.font()
    }
    var linkedTextFont: Font {
        return Tokens.FontStyle.callout.font(weigth: .bold)
    }
    
    //MARK: - Colors
    var color: Color {
        switch self {
        case .light:
            return Tokens.Colors.Neutral.Low.pure.value
        case .dark:
            return Tokens.Colors.Neutral.High.pure.value
        }
    }
    //MARK: - Paddings
    var padding: Double {
        return Tokens.Spacing.nano.value
    }
}
