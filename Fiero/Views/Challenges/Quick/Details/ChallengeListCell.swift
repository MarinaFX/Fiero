//
//  ChallengeListCell.swift
//  Fiero
//
//  Created by Marcelo Diefenbach on 14/09/22.
//

import SwiftUI

struct ChallengeListCell: View {
    
    @Binding var quickChallenge: QuickChallenge
    
    var body: some View {
        HStack {
            if quickChallenge.type == QCType.amount.description{
                LottieView(fileName: "quantity-list-cell", reverse: false, loop: true)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 30)
                    .padding(.horizontal, Tokens.Spacing.nano.value)
            }
            VStack (spacing: Tokens.Spacing.nano.value) {
                HStack {
                    Text(quickChallenge.name)
                        .font(Tokens.FontStyle.title.font(weigth: .bold))
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                    Spacer()
                }
                HStack {
                    if quickChallenge.finished == false {
                    Text("Em andamento")
                        .font(Tokens.FontStyle.caption.font(weigth: .regular))
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                        .padding(.vertical, Tokens.Spacing.quarck.value)
                        .padding(.horizontal, Tokens.Spacing.nano.value)
                        .background(Tokens.Colors.Highlight.four.value)
                        .cornerRadius(Tokens.Border.BorderRadius.circular.value)
                        .padding(.bottom, 3)
                    } else {
                        Text("Finalizado")
                            .font(Tokens.FontStyle.caption.font(weigth: .regular))
                            .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                            .padding(.vertical, Tokens.Spacing.quarck.value)
                            .padding(.horizontal, Tokens.Spacing.nano.value)
                            .background(Tokens.Colors.Neutral.High.pure.value.opacity(0.2))
                            .cornerRadius(Tokens.Border.BorderRadius.circular.value)
                            .padding(.bottom, 3)
                    }
                    Spacer()
                }
            }
        }
        .frame(maxWidth: UIScreen.main.bounds.width)
        .padding(.all, Tokens.Spacing.xxxs.value)
        .background(Tokens.Colors.Neutral.Low.dark.value)
        .cornerRadius(Tokens.Border.BorderRadius.small.value)
    }
}

struct ChallengeListCell_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeListCell(quickChallenge: .constant(QuickChallenge(id: "", name: "", invitationCode: "", type: "", goal: 0, goalMeasure: "", finished: false, ownerId: "", online: false, alreadyBegin: false, maxTeams: 0, createdAt: "", updatedAt: "", teams: [], owner: User(email: "", name: ""))))
    }
}
