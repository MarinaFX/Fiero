//
//  ScoreList.swift
//  Fiero
//
//  Created by João Gabriel Biazus de Quevedo on 16/11/22.
//

import SwiftUI

struct ScoreList: View {
    @State private(set) var style: ScoreListStyle
    
    @State var position: Int
    @State var name: String
    @State var points: Int
    
    var body: some View {
        HStack(spacing: 20) {
            Text("\(position)")
                .font(style.numberFont)
            ZStack {
                HStack {
                    Text("\(name)")
                        .font(style.cellFont)
                        .foregroundColor(style.labelColor)
                        .padding(.leading, style.spacing)
                        
                    Spacer()
                    Text("\(points)")
                        .font(style.cellFont)
                        .foregroundColor(style.labelColor)
                        .padding(.trailing, style.spacing)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 48 , alignment: .leading)
            .background(style.backgroundColor)
            .cornerRadius(style.borderRadius)
        }
        .padding(.horizontal, 20)
    }
}

struct ScoreList_Previews: PreviewProvider {
    static var previews: some View {
        ScoreList(style: .player, position: 4, name: "Teste", points: 199)
    }
}
