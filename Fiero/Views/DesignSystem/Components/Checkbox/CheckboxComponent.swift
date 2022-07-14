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
    @State var linkedText: String?
    @Binding var isChecked: Bool
    var checkboxHandler: (_ isChecked: Bool) -> Void
    var linkedTextHandler: (() -> Void)?
    
    var body: some View {
        HStack {
            Image(systemName: isChecked ? "checkmark.square" : "square")
                .foregroundColor(style.color)
                .font(style.iconFont)
                .onTapGesture {
                    isChecked.toggle()
                    checkboxHandler(isChecked)
                }
            Text(text)
                .foregroundColor(style.color)
                .font(style.textFont)
            Text(linkedText ?? "")
                .foregroundColor(style.color)
                .font(style.textFont)
                .underline()
                .onTapGesture(perform: linkedTextHandler ?? {})
        }
        .padding(.horizontal, style.padding)
    }
}

struct CheckboxComponent_Previews: PreviewProvider {
    static var previews: some View {
        CheckboxComponent(style: .light, text: "Concordo com os", linkedText: "termos de uso", isChecked: .constant(true), checkboxHandler: { isChecked in
            print(isChecked)
        }, linkedTextHandler: {
        })
    }
}
