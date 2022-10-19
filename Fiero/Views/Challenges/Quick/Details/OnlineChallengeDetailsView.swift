//
//  OnlineChallengeDetailsView.swift
//  Fiero
//
//  Created by João Gabriel Biazus de Quevedo on 18/10/22.
//

import SwiftUI

struct OnlineChallengeDetailsView: View {
    var body: some View {
        ZStack {
            backgroundColor
                .edgesIgnoringSafeArea(.all)
            VStack {
                Image("OnlineDetails")
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, smallSpacing)
                    .padding(.bottom, quarckSpacing)
                //MARK: - Info Component
                VStack {
                    VStack(alignment: .center, spacing: extraExtraSmallSpacing) {
                        VStack(alignment: .center, spacing: nanoSpacing) {
                            Text("Desafio de quantidade")
                                .font(descriptionFont)
                                .foregroundColor(foregroundColor)
                                .padding(.top, extraSmallSpacing)
                            
                            Text("Virar cachaça")
                                .font(largeTitleFont)
                                .multilineTextAlignment(.center)
                                .foregroundColor(foregroundColor)
                                .padding(.horizontal, nanoSpacing)
                        }
                        
                        VStack(alignment: .center, spacing: nanoSpacing) {
                            Text("Objetivo")
                                .font(descriptionFont)
                                .foregroundColor(foregroundColor)
                            
                            Text("5 pontos")
                                .font(largeTitleFont)
                                .multilineTextAlignment(.center)
                                .foregroundColor(foregroundColor)
                                .padding(.horizontal, nanoSpacing)
                        }
                        VStack(alignment: .center, spacing: nanoSpacing) {
                            Text("Tipo")
                                .font(descriptionFont)
                                .foregroundColor(foregroundColor)
                            
                            Text("Online")
                                .font(largeTitleFont)
                                .multilineTextAlignment(.center)
                                .foregroundColor(foregroundColor)
                                .padding(.bottom, extraSmallSpacing)
                                .padding(.horizontal, nanoSpacing)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.9)
                    .overlay(
                        RoundedRectangle(cornerRadius: borderSmall)
                            .stroke(foregroundColor, lineWidth: 2)
                    )
                }
                
                //MARK: - Invite Participants
                HStack {
                    Button {
                        
                    } label: {
                        Text("Convidar Participante")
                            .font(descriptionFontBold)
                            .padding(.leading, 16)
                        Image(systemName: "square.and.arrow.up")
                            .font(descriptionFontBold)
                            .padding(.trailing, 16)
                    }
                }
                .foregroundColor(foregroundColor)
                .background(.clear)
                .padding(.horizontal, defaultMarginSpacing)
                .padding(.top, extraSmallSpacing)
                .padding(.bottom, extraExtraSmallSpacing)
                
                //MARK: - List of Participants
                HStack {
                    Button {
                        
                    } label: {
                        Text("Participantes")
                            .padding(.leading, 16)
                        Spacer()
                        Text("Ver todos")
                        Image(systemName: "chevron.right")
                            .padding(.trailing, 16)
                    }
                }
                .foregroundColor(foregroundColor)
                .frame(maxHeight: 44)
                .background(Tokens.Colors.Neutral.Low.dark.value)
                .cornerRadius(borderSmall)
                .padding(.horizontal, defaultMarginSpacing)

                
                ButtonComponent(style: .secondary(isEnabled: true), text: "Continuar desafio", action: { })
                    .padding(.horizontal, defaultMarginSpacing)
                    .padding(.vertical, extraExtraSmallSpacing)
            }
        }
}
    //MARK: Color
    var backgroundColor: Color {
        
        return Tokens.Colors.Background.dark.value
    }
    var foregroundColor: Color {
        return Tokens.Colors.Neutral.High.pure.value
    }
    var loadingBackgroundColor: Color {
        return Tokens.Colors.Neutral.Low.pure.value
    }
    
    //MARK: Spacing
    var quarckSpacing: CGFloat {
        return Tokens.Spacing.quarck.value
    }
    var nanoSpacing: CGFloat {
        return Tokens.Spacing.nano.value
    }
    var smallSpacing: CGFloat {
        return Tokens.Spacing.sm.value
    }
    var extraExtraSmallSpacing: CGFloat {
        return Tokens.Spacing.xxxs.value
    }
    var extraSmallSpacing: CGFloat {
        return Tokens.Spacing.xs.value
    }
    var defaultMarginSpacing: CGFloat {
        return Tokens.Spacing.defaultMargin.value
    }
    
    //MARK: Border
    var borderSmall: CGFloat {
        return Tokens.Border.BorderRadius.small.value
    }
    
    //MARK: Font
    var descriptionFont: Font {
        return Tokens.FontStyle.callout.font()
    }
    var descriptionFontBold: Font {
        return Tokens.FontStyle.callout.font(weigth: .bold)
    }
    var titleFont2: Font {
        return Tokens.FontStyle.title2.font(weigth: .bold)
    }
    var largeTitleFont: Font {
        return Tokens.FontStyle.largeTitle.font(weigth: .heavy)
    }
}

struct OnlineChallengeDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        OnlineChallengeDetailsView()
    }
}
