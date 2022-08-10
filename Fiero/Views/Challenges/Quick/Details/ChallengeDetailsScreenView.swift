//
//  ChallengeDetailsScreenView.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 20/07/22.
//

import SwiftUI

struct ChallengeDetailsScreenView: View {
    
    var color: Color {
        return Tokens.Colors.Neutral.High.pure.value
    }
    var quarkSpacing: CGFloat {
        return Tokens.Spacing.quarck.value
    }
    var nanoSpacing: CGFloat {
        return Tokens.Spacing.nano.value
    }
    var extraExtraExtraSmallSpacing: CGFloat {
        return Tokens.Spacing.xxxs.value
    }
    var largeSpacing: CGFloat {
        return Tokens.Spacing.lg.value
    }
    var titleFont: Font {
        return Tokens.FontStyle.title2.font(weigth: .bold)
    }
    var descriptionFont: Font {
        return Tokens.FontStyle.caption.font()
    }
    
    var body: some View {
        ZStack {
            Color.black
            VStack {
                VStack(spacing: largeSpacing) {
                    VStack (alignment: .center, spacing: nanoSpacing) {
                        HStack(spacing: nanoSpacing) {
                            Image(systemName: "stopwatch.fill")
                                .font(titleFont)
                                .foregroundColor(color)
                            Text("Fazer agachamento")
                                .font(titleFont)
                                .foregroundColor(color)
                        }.padding(.top, largeSpacing)
                        Text("Quem fizer mais\nrepetições dentro de")
                            .multilineTextAlignment(.center)
                            .font(descriptionFont)
                            .foregroundColor(color)
                        Text("10min")
                            .font(titleFont)
                            .foregroundColor(color)
                    }
                    
                    VStack(spacing: extraExtraExtraSmallSpacing) {
                        Text("Participantes")
                            .font(titleFont)
                            .foregroundColor(color)
                        GroupComponent(style: [.participantDefault, .participantLooser], name: ["Clarice", "Marina"])
                        
                    }
                }.padding()
                
                Spacer()
                
                VStack(spacing: quarkSpacing) {
                    ButtonComponent(style: .secondary(isEnabled: true),
                                    text: "Começar desafio!") {
                        print("Começar desafio!")
                    }
                    ButtonComponent(style: .black(isEnabled: true),
                                    text: "Editar desafio") {
                        print("Editar desafio")
                    }
                }.padding(.bottom, largeSpacing)
            }
            .padding()
        }.ignoresSafeArea()
    }
}

struct ChallengeDetailsScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeDetailsScreenView()
    }
}
