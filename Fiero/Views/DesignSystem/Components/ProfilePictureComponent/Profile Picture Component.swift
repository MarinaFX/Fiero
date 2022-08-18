//
//  Profile Picture Component.swift
//  Fiero
//
//  Created by Marcelo Diefenbach on 18/08/22.
//

import SwiftUI

struct ProfilePictureComponent: View {
    
    @State var nameUser: String
    
    var body: some View {
        VStack (alignment: .center, spacing: Tokens.Spacing.xxxs.value) {
            Circle()
                .foregroundColor(Tokens.Colors.Highlight.six.value)
                .overlay(
                    Text(Member.getImage(playerName: nameUser))
                        .font(Font.system(size: 50))
                )
                .frame(width: 100, height: 100, alignment: .center)
            Text(nameUser)
                .font(Tokens.FontStyle.largeTitle.font(weigth: .bold))
                .multilineTextAlignment(.center)
                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
        }
    }
}

struct ProfilePictureComponent_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePictureComponent(nameUser: "Marselo da silva")
    }
}
