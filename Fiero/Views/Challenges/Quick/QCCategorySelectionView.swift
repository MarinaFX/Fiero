//
//  QCCategorySelectionView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 18/07/22.
//

import SwiftUI

struct ChallengesCategoryInfo {
    let style: CardCategoryStyles
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey
}

struct QCCategorySelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var scrollOffset: CGFloat = 0.0
    @State var presentNextScreen: Bool = false
    
    var cardSpacing: CGFloat = Tokens.Spacing.nano.value
    var widthUnfocussedCard: CGFloat = UIScreen.main.bounds.width * 0.6
    var widthFocussedCard: CGFloat = UIScreen.main.bounds.width * 0.8
    var heightUnfocussedCard: CGFloat = UIScreen.main.bounds.height * 0.5
    var heightFocussedCard: CGFloat = UIScreen.main.bounds.height * 0.6
    var items: [ChallengesCategoryInfo] = [ChallengesCategoryInfo(style: .amount,
                                                                  title: "amountChallengeTypeTitle",
                                                                  subtitle: "amountChallengeTypeSubtitle"),
                                              ChallengesCategoryInfo(style: .blocked,
                                                                     title: "timeChallengeTypeTitle",
                                                                     subtitle: "timeChallengeTypeSubtitle"),
                                              ChallengesCategoryInfo(style: .blocked,
                                                                     title: "bestOfChallengeTitle",
                                                                     subtitle: "bestOfChallengeSubtitle")]
    
    var body: some View {
        let widthHStack: CGFloat = widthFocussedCard + ((widthUnfocussedCard + cardSpacing) * CGFloat((items.count - 1)))
        
        NavigationView{
            VStack {
                
                Spacer()
                
                Text("pickChallengeType")
                    .multilineTextAlignment(.center)
                    .font(Tokens.FontStyle.largeTitle.font(weigth: .bold, design: .default))
                    .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                    .frame(minHeight: 82)

                HStack(alignment: .center,spacing: cardSpacing) {
                    ForEach(0 ..< items.count) { index in
                        
                        ChallengeCategoryCardView(style: items[index].style, isPlaying: .constant(isFocused(index: index)), title: items[index].title, subtitle: items[index].subtitle)
                            .frame(width: isFocused(index: index) ? widthFocussedCard : widthUnfocussedCard,
                                   height: isFocused(index: index) ? heightFocussedCard : heightUnfocussedCard)
                            .opacity(isFocused(index: index) ? 1.0 : 0.4)
                            .onTapGesture {
                                SoundPlayer.playSound(soundName: Sounds.metal, soundExtension: Sounds.metal.soundExtension, soundType: SoundTypes.action)
                                if index == 0 {
                                    presentNextScreen.toggle()
                                }
                            }
                        
                        NavigationLink("", isActive: self.$presentNextScreen) {
                            OnlineOrOfflineView(primaryColor: Tokens.Colors.Highlight.five.value, secondaryColor: Tokens.Colors.Highlight.two.value, challengeType: .amount)
                        }
                        .hidden()
                    }
                }
                .frame(width: CGFloat(widthHStack), height: CGFloat(heightFocussedCard + 50), alignment: .center)
                .modifier(ScrollingHStackModifier(items: items.count, itemWidth: widthUnfocussedCard, itemSpacing: cardSpacing, scrollOffset: $scrollOffset))
                
                
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                    HapticsController.shared.activateHaptics(hapticsfeedback: .light)
                }, label: {
                    Text("Voltar")
                        .bold()
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                })
                .padding(.bottom, Tokens.Spacing.xxxs.value)
            }
            .makeDarkModeFullScreen()
            .navigationBarHidden(true)

        }
    }
    
    func isFocused(index: Int) -> Bool {
        if index == items.count/2 {
            return (scrollOffset >= -0.01 && scrollOffset <= 0)
        } else if index < items.count/2 {
            return scrollOffset > 100
        } else {
            return scrollOffset < -100
        }
    }
}

struct QuickChallengeCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        QCCategorySelectionView()
    }
}
