//
//  EmptyChallengesView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 22/07/22.
//

import SwiftUI

struct EmptyChallengesView: View {
    @Environment(\.sizeCategory) var sizeCategory
    @ObservedObject var target = RefreshControlTarget()

    @State private var isShowingEnterWithCodeView: Bool = false
    @State private var ended: Bool = false
    @State var isPresented: Bool = false

    var body: some View {
        if self.sizeCategory.isAccessibilityCategory {
            ScrollView(showsIndicators: false) {
                VStack {
                    Spacer()
                    Spacer()
                    
                    LottieView(fileName: "sad", reverse: false, loop: true, ended: $ended).frame(width: 300 , height: 150)
                    
                    Text("Tá tão vazio por aqui,\nbora vencer uns desafios?")
                        .multilineTextAlignment(.center)
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                        .font(Tokens.FontStyle.title.font(weigth: .bold, design: .default))
                    Spacer()
                    VStack  {
                        ButtonComponent(style: .primary(isEnabled: true), text: "Criar um desafio!", action: {
                            self.isPresented.toggle()
                        })
                        
                        .padding(.horizontal, Tokens.Spacing.defaultMargin.value)
                        
                        ButtonComponent(style: .black(isEnabled: true), text: "Entrar por código") {
                            self.isShowingEnterWithCodeView = true
                        }
                        .sheet(isPresented: self.$isShowingEnterWithCodeView, content: {
                            EnterWithCodeView()
                        })
                    }
                    Spacer()
                    
                }
                .navigationTitle("Meus desafios")
                .environment(\.colorScheme, .dark)
                .makeDarkModeFullScreen()
                .fullScreenCover(isPresented: $isPresented) {
                    QCCategorySelectionView(didComeFromEmptyOrHomeView: true)
                }
            }
        }
        else {
            VStack {
                Spacer()
                Spacer()
                
                LottieView(fileName: "sad", reverse: false, loop: true, ended: $ended).frame(width: 300 , height: 150)
                
                Text("Tá tão vazio por aqui,\nbora vencer uns desafios?")
                    .multilineTextAlignment(.center)
                    .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                    .font(Tokens.FontStyle.title.font(weigth: .bold, design: .default))
                Spacer()
                VStack  {
                    ButtonComponent(style: .primary(isEnabled: true), text: "Criar um desafio!", action: {
                        self.isPresented.toggle()
                    })
                    
                    .padding(.horizontal, Tokens.Spacing.defaultMargin.value)
                    
                    ButtonComponent(style: .black(isEnabled: true), text: "Entrar por código") {
                        self.isShowingEnterWithCodeView = true
                    }
                    .sheet(isPresented: self.$isShowingEnterWithCodeView, content: {
                        EnterWithCodeView()
                    })
                }
                Spacer()
                
            }
            .navigationTitle("Meus desafios")
            .environment(\.colorScheme, .dark)
            .makeDarkModeFullScreen()
            .fullScreenCover(isPresented: $isPresented) {
                QCCategorySelectionView(didComeFromEmptyOrHomeView: true)
            }
        }
    }
}

struct EmptyChallenges_Previews: PreviewProvider {
    static var previews: some View {
        EmptyChallengesView()
    }
}

class RefreshControlTarget: ObservableObject {
    
    private var onValueChanged: ((_ refreshControl: UIRefreshControl) -> Void)?
    
    func use(for scrollView: UIScrollView, onValueChanged: @escaping ((UIRefreshControl) -> Void)) {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(
               self,
               action: #selector(self.onValueChangedAction),
               for: .valueChanged
           )
        scrollView.refreshControl = refreshControl
        self.onValueChanged = onValueChanged
    }
    
    @objc private func onValueChangedAction(sender: UIRefreshControl) {
        self.onValueChanged?(sender)
    }
}
