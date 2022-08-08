//
//  EmptyChallengesView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 22/07/22.
//

import SwiftUI

struct EmptyChallengesView: View {
    @State var isPresented: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Text("Parece que você não possui nenhum desafio, que tal criar um? \nBasta apertar no + no canto superior direito da tela")
                    .multilineTextAlignment(.center)
                    .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                    .font(Tokens.FontStyle.title.font(weigth: .bold, design: .rounded))
                    .padding(Tokens.Spacing.xxs.value)
                
                Spacer()
                
                NavigationLink("", isActive: self.$isPresented) {
                    QCCategorySelectionView()
                }
                .hidden()
                
                    .toolbar(content: {
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
                    })
            }
            .navigationTitle("Desafios")
            .navigationViewStyle(.stack)
            .makeDarkModeFullScreen()
        }
        .environment(\.colorScheme, .dark)
        .environment(\.rootPresentationMode, self.$isPresented)
    }
}
//VStack(spacing: Tokens.Spacing.xs.value) {
//    VStack(spacing: Tokens.Spacing.xs.value) {
//        Image("EmptyBox")
//            .resizable()
//        Text("Você não é ruim\n nem bom, você\n só ainda não\n tem oponentes")
//            .multilineTextAlignment(.center)
//            .font(Tokens.FontStyle.title.font(weigth: .bold))
//            .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
//    }
//    .padding(.horizontal, Tokens.Spacing.xxxl.value)
//    NavigationLink(destination: EmptyChallengesView(), isActive: $showNextScreen) {
//        ButtonComponent(style: .primary(isEnabled: true),
//                        text: "Criar um desafio!") {
//            showNextScreen = true
//        }
//    }
//    .padding(.horizontal, Tokens.Spacing.defaultMargin.value)
//}
//.padding(.top, Tokens.Spacing.xxl.value)
//.padding(.bottom, Tokens.Spacing.xxl.value)

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
