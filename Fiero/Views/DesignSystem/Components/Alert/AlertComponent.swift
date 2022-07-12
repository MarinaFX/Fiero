//
//  AlertComponent.swift
//  Fiero
//
//  Created by João Gabriel Biazus de Quevedo on 06/07/22.
//

import SwiftUI

struct AlertComponent: View {
    @State var style: AlertStyle
    @State var text: String
    @State var image: String
    
    var body: some View {
        HStack(spacing: style.padding){
            Image(systemName: image)
                .font(style.font)
                .foregroundColor(style.fontColor)
                .padding(.vertical, style.padding)
                .padding(.leading, style.padding)
            Text(text)
                .font(style.font)
                .foregroundColor(style.fontColor)
                .padding(.vertical, style.padding)
                .padding(.trailing, style.padding)
                
        }
        .background(style.backgroundColor)
        .cornerRadius(style.borderRadius)
    }
}

struct AlertComponent_Previews: PreviewProvider {
    static var previews: some View {
//        ButtonComponent(style: .primary, text: "Estou pronto!")
        AlertComponent(style: .secondary, text: "Usuário ou senha incorretos", image: "questionmark.circle")
    }
}
