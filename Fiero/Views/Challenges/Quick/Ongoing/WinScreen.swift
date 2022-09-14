//
//  WinScreen.swift
//  Fiero
//
//  Created by Marcelo Diefenbach on 02/09/22.
//

import SwiftUI

struct WinScreen: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var animationAmount = 0.0
    
    var body: some View {
        // nao ta respeitando a largura da tela
        ZStack {
            Tokens.Colors.Background.dark.value
            
            LottieView(fileName: "winAnimation", reverse: false, loop: true, aspectFill: true)
            
            Image("youwin-en")
                .scaleEffect(animationAmount)
                .animation(
                    .interpolatingSpring(stiffness: 50, damping: 0.8)
                    .delay(0.2),
                    value: animationAmount
                )
                .onAppear{
                    animationAmount = 0.5
                }
                .frame(maxWidth: UIScreen.main.bounds.width)
            
            
            VStack {
                Spacer()
                ButtonComponent(style: .secondary(isEnabled: true), text: "Finalizar desafio", action: {
                    //TODO: - logic to finish challenge
                })
                ButtonComponent(style: .black(isEnabled: true), text: "Continuar marcando pontos", action: {
                    self.presentationMode.wrappedValue.dismiss()
                })
                .padding(.bottom, Tokens.Spacing.sm.value)
            }.frame(maxHeight: UIScreen.main.bounds.height)
                .padding(.horizontal)
        }
    }
}

struct WinScreen_Previews: PreviewProvider {
    static var previews: some View {
        WinScreen()
    }
}
