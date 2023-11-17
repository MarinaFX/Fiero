//
//  ChallengeCellComponent.swift
//  Fiero
//
//  Created by João Gabriel Biazus de Quevedo on 20/07/22.
//

import SwiftUI

struct ChallengeCellComponent: View {
    
    @State var style: ChallengeCellStyle
    @State var challengeName: String
    @State var player1: String
    @State var player2: String
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: style.borderRadius)
                .foregroundColor(style.backgroundColor)

            VStack(alignment:.leading ,spacing: style.verticalSpacing) {
                HStack() {
                    Text("\(challengeName)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(style.fontSize)
                        .foregroundColor(style.iconColor)
                    Image(systemName: style.icon)
                        .frame(alignment: .trailing)
                        .font(style.iconFontSize)
                        .foregroundColor(style.iconColor)
                }
                Text("Desafiantes: \(player1)" + " e " + "\(player2)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(style.fontSizeSupport)
                    .foregroundColor(style.iconColor)
                style.cell
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.top, style.verticalSpacing)
            .padding(.bottom, style.verticalSpacing)
            .padding(.leading, style.Horizontalspacing)
            .padding(.trailing, style.Horizontalspacing)
        }
        .padding(.horizontal, style.Horizontalspacing)
    }
}
struct ChallengeCellComponent_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeCellComponent(style: .quantity("100", "200"), challengeName: "Apenas Teste", player1: "Player 1", player2: "Player 2")
    }
}
