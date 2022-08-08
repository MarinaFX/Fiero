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
                NavigationLink("", isActive: self.$isPresented) {
                    AvailableSoonView()
                }
                .hidden()
                
                Spacer()
                
                Image("EmptyState")
                
                Text("Você não é ruim \nnem bom, você \nsó não tem oponentes ainda")
                    .multilineTextAlignment(.center)
                    .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                    .font(Tokens.FontStyle.title.font(weigth: .bold, design: .default))
                    .padding(Tokens.Spacing.xxs.value)
                
                
                ButtonComponent(style: .primary(isEnabled: true), text: "Criar um desafio!", action: {
                    self.isPresented.toggle()
                })
                .padding()
                
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
