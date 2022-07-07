//
//  ContentView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 14/06/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        CustomTextFieldView(type: .none, style: .secondary, placeholder: "fodase", helperText: "CANSADONA CANSADONA CAN SA DO NA. QUANDO CHEGA O FINAL DE SEMANA, QUERO DEITAR NA MINHA CAMA", isWrong: .constant(true), text: .constant("flemis"))
            .padding(Tokens.Spacing.xs.value)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
