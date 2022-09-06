//
//  WinScreen.swift
//  Fiero
//
//  Created by Marcelo Diefenbach on 02/09/22.
//

import SwiftUI

struct WinScreen: View {
    
    @State private var animationAmount = 0.0
    @State private var fontSize = 18
    
    var body: some View {
        ZStack {
            Tokens.Colors.Background.dark.value.ignoresSafeArea()
            LottieView(fileName: "winAnimation", reverse: false, loop: true, aspectFill: true)
            Image("youwin-en")
                .scaleEffect(animationAmount)
                .animation(
                    .interpolatingSpring(stiffness: 50, damping: 1)
                    .delay(0.2),
                    value: animationAmount
                )
                .onAppear{
                    animationAmount = 0.5
                }
        }.ignoresSafeArea()
    }
}

struct WinScreen_Previews: PreviewProvider {
    static var previews: some View {
        WinScreen()
    }
}
