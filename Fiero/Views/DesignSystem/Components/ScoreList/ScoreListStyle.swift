//
//  ScoreListStyle.swift
//  Fiero
//
//  Created by João Gabriel Biazus de Quevedo on 16/11/22.
//

import SwiftUI

enum ScoreListStyle {
    case owner
    case player

    //MARK: - Colors
    var backgroundColor: Color {
        switch self {
        case .owner:
            return Tokens.Colors.Background.light.value
        case .player:
            return Tokens.Colors.Neutral.Low.dark.value
        }
    }
    var labelColor: Color {
        switch self {
        case .owner:
            return Tokens.Colors.Neutral.Low.dark.value
        case .player:
            return Tokens.Colors.Neutral.High.pure.value
        }
    }
    //MARK: - Fonts
    var numberFont: Font {
        return Tokens.FontStyle.title2.font(weigth: .bold)
    }
    var cellFont: Font {
        return Tokens.FontStyle.body.font(weigth: .bold)
    }

    //MARK: - Radius
    var borderRadius: CGFloat {
        return Tokens.Border.BorderRadius.small.value
    }
    //MARK: - Spacing
    var spacing: CGFloat {
        return Tokens.Spacing.defaultMargin.value
    }
}
