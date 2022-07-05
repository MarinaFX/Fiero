//
//  ButtonComponent.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 04/07/22.
//

import SwiftUI

struct ButtonComponent: View {
    @State var style: ButtonStyles
    @State var text: String
    @Binding var action: () -> Void
    
    var body: some View {
        Button(action: action, label: {
            Text(text)
                .foregroundColor(style.fontColor)
                .fontWeight(style.fontWeight)
                .font(.system(size: style.fontSize, weight: style.fontWeight, design: style.fontFamily))
                .padding(style.padding)
                .frame(maxWidth: .infinity)
                .background(style.backgroundColor)
                .cornerRadius(style.borderRadius)
        })
        .padding(style.padding)
        .disabled(!style.isEnabled)

    }
}

struct ButtonComponent_Previews: PreviewProvider {
    static var previews: some View {
        ButtonComponent(style: .primary(isEnabled: true), text: "Estou pronto!", action: .constant {})
    }
}
