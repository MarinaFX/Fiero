//
//  OnlineOrOfflineStyles.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 19/10/22.
//

import SwiftUI

enum OnlineOrOfflineStyles {
    case online
    case offline
    
    var title: String {
        switch self {
        case .online:
            return "Online"
        case .offline:
            return "Offline"
        }
    }
    
    var description: LocalizedStringKey {
        switch self {
        case .online:
            return "firstCardDescription"
        case .offline:
            return "secondCardDescription"
        }
    }
    
    var titleFont: Font {
        return Tokens.FontStyle.largeTitle.font(weigth: .semibold, design: .rounded)
    }
    
    var descriptionFont: Font {
        return Tokens.FontStyle.subheadline.font(weigth: .semibold, design: .rounded)
    }
    
    var backgroundColor: Color {
        return Tokens.Colors.Neutral.Low.dark.value
    }
    
    var foregroundColor: Color {
        return Tokens.Colors.Neutral.High.pure.value
    }
    
    var cornerRadius: CGFloat {
        return Tokens.Border.BorderRadius.normal.value
    }
    
    var spacingBetween: CGFloat {
        return Tokens.Spacing.quarck.value
    }
}
