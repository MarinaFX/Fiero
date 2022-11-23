//
//  ProfileBodyTextView.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 22/11/22.
//

import SwiftUI

struct ProfileBodyTextView: View {
    private let userName = UserViewModel.getUserNameFromDefaults()
    
    var body: some View {
        Text("\(NSLocalizedString("Fique ligado", comment: "")) \(userName.components(separatedBy: " ").first ?? "")")
            .multilineTextAlignment(.center)
            .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
            .font(Tokens.FontStyle.title.font(design: .rounded))
        Spacer()
        
        Text("Novas funcionalidades")
            .multilineTextAlignment(.center)
            .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
            .font(Tokens.FontStyle.title3.font())
            .padding(.horizontal ,Tokens.Spacing.defaultMargin.value)
    }
}

struct ProfileBodyTextView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileBodyTextView()
    }
}
