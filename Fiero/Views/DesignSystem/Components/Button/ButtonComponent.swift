/**
 Custom Button proposed on Fiero's Design System. This view considers both Button variation styles (Primary and Secondary)
 
 - Author:
 Natália Brocca dos Santos
 
 - parameters:
    - style: The button styles variation to be used (Primary or Secondary).
    - isEnabled: Is a boolean inside the Style that indicates the button state (true = enabled, false = disabled).
    - text: The text of the button.
    - action: This var is a closure that passes a handler to the button action.
 */

import SwiftUI

//MARK: - View
struct ButtonComponent: View {
    @State var style: ButtonStyles
    @State var text: String
    
    var action: () -> Void
    
    var body: some View {
        Button(action: action, label: {
            Text(text)
                .foregroundColor(style.fontColor)
                .font(style.font)
                .padding(style.padding)
                .frame(maxWidth: .infinity)
                .background(style.backgroundColor)
                .cornerRadius(style.borderRadius)
        })
        .disabled(!style.isEnabled)
    }
}

//MARK: - Preview
struct ButtonComponent_Previews: PreviewProvider {
    static var previews: some View {
        ButtonComponent(style: .primary(isEnabled: true), text: "Estou pronto!", action: { })
    }
}
