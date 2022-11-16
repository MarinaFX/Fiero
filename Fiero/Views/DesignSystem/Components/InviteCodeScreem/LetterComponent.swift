//
//  LetterComponent.swift
//  Fiero
//
//  Created by Marcelo Diefenbach on 31/10/22.
//

import Foundation
import SwiftUI

enum LetterType {
    case input, onlyView
}

//MARK: - View
struct LetterComponent: View {
    
    @State var letter: String?
    @State var variant: LetterType
    
    var body: some View {
        ZStack {
            if variant == LetterType.onlyView {
                Tokens.Colors.Brand.Primary.light.value
            } else {
                Tokens.Colors.Neutral.Low.dark.value
            }
            Text(letter?.uppercased() ?? "A")
                .font(Tokens.FontStyle.largeTitle.font(weigth: .bold))
                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
        }.cornerRadius(Tokens.Border.BorderRadius.small.value)
    }
}

//MARK: - Preview
struct LetterComponent_Previews: PreviewProvider {
    static var previews: some View {
        LetterComponent(letter: "A", variant: .input)
    }
}
