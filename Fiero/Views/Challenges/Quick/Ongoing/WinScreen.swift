//
//  WinScreen.swift
//  Fiero
//
//  Created by Marcelo Diefenbach on 02/09/22.
//

import SwiftUI

struct WinScreen: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var animationBG = 0.0
    @State private var animationText = 0.0
    
    @State var angle: Double = 0.0
    @State var isAnimating = true
    
    @State var winnerName: String
    
    var foreverAnimation: Animation {
        Animation.linear(duration: 4.0)
            .repeatForever(autoreverses: false)
    }
    
    var body: some View {
        ZStack {
            Tokens.Colors.Background.dark.value
            
            LottieView(fileName: "winAnimation", reverse: false, loop: true, aspectFill: true)
            
            Image("bg_winner")
                .rotationEffect(Angle(degrees: self.isAnimating ? self.angle : 360.0))
                .onAppear {
                    withAnimation(self.foreverAnimation) {
                        self.angle += 360.0
                    }
                    animationBG = 0.3
                }
                .scaleEffect(animationBG)
                .animation(
                    .interpolatingSpring(stiffness: 20, damping: 1)
                    .delay(0.2),
                    value: animationBG
                )
                .frame(maxWidth: UIScreen.main.bounds.width)
            
            Image("win")
                .scaleEffect(animationText)
                .animation(
                    .interpolatingSpring(stiffness: 20, damping: 1)
                    .delay(0.2),
                    value: animationText
                )
                .onAppear{
                    animationText = 0.5
                }
                .frame(maxWidth: UIScreen.main.bounds.width)
                .rotationEffect(.degrees(-8))
            
            VStack {
                Text("1ª colocação")
                    .font(Tokens.FontStyle.callout.font(weigth: .regular))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                Text(winnerName)
                    .font(Tokens.FontStyle.largeTitle.font(weigth: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                Spacer()
            }.padding(.top, UIScreen.main.bounds.height*0.3)
            
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
        WinScreen(winnerName: "Marcelo")
    }
}
