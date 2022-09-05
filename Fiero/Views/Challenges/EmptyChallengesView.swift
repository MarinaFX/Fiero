//
//  EmptyChallengesView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 22/07/22.
//

import SwiftUI

struct EmptyChallengesView: View {
    @State var isPresented: Bool = false
    @ObservedObject var target = RefreshControlTarget()

    var body: some View {

        VStack {
            Spacer()
            
            LottieView(fileName: "tonto", reverse: false).frame(width: 250 , height: 320)
            
            Text("Você não é ruim,\nsó ainda não ganhou.")
                .multilineTextAlignment(.center)
                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                .font(Tokens.FontStyle.title.font(weigth: .bold, design: .default))
            
            ButtonComponent(style: .primary(isEnabled: true), text: "Criar um desafio!", action: {
                self.isPresented.toggle()
            })
            
            .padding()
            
            Spacer()
            
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button(action: {
                        self.isPresented.toggle()
                    }, label: {
                        Image(systemName: "plus")
                            .font(Tokens.FontStyle.body.font(weigth: .bold, design: .rounded))
                            .foregroundColor(.white)
                    })
                    .buttonStyle(.plain)
                })
            }
        }
        .navigationTitle("Meus desafios")
        .environment(\.colorScheme, .dark)
        .makeDarkModeFullScreen()
        .fullScreenCover(isPresented: $isPresented) {
            QCCategorySelectionView()
        }
    }
}

struct AvailableSoonView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Wow, calma la fela. Parece que você encontrou uma funcionalidade ainda em desenvolvimento. \nLogo logo você terá ela em suas mãos (ou desafios)")
                .multilineTextAlignment(.leading)
                .font(Tokens.FontStyle.title.font(weigth: .bold, design: .default))
                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                .padding()
            
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarTrailing, content: {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text("OK")
                                .font(Tokens.FontStyle.body.font(weigth: .bold, design: .default))
                                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                        })
                    })
                })
        }
        .makeDarkModeFullScreen()
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
