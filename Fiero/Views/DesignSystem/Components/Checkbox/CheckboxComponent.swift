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
    @State var isChecked: Bool = false
    @State var tapHandler: (_ isChecked: Bool) -> Void
    
    var body: some View {
        HStack {
            Image(systemName: isChecked ? "checkmark.square" : "square")
                .foregroundColor(style.color)
                .font(.custom("SFUIDisplay",
                              size: Tokens.Fonts.Size.sm.value,
                              relativeTo: .body))
                .onTapGesture {
                    isChecked.toggle()
                    tapHandler(isChecked)
                }
            Text(text)
                .foregroundColor(style.color)
                .font(.custom("SFUIDisplay",size: style.fontSize,relativeTo: .body))
            //TODO: - Ajust Text Font (New Tokens)
        }
        .padding(.horizontal, style.padding)
    }
}

struct CheckboxComponent_Previews: PreviewProvider {
    static var previews: some View {
        CheckboxComponent(style: .light, text: "Concordo com os termos de uso", tapHandler: { isChecked in
            print(isChecked)
        })
    }
}
