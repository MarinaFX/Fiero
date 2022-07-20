/**
 Custom Checkbox proposed on Fiero's Design System.
 
 - Author:
 Natália Brocca dos Santos
 
 - parameters:
    - style: The Checkbox color theme (dark mode and light mode).
    - text: The text to be used on the side of the checkbox.
    - linkedText: The text on the side of checkbox that will have an action. The linkedText is opcional.
    - isChecked: Is a boolean binding var that storage the status of checkbox (true = checked, false = empty)
    - checkboxHandler: This var is a closure that passes a handler to the checkbox state (takes isChecked as a parameter).
    - linkedTextHandler: This var is a closure that passes a handler to the linkedText action.
 */

import SwiftUI

//MARK: - View

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
                .accessibilityLabel(isChecked ? "Botão: caixa de seleção de \(text) \(linkedText ?? "") preenchida" : "Botão: caixa de seleção de \(text) \(linkedText ?? "") não preenchida")
            Text(text)
                .foregroundColor(style.color)
                .font(style.textFont)
                .accessibilityLabel("\(text) \(linkedText ?? "")")
            Text(linkedText ?? "")
                .foregroundColor(style.color)
                .font(style.textFont)
                .underline()
                .accessibilityLabel("Clique para acessar \(linkedText ?? "")")
                .onTapGesture(perform: linkedTextHandler ?? {})
        }
        .padding(.horizontal, style.padding)
    }
}
//MARK: - Preview
struct CheckboxComponent_Previews: PreviewProvider {
    static var previews: some View {
        CheckboxComponent(style: .light, text: "Concordo com os", linkedText: "termos de uso", isChecked: .constant(true), checkboxHandler: { isChecked in
            print(isChecked)
        }, linkedTextHandler: {
        })
    }
}
