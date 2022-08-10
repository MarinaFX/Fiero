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

             VStack(alignment:.center ) {
                 HStack() {
                     Button(action: {
                         if count > 0{
                             count -= 1
                         }
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
                         .font(.system(size: 34))
                         .bold()

                     Spacer()

                     Button(action: {
                         if count < maxValue{
                             count += 1
                         }
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
                     .font(.system(size: 24))
                     .padding(.horizontal, style.spacingVertical)
             }
         }
         .frame(width: 285, height: 120)
     }
 }

struct DuelScoreComponent_Previews: PreviewProvider {
    static var previews: some View {
        DuelScoreComponent(style: .first, maxValue: 10, playerName: "Alpaca Enfurecida")
    }
}
