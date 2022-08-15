//
//  ScoreController3-4Component.swift
//  Fiero
//
//  Created by Lucas Dimer Justo on 09/08/22.
//

import SwiftUI

struct ScoreController3_4Component: View {
    var foreGroundColor: Color
    var playerName: String
    @Binding var playerScore: Double
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Tokens.Border.BorderRadius.small.value)
                .foregroundColor(foreGroundColor)
            HStack {
                Button {
                    playerScore -= 1
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Tokens.Colors.Neutral.Low.pure.value)
                }
                Spacer()
                VStack {
                    Text("\(playerScore, specifier: "%.0f")")
                        .font(Tokens.FontStyle.largeTitle.font())
                        .foregroundColor(Tokens.Colors.Neutral.Low.pure.value)
                    
                    Text(playerName)
                        .font(Tokens.FontStyle.callout.font())
                        .foregroundColor(Tokens.Colors.Neutral.Low.pure.value)
                }
                Spacer()
                Button {
                    playerScore += 1
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.black)
                }

            }
            .padding(.horizontal, Tokens.Spacing.xs.value)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity , alignment: .center)
    }
}

struct ScoreController3_4Component_Previews: PreviewProvider {
    static var previews: some View {
        ScoreController3_4Component(foreGroundColor: .yellow, playerName: "Name", playerScore: .constant(0))
    }
}
