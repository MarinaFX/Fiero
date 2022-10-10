//
//  OnboardingCard.swift
//  Fiero
//
//  Created by Marcelo Diefenbach on 28/08/22.
//

import Foundation
import SwiftUI

struct OnboardingCard: View {
    @State var image: String
    @State var degrees: Double
    @State var title: String
    @State var description: String
  
    var body: some View {
        VStack(alignment: .center) {
            Image(NSLocalizedString(image, comment: ""))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.main.bounds.width * 0.47)
                .rotationEffect(.degrees(degrees))
                .padding(.top, Tokens.Spacing.quarck.value)
            
            VStack(alignment: .center, spacing: Tokens.Spacing.nano.value) {
                Text(NSLocalizedString(title, comment: ""))
                    .font(Tokens.FontStyle.title.font(weigth: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                
                Text(NSLocalizedString(description, comment: ""))
                    .font(Tokens.FontStyle.subheadline.font())
                    .multilineTextAlignment(.center)
                    .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
            }
            .padding(.all, Tokens.Spacing.xs.value)
        }
    }
}

struct OnboardingCard_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Tokens.Colors.Background.dark.value
                .edgesIgnoringSafeArea(.all)
            
            OnboardingCard(image: "firstImage", degrees: 3.18, title: "firstTitle", description: "firstDescription")
        }
    }
}

