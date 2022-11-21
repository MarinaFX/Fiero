//
//  WinScreen.swift
//  Fiero
//
//  Created by Marcelo Diefenbach on 02/09/22.
//

import SwiftUI

struct WinScreen: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var isFinished: Bool
    
    @State private var ended: Bool = false
    @State private var animationBG = 0.0
    @State private var animationText = 0.0
    @State var angle: Double = 0.0
    @State var isAnimating = true   
    @State var winnerName: String
    @State var comeFrom: String
    
    var foreverAnimation: Animation {
        Animation.linear(duration: 4.0)
            .repeatForever(autoreverses: false)
    }
    
    var body: some View {
        ZStack {
            Tokens.Colors.Background.dark.value
            
            LottieView(fileName: "winAnimation", reverse: false, loop: true, aspectFill: true, ended: $ended)
            
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
            
            //TODO: get winner name of score controller component
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
            }
            .padding(.top, UIScreen.main.bounds.height*0.4)
            .hidden()
            
            VStack {
                Spacer()
                if comeFrom == "online" {
                    ButtonComponent(style: .black(isEnabled: true), text: "Finalizar desafio", action: {
                        isFinished = false
                        RootViewController.popToRootViewController()
                    })
                    .padding(.bottom, Tokens.Spacing.lg.value)
                    
                } else {
                    ButtonComponent(style: .secondary(isEnabled: true), text: "Continuar marcando pontos", action: {
                        self.dismiss()
                    })
                    .padding(.bottom, Tokens.Spacing.lg.value)
                    
                }
            }
            .frame(maxHeight: UIScreen.main.bounds.height)
            .padding(.horizontal)
        }
        .navigationBarHidden(true)
    }
}

struct WinScreen_Previews: PreviewProvider {
    static var previews: some View {
        WinScreen(isFinished: .constant(true), winnerName: "Marcelo", comeFrom: "online")
    }
}
