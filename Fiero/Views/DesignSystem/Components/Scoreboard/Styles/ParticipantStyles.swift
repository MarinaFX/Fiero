//
//  ParticipantStyles.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 20/07/22.
//

import SwiftUI

enum ParticipantStyles: Equatable {
    case participantDefault(isSmall: Bool)
    case participantLooser(isSmall: Bool)
    
    //MARK: Color
    var textAndPointsColor: Color {
        return Tokens.Colors.Neutral.Low.pure.value
    }
    //MARK: Fonts
    var iconFont: Font {
        switch self {
        case .participantDefault(let isSmall):
            return isSmall ? .system(size: 42) : .system(size: 55)
        case .participantLooser(let isSmall):
            return isSmall ? .system(size: 42) : .system(size: 55)
        }
    }
    var textFont: Font {
        switch self {
        case .participantDefault(let isSmall):
            return isSmall ? Tokens.FontStyle.caption.font() : Tokens.FontStyle.callout.font()
        case .participantLooser(let isSmall):
            return isSmall ? Tokens.FontStyle.caption.font() : Tokens.FontStyle.callout.font()
        }
    }
    var pointsFont: Font {
        switch self {
        case .participantDefault(let isSmall):
            return isSmall ? Tokens.FontStyle.callout.font(weigth: .bold) : Tokens.FontStyle.title3.font(weigth: .bold)
        case .participantLooser(let isSmall):
            return isSmall ? Tokens.FontStyle.callout.font(weigth: .bold) : Tokens.FontStyle.title3.font(weigth: .bold)
        }
    }
    //MARK: - Size
    var width: CGFloat {
        switch self {
        case .participantDefault(let isSmall):
            return isSmall ? 70 : 97
        case .participantLooser(let isSmall):
            return isSmall ? 70 : 97
        }
    }
    //MARK: Border
    var borderRadius: CGFloat {
        return Tokens.Border.BorderRadius.circular.value
    }
    //MARK: Spacing
    var spacing: CGFloat {
        return Tokens.Spacing.nano.value
    }
    //MARK: Saturation
    var saturation: Double {
        switch self {
        case .participantDefault(let isSmall):
            return isSmall ? 1 : 1
        case .participantLooser(let isSmall):
            return isSmall ? 0 : 0
        }
    }
}




