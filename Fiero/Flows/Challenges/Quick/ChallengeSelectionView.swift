//
//  ChallengeSelectionView.swift
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

struct ChallengeSelectionView: View {
    @Environment(\.dismiss) var dismissView
    
    @State private var scrollOffset: CGFloat = 0.0
    @State var amountPresentNextScreen: Bool = false
    @State var walkingPresentNextScreen: Bool = false
    @State var isShowingEnterWithCodeView = false
    
    var didComeFromEmptyOrHomeView: Bool = false
    var isOnline: Bool = true
    
    var items: [CarouselContentItem] = [CarouselContentItem(title: "amountChallengeTypeTitle", subtitle: "amountChallengeTypeSubtitle", challengeType: .amount),
                                        CarouselContentItem(title: "walkingChallengeTypeTitle", subtitle: "walkingChallengeTypeSubtitle", challengeType: .walking),
                                        CarouselContentItem(title: "bestOfChallengeTitle", subtitle: "bestOfChallengeSubtitle", challengeType: .round)]
    
    var body: some View {
        NavigationView{
            VStack {                
                CarouselView(items: self.items, amountPresentNextScreen: self.$amountPresentNextScreen, walkingPresentNextScreen: self.$walkingPresentNextScreen)
                    .fullScreenCover(isPresented: $amountPresentNextScreen) {
                        OnlineOrOfflineView(primaryColor: Tokens.Colors.Highlight.five.value, secondaryColor: Tokens.Colors.Highlight.two.value, challengeType: .amount)
                    }
                    .fullScreenCover(isPresented: $walkingPresentNextScreen) {
                        NavigationView {
                            QCNamingView(isOnline: isOnline, primaryColor: Tokens.Colors.Highlight.five.value, secondaryColor: Tokens.Colors.Highlight.two.value, challengeType: .volleyball)
                        }
                    }
                    
                ButtonComponent(style: .black(isEnabled: true), text: "Entrar por código") {
                    isShowingEnterWithCodeView = true
                }
                .sheet(isPresented: self.$isShowingEnterWithCodeView, content: {
                    EnterWithCodeView()
                })
                .frame(height: 10)
                .padding(.top, Tokens.Spacing.quarck.value)
                
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
}

struct QuickChallengeCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeSelectionView()
    }
}
