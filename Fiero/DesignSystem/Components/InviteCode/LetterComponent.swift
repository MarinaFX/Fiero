//
//  LetterComponent.swift
//  Fiero
//
//  Created by Marcelo Diefenbach on 31/10/22.
//

import Foundation
import SwiftUI

enum LetterType {
    case input
    case onlyView
    
    var backgroundColor: Color {
        switch self {
        case .input:
            return Tokens.Colors.Neutral.Low.dark.value
        case .onlyView:
            return Tokens.Colors.Brand.Primary.light.value
        }
    }
}

//MARK: - View
struct LetterComponent: View {
    @State var letter: String?
    @State var variant: LetterType
    
    var body: some View {
        ZStack {
            variant.backgroundColor
            
            Text(letter?.uppercased() ?? "A")
                .font(Tokens.FontStyle.largeTitle.font(weigth: .bold,
                                                       design: .rounded))
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
