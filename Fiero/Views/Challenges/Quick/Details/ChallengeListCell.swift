//
//  ChallengeListCell.swift
//  Fiero
//
//  Created by Marcelo Diefenbach on 14/09/22.
//

import SwiftUI

struct ChallengeListCell: View {
    @Environment(\.sizeCategory) var sizeCategory
    @Binding var quickChallenge: QuickChallenge
    
    @State private var ended: Bool = false
    
    
    var body: some View {
        HStack {
            if quickChallenge.type == QCTypeEnum.amount.description{
                LottieView(fileName: "quantity-list-cell", reverse: false, loop: true, ended: $ended)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 30, height: 70)
                    .padding(.leading, Tokens.Spacing.nano.value)
                    .padding(.trailing, Tokens.Spacing.xxxs.value)
            }
            else {
                if quickChallenge.type == QCTypeEnum.volleyball.description{
                    LottieView(fileName: "steps", reverse: false, loop: true, ended: $ended)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 30, height: 70)
                        .padding(.leading, Tokens.Spacing.nano.value)
                        .padding(.trailing, Tokens.Spacing.xxxs.value)
                }
            }
            VStack (spacing: Tokens.Spacing.nano.value) {
                HStack {
                    Text(quickChallenge.name)
                        .font(Tokens.FontStyle.title.font(weigth: .bold))
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer()
                }
                HStack {
                    if quickChallenge.finished {
                        Text("challengeFinishedStatus")
                            .font(Tokens.FontStyle.caption.font(weigth: .bold))
                            .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                            .padding(.vertical, self.sizeCategory.isAccessibilityCategory ? Tokens.Spacing.xxxs.value : Tokens.Spacing.quarck.value)
                            .padding(.horizontal, self.sizeCategory.isAccessibilityCategory ? Tokens.Spacing.xxxs.value : Tokens.Spacing.quarck.value)
                            .background(Tokens.Colors.Neutral.High.pure.value.opacity(0.2))
                            .cornerRadius(Tokens.Border.BorderRadius.circular.value)
                            .padding(.bottom, 3)
                    }
                    if quickChallenge.online {
                        Text("Online")
                            .font(Tokens.FontStyle.caption.font(weigth: .bold))
                            .foregroundColor(Tokens.Colors.Neutral.High.dark.value)
                            .padding(.vertical, self.sizeCategory.isAccessibilityCategory ? Tokens.Spacing.xxxs.value : Tokens.Spacing.quarck.value)
                            .padding(.horizontal, self.sizeCategory.isAccessibilityCategory ? Tokens.Spacing.xxxs.value : Tokens.Spacing.quarck.value)
                            .background(Tokens.Colors.Highlight.four.value)
                            .cornerRadius(Tokens.Border.BorderRadius.circular.value)
                            .padding(.bottom, 3)
                    }
                    if quickChallenge.type == QCTypeEnum.volleyball.description {
                        Text("HealthKit")
                            .font(Tokens.FontStyle.caption.font(weigth: .bold))
                            .foregroundColor(Tokens.Colors.Neutral.High.dark.value)
                            .padding(.vertical, self.sizeCategory.isAccessibilityCategory ? Tokens.Spacing.xxxs.value : Tokens.Spacing.quarck.value)
                            .padding(.horizontal, self.sizeCategory.isAccessibilityCategory ? Tokens.Spacing.xxxs.value : Tokens.Spacing.quarck.value)
                            .background(Tokens.Colors.Highlight.seven.value)
                            .cornerRadius(Tokens.Border.BorderRadius.circular.value)
                            .padding(.bottom, 3)
                    }
                    
                    if quickChallenge.owner.name == UserViewModel.getUserNameFromDefaults() {
                        Text("challengeAdm")
                            .font(Tokens.FontStyle.caption.font(weigth: .bold))
                            .foregroundColor(Tokens.Colors.Neutral.High.dark.value)
                            .padding(.vertical, self.sizeCategory.isAccessibilityCategory ? Tokens.Spacing.xxxs.value : Tokens.Spacing.quarck.value)
                            .padding(.horizontal, self.sizeCategory.isAccessibilityCategory ? Tokens.Spacing.xxxs.value : Tokens.Spacing.quarck.value)
                            .background(Tokens.Colors.Highlight.five.value)
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
