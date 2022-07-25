//
//  CustomTextFieldView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 06/07/22.
//

import SwiftUI

//MARK: - View

/**
 Custom TextField proposed on Fiero's Design System. This view considers both TextField variation styles (Primary and Secondary)
 
 - Author:
 Marina De Pazzi
 
 - parameters:
    - type: The TextField Variation (with icon, with helper text, with both, with none). If none provided only the TextField will be used with none by default.
    - style: The Style variation to be used (Primary or Secondary). If none provided the Primary style will be used by default.
    - placeholder: The placeholder of the Text Field. If none provided the placeholder will be "Placeholder" by default.
    - helperText: The helper, giving users a hint of what to fill. If no String is provided, no helper text will be displayed by default.
    - text: The user's input on the text field. This must be provided in order to retrieve the TextField input.
 */
struct CustomTextFieldView: View {

    enum TextFieldType {
        case icon
        case helper
        case both
        case none
    }
    
    //MARK: - Variables Setup
    var type: TextFieldType = .none
    var style: Variant = .primary
    var placeholder: String = "Placeholder"
    var helperText: String = ""
    var keyboardType: UIKeyboardType = .default
    
    @State private(set) var isSecure: Bool = false
    @State private(set) var isLowCase: Bool = false
    @Binding private(set) var isWrong: Bool
    @Binding private(set) var text: String

    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .trailing) {
                
                //MARK: - TextField
                if self.isSecure {
                    if isLowCase{
                        SecureField("", text: self.$text)
                            .textFieldStyle(PrimaryTextFieldStyle(variant: style, wrong: self.isWrong))
                            .placeholder(when: text.isEmpty) {
                                Text(self.placeholder).foregroundColor(Tokens.Colors.Neutral.Low.light.value)
                                    .padding(.leading, Tokens.Spacing.xxxs.value)
                        }
                            .autocapitalization(.none)
                    }else{
                        SecureField("", text: self.$text)
                            .textFieldStyle(PrimaryTextFieldStyle(variant: style, wrong: self.isWrong))
                            .placeholder(when: text.isEmpty) {
                                Text(self.placeholder).foregroundColor(Tokens.Colors.Neutral.Low.light.value)
                                    .padding(.leading, Tokens.Spacing.xxxs.value)
                        }
                    }
                    
                }
                else {
                    if isLowCase{
                        TextField("", text: self.$text)
                            .textFieldStyle(PrimaryTextFieldStyle(variant: style, wrong: self.isWrong))
                            .placeholder(when: text.isEmpty) {
                                Text(self.placeholder).foregroundColor(Tokens.Colors.Neutral.Low.light.value)
                                    .padding(.leading, Tokens.Spacing.xxxs.value)
                        }
                            .keyboardType(self.keyboardType)
                            .autocapitalization(.none)
                    }else{
                        TextField("", text: self.$text)
                            .textFieldStyle(PrimaryTextFieldStyle(variant: style, wrong: self.isWrong))
                            .placeholder(when: text.isEmpty) {
                                Text(self.placeholder).foregroundColor(Tokens.Colors.Neutral.Low.light.value)
                                    .padding(.leading, Tokens.Spacing.xxxs.value)
                        }
                    }
                }
                
                //MARK: - TextField show/hide button
                if ((type == .icon) || (type == .both)) {
                    Button(action: {
                        isSecure.toggle()
                    }, label: {
                        if #available(iOS 15.0, *) {
                            Image(systemName: self.isSecure ? "eye.slash" : "eye")
                                .font(Tokens.FontStyle.callout.font())
                                .tint(self.style == .primary ? Tokens.Colors.Neutral.High.pure.value : Tokens.Colors.Neutral.Low.pure.value)
                        } else {
                            Image(systemName: self.isSecure ? "eye.slash" : "eye")
                                .font(Tokens.FontStyle.callout.font())
                                .accentColor(self.style == .primary ? Tokens.Colors.Neutral.High.pure.value : Tokens.Colors.Neutral.Low.pure.value)
                        }
                    })
                    .padding(.trailing, Tokens.Spacing.xxxs.value)
                }
            }
            
            //MARK: - Helper Text
            if ((type == .helper) || (type == .both)) {
                Text(self.helperText)
                    .font(Tokens.FontStyle.caption.font())
                    .foregroundColor(self.style == .primary ? Tokens.Colors.Neutral.High.pure.value : Tokens.Colors.Neutral.Low.pure.value)
            }

        }
    }
}

struct CustomTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextFieldView(type: .both, style: .secondary, placeholder: "fodase", helperText: "CANSADONA CANSADONA CAN SA DO NA.", isSecure: false, isLowCase: true ,isWrong: .constant(true), text: .constant("flemis"))
            .padding(Tokens.Spacing.xs.value)
    }
}
