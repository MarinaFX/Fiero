//
//  PrimaryTextField.swift
//  Fiero
//
//  Created by Marina De Pazzi on 04/07/22.
//

import Foundation
import SwiftUI

//public protocol TextFieldStyle {
//    associatedtype _Body = View
//    @ViewBuilder func _body(configuration: TextField<Self._Label>) -> Self._Body
//    typealias _Label = _TextFieldStyleLabel
//}

struct PrimaryTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .multilineTextAlignment(.leading)
            .font(.system(size: Tokens.Fonts.Size.xs.value, weight: Tokens.Fonts.Weight.regular.value, design: Tokens.Fonts.Familiy.sfprodisplay.value))
            .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
            .padding(Tokens.Spacing.xxxs.value)
            .frame(maxWidth: .infinity)
            .background(borderView)
    }
    
    var borderView: some View {
        RoundedRectangle(cornerRadius: Tokens.Border.BorderRadius.small.value)
            .stroke(lineWidth: Tokens.Border.BorderWidth.hairline.value)
            .background(RoundedRectangle(cornerRadius: Tokens.Border.BorderRadius.small.value).foregroundColor(Tokens.Colors.Neutral.Low.pure.value))
    }
}

struct PrimaryTextFieldView<Content> : View where Content: View {
    var text: String
    var placeholder: String
    var content: Content

    init(text: String, placeholder: String, @ViewBuilder content: () -> Content) {
        self.text = text
        self.placeholder = placeholder
        self.content = content()
    }

    var body: some View {
        TextField("TitleKey", text: .constant("Text"))
            .textFieldStyle(.plain)
            .multilineTextAlignment(.center)
            .font(.system(size: Tokens.Fonts.Size.xg.value, weight: Tokens.Fonts.Weight.black.value, design: Tokens.Fonts.Familiy.sfprodisplay.value))
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: Tokens.Border.BorderRadius.small.value)
                    .stroke(lineWidth: Tokens.Border.BorderWidth.hairline.value)
                    .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
            )
    }

}

struct FlemisView: View {
    var body: some View {
        TextField("Flemis", text: .constant("Flemis"))
            .textFieldStyle(PrimaryTextFieldStyle())
            .padding(Tokens.Spacing.xs.value)
    }
}

struct FlemisView_Previews: PreviewProvider {
    static var previews: some View {
        FlemisView()
    }
}
