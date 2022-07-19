//
//  QuickChallengeNamingView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 19/07/22.
//

import SwiftUI

struct QuickChallengeNamingView: View {
    @State var challengeName: String = ""
    
    var body: some View {
        VStack {
            CustomProgressBar(currentPage: .first)
                //.padding()
            
            Text("Nomeie seu \ndesafio")
                .multilineTextAlignment(.center)
                .font(Tokens.FontStyle.title.font(weigth: .bold, design: .rounded))
                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
            
            Text("de quantidade")
                .font(Tokens.FontStyle.callout.font())
                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
            
            PermanentKeyboard(text: self.$challengeName, keyboardType: .default)
                .frame(height: UIScreen.main.bounds.height * 0.5)
        }
        .padding(.top, Tokens.Spacing.lg.value)
        .frame(
              minWidth: 0,
              maxWidth: .infinity,
              minHeight: 0,
              maxHeight: .infinity,
              alignment: .top
            )
        .background(Tokens.Colors.Background.dark.value)
        .ignoresSafeArea()
    }
}

struct QuickChallengeNamingView_Previews: PreviewProvider {
    static var previews: some View {
        QuickChallengeNamingView()
    }
}
