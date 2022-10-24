//
//  ParticipantsList.swift
//  Fiero
//
//  Created by João Gabriel Biazus de Quevedo on 24/10/22.
//

import SwiftUI

struct ParticipantsList: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
//    var array = ["EU","Teste","Teste","Teste","Teste","Teste"]
    var array = ["EU"]
    @State private var ended: Bool = false
    
    var body: some View {
        if array.count > 1 {
            List {
                ForEach(array, id: \.self) { x in
                    Text("\(x)")
                        .foregroundColor(foregroundColor)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true, content: {
                    Button(role: .destructive, action: {
                    }, label: {
                        Label("Delete", systemImage: "trash")
                    })
                })
            }
            .preferredColorScheme(.dark)
            .listStyle(.plain)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton)
        } else {
            VStack {
                List {
                    ForEach(array, id: \.self) { x in
                        Text("\(x)")
                            .foregroundColor(foregroundColor)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true, content: {
                        Button(role: .destructive, action: {
                        }, label: {
                            Label("Delete", systemImage: "trash")
                        })
                    })
                }
                .disabled(true)
                .preferredColorScheme(.dark)
                .listStyle(.plain)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: backButton)
                .frame(height: 50)
                Spacer()
                LottieView(fileName: "sad", reverse: false, loop: true, ended: $ended).frame(width: 300 , height: 250)
                
                Text("Você parece estar sozinho aqui. Ficou com medo \nde desafiar seus amigos?")
                    .multilineTextAlignment(.center)
                    .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                    .font(Tokens.FontStyle.title.font(weigth: .bold, design: .default))
                    .padding(.horizontal, defaultMarginSpacing)
                Spacer()
                
                ButtonComponent(style: .secondary(isEnabled: true), text: "Convidar Participante", action: { })
                    .padding(.horizontal, defaultMarginSpacing)
                    .padding(.vertical, extraExtraSmallSpacing)
            }
            .preferredColorScheme(.dark)
        }
    }
    
    var backButton : some View { Button(action: {
            self.presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                    Text("Detalhes do desafio")
                }
            }
        }
    
    //MARK: Color
    var backgroundColor: Color {
        return Tokens.Colors.Background.dark.value
    }
    var foregroundColor: Color {
        return Tokens.Colors.Neutral.High.pure.value
    }
    
    //MARK: Spacing
    var defaultMarginSpacing: CGFloat {
        return Tokens.Spacing.defaultMargin.value
    }
    var extraExtraSmallSpacing: CGFloat {
        return Tokens.Spacing.xxxs.value
    }
}

struct ParticipantsList_Previews: PreviewProvider {
    static var previews: some View {
        ParticipantsList()
    }
}
