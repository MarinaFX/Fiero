//
//  ChallengeDetailsView.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 20/07/22.
//

import SwiftUI

struct ChallengeDetailsView: View {
    var challenge: QuickChallenge
    
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
                            Text(challenge.name)
                                .font(titleFont)
                                .foregroundColor(color)
                        }
                        .padding(.top, largeSpacing)
                        
                        Text("Quem fizer mais\nrepetições dentro de")
                            .multilineTextAlignment(.center)
                            .font(descriptionFont)
                            .foregroundColor(color)
                        Text("\(challenge.goal)")
                            .font(titleFont)
                            .foregroundColor(color)
                    }
                    
                    VStack(spacing: extraExtraExtraSmallSpacing) {
                        Text("Participantes")
                            .font(titleFont)
                            .foregroundColor(color)
                        
                        GroupComponent(scoreboard: false, style: [.participantDefault(isSmall: false), .participantLooser(isSmall: false)], element: [.one, .two], name: ["Clarice", "Marina"])
                        
                    }
                }
                .padding()
                
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
                }
                .padding(.bottom, largeSpacing)
            }
            .padding()
        }
        .accentColor(Color.white)
        .ignoresSafeArea()
    }
    
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
}

struct ChallengeDetailsScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeDetailsView(challenge: QuickChallenge(id: "", name: "", invitationCode: "", type: "", goal: 0, goalMeasure: "", finished: false, ownerId: "", online: false, alreadyBegin: false, maxTeams: 0, createdAt: "", updatedAt: "", teams: [], owner: User(email: "", name: "")))
    }
}
