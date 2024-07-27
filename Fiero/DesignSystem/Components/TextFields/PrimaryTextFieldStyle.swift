//
//  PrimaryTextField.swift
//  Fiero
//
//  Created by Marina De Pazzi on 04/07/22.
//

import Foundation
import SwiftUI

struct PrimaryTextFieldStyle: TextFieldStyle {
    var variant: Variant = .primary
    var wrong: Bool = false
    
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .multilineTextAlignment(.leading)
            .font(Tokens.FontStyle.callout.font())
            .foregroundColor(variant == .primary ? Tokens.Colors.Neutral.High.pure.value : Tokens.Colors.Neutral.Low.pure.value)
            .padding(Tokens.Spacing.xxxs.value)
            .frame(maxWidth: .infinity)
            .background(borderView)
    }
    
    var borderView: some View {
        RoundedRectangle(cornerRadius: Tokens.Border.BorderRadius.small.value)
            .stroke(variant == .primary ?
                    (wrong ? Tokens.Colors.Highlight.wrong.value : Tokens.Colors.Neutral.High.pure.value) :
                        (wrong ? Tokens.Colors.Highlight.wrong.value : Tokens.Colors.Neutral.Low.pure.value),
                    lineWidth: Tokens.Border.BorderWidth.thin.value)
    }
}

struct FlemisView: View {
    var body: some View {
        VStack {
            TextField("Flemis", text: .constant("Flemis"))
                .textFieldStyle(PrimaryTextFieldStyle(variant: .secondary, wrong: false))
                .padding(Tokens.Spacing.xs.value)
        }
        .background(Color.purple)
    }
}

struct FlemisView_Previews: PreviewProvider {
    static var previews: some View {
        FlemisView()
    }
}

