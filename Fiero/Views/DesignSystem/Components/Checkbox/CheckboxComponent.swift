//
//  CheckboxComponent.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 06/07/22.
//

import SwiftUI

struct CheckboxComponent: View {
    @State var style: CheckboxStyles
    @State var text: String
    //@Binding var checkboxState: Bool
    
    var body: some View {
        HStack {
            Image(systemName: style.imageName)
                .foregroundColor(style.color)
                .font(.custom("SFUIDisplay",
                              size: Tokens.Fonts.Size.sm.value,
                              relativeTo: .body))
            Text(text)
                .foregroundColor(style.color)
                .font(.custom("SFUIDisplay",
                               size: style.fontSize,
                               relativeTo: .body))
//TODO: - Ajust Text Font (New Tokens)
        }
        .padding(.horizontal, style.padding)
    }
}

struct CheckboxComponent_Previews: PreviewProvider {
    static var previews: some View {
        CheckboxComponent(style: .unchecked(isDark: false), text: "Concordo com os termos de uso")
    }
}
