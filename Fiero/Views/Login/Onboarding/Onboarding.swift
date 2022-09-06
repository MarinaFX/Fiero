//
//  Onboarding.swift
//  Fiero
//
//  Created by Marcelo Diefenbach on 28/08/22.
//

import Foundation
import SwiftUI

struct OnboardingScreen: View {

    @Binding private(set) var isFirstLogin: Bool
    let defaults = UserDefaults.standard
    
    var body: some View {
        ZStack {
            Tokens.Colors.Brand.Primary.pure.value.ignoresSafeArea()
            VStack {
                HStack {
                    VStack {
                        Spacer()
                        GifImage("furioso")
                            .frame(width: .infinity, height: 200)
                            .padding(.top, Tokens.Spacing.lg.value)
                            .padding(.horizontal, Tokens.Spacing.defaultMargin.value)
                        TabView{
                            OnboardingCard(title: "Crie desafios!", subtitle: "E convide os seus\namigos para participar\nda competição")
                            OnboardingCard(title: "Defina a meta\ndo desafio", subtitle: "Tenha controle \nsobre os pontos de todos\nos participantes")
                            OnboardingCard(title: "Saiba quem\nvenceu!", subtitle: "Receba um aviso quando \num dos desafiantes\nconcluir o objeitvo")
                            OnboardingCard(title: "Comece a\ndesafiar os\nseus amigos\nagora mesmo", subtitle: "")
                        }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                        .frame(height: 300)
                        .padding(.bottom, Tokens.Spacing.defaultMargin.value)
                    }
                }
                HStack{
                    ZStack {
                        Tokens.Colors.Background.dark.value.ignoresSafeArea()
                        VStack {
                            ButtonComponent(style: .secondary(isEnabled: true),
                                            text: "Ir para o login",
                                            action: {
                                self.isFirstLogin.toggle()
                            })
                            .padding(.top ,Tokens.Spacing.defaultMargin.value)
                            .padding(.horizontal, Tokens.Spacing.defaultMargin.value)
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}

struct OnboardingScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingScreen(isFirstLogin: .constant(false))
    }
}

