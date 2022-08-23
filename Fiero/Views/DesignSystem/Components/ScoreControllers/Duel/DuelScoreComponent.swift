//
 //  ScoreControllerDuel.swift
 //  Fiero
 //
 //  Created by João Gabriel Biazus de Quevedo on 04/08/22.
 //

import SwiftUI

struct DuelScoreComponent: View {

     @State var style: ScoreControllerStyle
     @State var maxValue: Int
     @State var count: Int = 0
     @State var playerName: String

     var body: some View {
         ZStack{
             RoundedRectangle(cornerRadius: style.borderRadius)
                 .foregroundColor(style.backgroundColor)
                 .opacity(0.2)

             VStack(alignment:.center, spacing: Tokens.Spacing.nano.value ) {
                 HStack() {
                     Button(action: {
                        count -= 1
                     }) {
                         Image(systemName: style.minusIcon)
                             .resizable()
                             .frame(width: 40, height: 40)
                             .foregroundColor(style.buttonColor)

                     }
                     .padding(.leading, style.spacing)

                     Spacer()

                     Text("\(count)")
                         .foregroundColor(style.buttonColor)
                         .font(style.numberFont)

                     Spacer()

                     Button(action: {
                        count += 1
                     }) {
                         Image(systemName: style.plusIcon)
                             .resizable()
                             .frame(width: 40, height: 40)
                             .foregroundColor(style.buttonColor)
                     }
                     .padding(.trailing, style.spacing)
                 }
                 .padding(.vertical, style.spacingVertical)

                 Text("\(playerName)")
                     .foregroundColor(style.buttonColor)
                     .font(style.nameFont)
                     .padding(.horizontal, style.spacingVertical)
             }
             .padding(.vertical, style.spacingAll)
         }
         .frame(height: 120)
     }
 }

struct DuelScoreComponent_Previews: PreviewProvider {
    static var previews: some View {
        DuelScoreComponent(style: .first, maxValue: 10, playerName: "Alpaca Enfurecida")
    }
}
