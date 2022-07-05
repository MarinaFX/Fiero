//
//  PrimaryTextField.swift
//  Fiero
//
//  Created by Marina De Pazzi on 04/07/22.
//

import Foundation
import SwiftUI

struct PrimaryTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .multilineTextAlignment(.leading)
            .font(.system(size: Tokens.Fonts.Size.xs.value, weight: Tokens.Fonts.Weight.regular.value, design: Tokens.Fonts.Familiy.support.value))
            .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
            .padding(Tokens.Spacing.xxxs.value)
            .frame(maxWidth: .infinity)
            .background(borderView)
    }
    
    var borderView: some View {
        RoundedRectangle(cornerRadius: Tokens.Border.BorderRadius.small.value)
            .stroke(Tokens.Colors.Neutral.High.pure.value, lineWidth: Tokens.Border.BorderWidth.thin.value)
    }
}

struct FlemisView: View {
    var body: some View {
        VStack {
            TextField("Flemis", text: .constant("Flemis"))
                .textFieldStyle(PrimaryTextFieldStyle())
                .padding(Tokens.Spacing.xs.value)
        }
        .background(Color.black)
    }
}

struct FlemisView_Previews: PreviewProvider {
    static var previews: some View {
        FlemisView()
    }
}

