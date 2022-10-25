//
//  CreationSmallCardView.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 19/10/22.
//

import SwiftUI

struct CreationSmallCardView: View {
    @State var styles: CreationSmallCardStyles
    @State var amount: String?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: styles.cornerRadius)
                .foregroundColor(styles.backgroundColor)
            if styles == .amount {
                Text(amount ?? "0")
                    .font(.system(size: styles.numberFont))
                    .foregroundColor(styles.foregroundColor)
            }
            else {
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
}

struct CreationSmallCardView_Previews: PreviewProvider {
    static var previews: some View {
        CreationSmallCardView(styles: .amount)
    }
}
