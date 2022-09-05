//
//  QCCategorySelectionView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 18/07/22.
//

import SwiftUI

struct QCCategorySelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var scrollOffset: CGFloat = 0.0
    @State var presentNextScreen: Bool = false
    
    var cardSpacing: CGFloat = Tokens.Spacing.nano.value
    var widthUnfocussedCard: CGFloat = UIScreen.main.bounds.width * 0.6
    var widthFocussedCard: CGFloat = UIScreen.main.bounds.width * 0.8
    var heightUnfocussedCard: CGFloat = UIScreen.main.bounds.height * 0.5
    var heightFocussedCard: CGFloat = UIScreen.main.bounds.height * 0.6
    var items: [ChallengeCategoryCardView] = [ChallengeCategoryCardView(title: "Desafio de\nquantidade",
                                                                        subtitle: "Vence quem fizer atingir\na pontuação primeiro.",
                                                                        isAvailable: true),
                                              ChallengeCategoryCardView(title: "Desafio de\ntempo",
                                                                        subtitle: "Vence quem fizer\na maior pontuação\nno tempo definido.",
                                                                        isAvailable: false),
                                              ChallengeCategoryCardView(title: "Desafio de\nrounds",
                                                                        subtitle: "Competição de 3\nou 5 rounds.",
                                                                        isAvailable: false)]
    
    var body: some View {
        let widthHStack: CGFloat = widthFocussedCard + ((widthUnfocussedCard + cardSpacing) * CGFloat((items.count - 1)))
        
        NavigationView{
            VStack {
                Text("Escolha um\ntipo de desafio")
                .multilineTextAlignment(.center)
                .font(Tokens.FontStyle.largeTitle.font(weigth: .bold, design: .default))
                .padding(.horizontal, Tokens.Spacing.xs.value)
                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)

                HStack(alignment: .center,spacing: cardSpacing) {
                    ForEach(0 ..< items.count) { index in
                        if index == 0 {
                            items[index]
                                .frame(width: isFocused(index: index) ? widthFocussedCard : widthUnfocussedCard,
                                       height: isFocused(index: index) ? heightFocussedCard : heightUnfocussedCard)
                                .opacity(isFocused(index: index) ? 1.0 : 0.4)
                                .onTapGesture {
                                    presentNextScreen.toggle()
                                }
                            
                            NavigationLink("", isActive: self.$presentNextScreen) {
                                QCNamingView(primaryColor: Tokens.Colors.Highlight.five.value, secondaryColor: Tokens.Colors.Highlight.two.value, challengeType: .amount)
                            }
                            .hidden()
                        }
                        else {
                            items[index]
                                .frame(width: isFocused(index: index) ? widthFocussedCard : widthUnfocussedCard,
                                       height: isFocused(index: index) ? heightFocussedCard : heightUnfocussedCard)
                                .opacity(isFocused(index: index) ? 1.0 : 0.4)
                        }
                    }
                }
                .frame(width: CGFloat(widthHStack), height: CGFloat(heightFocussedCard + 50), alignment: .center)
                .modifier(ScrollingHStackModifier(items: items.count, itemWidth: widthUnfocussedCard, itemSpacing: cardSpacing, scrollOffset: $scrollOffset))
                
                
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                    Haptics.shared.play(.light)
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
