//
//  CreationFlowTextViewStyles.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 18/11/22.
//

import UIKit

enum CreationFlowTextViewStyles {
    case name
    case points
    
    var textColor: CGColor {
        return Tokens.Colors.Neutral.High.pure.value.cgColor!
    }
    
    var backgroundColor: CGColor {
        return UIColor.clear.cgColor
    }
    
    var textFont: UIFont {
        return .preferredFont(forTextStyle: .largeTitle)
    }
    
    var keyboardType: UIKeyboardType {
        switch self {
        case .name:
            return .alphabet
        case .points:
            return .numberPad
        }
    }
    
    var returnKeyType: UIReturnKeyType {
        return .default
    }
    
    
}
