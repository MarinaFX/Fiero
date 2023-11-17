//
//  ChallengeCellStyle.swift
//  Fiero
//
//  Created by João Gabriel Biazus de Quevedo on 20/07/22.
//

import SwiftUI

enum ChallengeCellStyle {
    
    case quantity(String, String)
    case time(String, String)
    case stopwatch(String, String)
    case md3([RoundScoreStyle])
    case md5([RoundScoreStyle])
    
    //MARK: Icon variables
    var cell: some View {
        switch self {
        case .quantity(let currentScore, let limitScore):
            return AnyView(QuantityTimeComponent(style: .quantity, currentScore: currentScore, limitScore: limitScore))
        case .time(let currentScore, let limitScore):
            return AnyView(QuantityTimeComponent(style: .timer, currentScore: currentScore, limitScore: limitScore))
        case .stopwatch(let currentScore, let limitScore):
            return AnyView(QuantityTimeComponent(style: .stopwatch, currentScore: currentScore, limitScore: limitScore))
        case .md3(let array):
            return AnyView(BestOfComponent(status: array))
        case .md5(let array):
            return AnyView(BestOfComponent(status: array))
            
        }
    }
    //MARK: Body variables
    var backgroundColor: Color {
        return Tokens.Colors.Neutral.Low.dark.value
    }
    var borderRadius: CGFloat {
        return Tokens.Border.BorderRadius.small.value
    }
    var spacing: Double{
        return Tokens.Spacing.xxxs.value
    }
    var verticalSpacing: Double{
        return Tokens.Spacing.xxxs.value
    }
    
    //MARK: Title variables
    var fontSize: Font {
        return Tokens.FontStyle.title3.font(weigth: .bold)
    }
    var iconColor: Color {
        return Tokens.Colors.Neutral.High.pure.value
    }
    var Horizontalspacing: Double{
        return Tokens.Spacing.xxxs.value
    }
    
    //MARK: Support Text variables
    var fontSizeSupport: Font {
        return Tokens.FontStyle.caption.font(weigth: .regular)
    }
    
    //MARK: Icon variables
    var icon: String {
        return "chevron.right"
    }
    var iconFontSize: Font {
        return Tokens.FontStyle.title3.font(weigth: .bold)
    }
    
}
