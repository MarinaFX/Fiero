//
//  RoundScoreComponent.swift
//  Fiero
//
//  Created by João Gabriel Biazus de Quevedo on 15/07/22.
//

import SwiftUI

struct RoundScoreComponent: View {
    @State var style: RoundScoreStyle
    
    var body: some View {
        ZStack {
            Image(systemName: style.icon)
                .font(style.iconFont)
                .foregroundColor(style.backgroundColor)
                .background(style.iconColor)
                .clipShape(Circle())
        }
    }
}
struct RoundScoreComponent_Previews: PreviewProvider {
    static var previews: some View {
        RoundScoreComponent(style: .lose)
    }
}
