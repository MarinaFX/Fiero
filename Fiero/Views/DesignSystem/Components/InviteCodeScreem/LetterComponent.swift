//
//  LetterComponent.swift
//  Fiero
//
//  Created by Marcelo Diefenbach on 31/10/22.
//

import Foundation
import SwiftUI

//MARK: - View
struct LetterComponent: View {
    
    @State var letter: String?
    
    var body: some View {
        ZStack {
            Tokens.Colors.Brand.Primary.light.value
            Text(letter ?? "A")
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
        LetterComponent(letter: "A")
    }
}
