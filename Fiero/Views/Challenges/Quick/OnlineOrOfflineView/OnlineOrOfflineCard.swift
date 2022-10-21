//
//  OnlineOrOfflineCard.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 19/10/22.
//

import SwiftUI

struct OnlineOrOfflineCard: View {
    @State var styles: OnlineOrOfflineStyles
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: styles.cornerRadius)
                .foregroundColor(styles.backgroundColor)
            
            VStack(spacing: styles.spacingBetween) {
                Text(styles.title)
                    .font(styles.titleFont)
                    .foregroundColor(styles.foregroundColor)
                
                Text(styles.description)
                    .font(styles.descriptionFont)
                    .foregroundColor(styles.foregroundColor)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Tokens.Spacing.defaultMargin.value)
            }
        }
    }
}

struct OnlineOrOfflineCard_Previews: PreviewProvider {
    static var previews: some View {
        OnlineOrOfflineCard(styles: .online)
    }
}
