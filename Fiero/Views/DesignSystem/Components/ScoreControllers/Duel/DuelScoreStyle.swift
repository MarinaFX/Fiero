//
 //  ScoreControllerDuelStyle.swift
 //  Fiero
 //
 //  Created by João Gabriel Biazus de Quevedo on 04/08/22.
 //

 import SwiftUI

 enum ScoreControllerStyle {
     case first
     case second

     //MARK: - Colors
     var backgroundColor: Color {
         switch self {
         case .first:
             return Tokens.Colors.Background.dark.value.opacity(0.9)
         case .second:
             return Tokens.Colors.Neutral.High.pure.value
         }
     }
     var buttonColor: Color {
         switch self {
         case .first:
             return Tokens.Colors.Neutral.High.pure.value
         case .second:
             return Tokens.Colors.Background.dark.value
         }
     }
     //MARK: - Fonts
     var nameFont: Font {
         return Tokens.FontStyle.title2.font(weigth: .regular)
     }
     var numberFont: Font {
         return Tokens.FontStyle.largeTitle.font(weigth: .bold)
     }

     //MARK: - Radius
     var borderRadius: CGFloat {
         return Tokens.Border.BorderRadius.normal.value
     }

     //MARK: - Icons
     var plusIcon: String {
         return "plus.circle.fill"
     }
     var minusIcon: String {
         return "minus.circle.fill"
     }

     var spacing: Double{
         return Tokens.Spacing.xxs.value
     }
     var spacingVertical: Double{
         return Tokens.Spacing.nano.value
     }
     var spacingAll: Double {
         return Tokens.Spacing.xs.value
     }
 }
