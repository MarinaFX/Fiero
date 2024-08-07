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
    @Environment(\.sizeCategory) var sizeCategory
    @Environment(\.dismiss) var dismissView
    
    @State private var scrollOffset: CGFloat = 0.0
    @State var amountPresentNextScreen: Bool = false
    @State var walkingPresentNextScreen: Bool = false
    @State var isShowingEnterWithCodeView = false
    
    var didComeFromEmptyOrHomeView: Bool = false
    var isOnline: Bool = true
    
    var cardSpacing: CGFloat = Tokens.Spacing.nano.value
    var widthUnfocussedCard: CGFloat = UIScreen.main.bounds.width * 0.6
    var widthFocussedCard: CGFloat = UIScreen.main.bounds.width * 0.8
    var widthFocussedCardAccessibility: CGFloat = UIScreen.main.bounds.width * 0.8
    var heightUnfocussedCard: CGFloat = UIScreen.main.bounds.height * 0.5
    var heightFocussedCard: CGFloat = UIScreen.main.bounds.height * 0.6
    var heightFocussedCardAccessibility: CGFloat = UIScreen.main.bounds.height * 0.95
    var items: [ChallengesCategoryInfo] = [ChallengesCategoryInfo(style: .amount,
                                                                  title: "amountChallengeTypeTitle",
                                                                  subtitle: "amountChallengeTypeSubtitle"),
                                           ChallengesCategoryInfo(style: .walking,
                                                                  title: "walkingChallengeTypeTitle",
                                                                  subtitle: "walkingChallengeTypeSubtitle"),
                                           ChallengesCategoryInfo(style: .blocked,
                                                                  title: "bestOfChallengeTitle",
                                                                  subtitle: "bestOfChallengeSubtitle")]
    
    var body: some View {
        let widthHStack: CGFloat = widthFocussedCard + ((widthUnfocussedCard + cardSpacing) * CGFloat((items.count - 1)))
        
        NavigationView{
                VStack {
                    HStack(alignment: .center,spacing: cardSpacing) {
                        ForEach(0 ..< items.count, id: \.self) { index in
                            ChallengeCategoryCardView(style: items[index].style, isPlaying: .constant(isFocused(index: index)), title: items[index].title, subtitle: items[index].subtitle)
                                .frame(width: isFocused(index: index) ? widthFocussedCard : widthUnfocussedCard,
                                       height: isFocused(index: index) ? heightFocussedCard : heightUnfocussedCard)
                                .opacity(isFocused(index: index) ? 1.0 : 0.4)
                                .onTapGesture {
                                    if index != 2 {
                                        SoundPlayer.playSound(soundName: Sounds.metal, soundExtension: Sounds.metal.soundExtension, soundType: SoundTypes.action)
                                        index == 0 ? amountPresentNextScreen.toggle() : walkingPresentNextScreen.toggle()
                                    }
                                }
                                .fullScreenCover(isPresented: $amountPresentNextScreen) {
                                    OnlineOrOfflineView(primaryColor: Tokens.Colors.Highlight.five.value, secondaryColor: Tokens.Colors.Highlight.two.value, challengeType: .amount)
                                }
                                .fullScreenCover(isPresented: $walkingPresentNextScreen) {
                                    NavigationView {
                                        QCNamingView(isOnline: isOnline, primaryColor: Tokens.Colors.Highlight.five.value, secondaryColor: Tokens.Colors.Highlight.two.value, challengeType: .volleyball)
                                    }
                                }
                        }
                    }
                    .frame(width: CGFloat(widthHStack), height: CGFloat(heightFocussedCard + 50), alignment: .center)
                    .padding(.top, Tokens.Spacing.xxl.value)
                    .modifier(ScrollingHStackModifier(items: items.count, itemWidth: widthUnfocussedCard, itemSpacing: cardSpacing, scrollOffset: $scrollOffset))
                    
                    ButtonComponent(style: .black(isEnabled: true), text: "Entrar por código") {
                        isShowingEnterWithCodeView = true
                    }
                    .sheet(isPresented: self.$isShowingEnterWithCodeView, content: {
                        EnterWithCodeView()
                    })
                    .frame(height: 10)
                    .padding(.top, 0)
                    
                    if didComeFromEmptyOrHomeView {
                        ButtonComponent(style: .black(isEnabled: true), text: "Voltar") {
                            RootViewController.dismissSheetFlow()
                        }
                    }
                }
                .makeDarkModeFullScreen()
                .navigationTitle(LocalizedStringKey("homeScreenTitle"))
            
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
