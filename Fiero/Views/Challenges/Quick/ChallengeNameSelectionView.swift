//
//  ChallengeNameSelectionView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 19/07/22.
//

import SwiftUI

struct ChallengeNameSelectionView: View {
    @State var challengeName: String = ""
    
    var body: some View {
        VStack {
            CustomProgressBar(currentPage: .first)
                .padding()
            
            Text("Nomeie seu \ndesafio")
                .multilineTextAlignment(.center)
                .font(Tokens.FontStyle.title.font(weigth: .bold, design: .rounded))
                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                .padding(.top)
            
            Text("de quantidade")
                .font(Tokens.FontStyle.callout.font())
                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
            
            PermanentKeyboard(text: self.$challengeName, keyboardType: .default)
                .frame(height: UIScreen.main.bounds.height * 0.5)
        }
        .makeDarkModeFullScreen()
    }
}

struct QuickChallengeNamingView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeNameSelectionView()
    }
}
