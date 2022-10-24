//
//  ParticipantsList.swift
//  Fiero
//
//  Created by João Gabriel Biazus de Quevedo on 24/10/22.
//

import SwiftUI

struct ParticipantsList: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var array = ["Teste", "Teste","Teste","Teste","Teste","Teste"]
    
    var body: some View {
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
        .listStyle(.plain)
        .preferredColorScheme(.dark)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
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
}

struct ParticipantsList_Previews: PreviewProvider {
    static var previews: some View {
        ParticipantsList()
    }
}
