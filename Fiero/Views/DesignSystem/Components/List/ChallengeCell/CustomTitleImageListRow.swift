//
//  CustomTitleImageListRow.swift
//  Fiero
//
//  Created by Marina De Pazzi on 04/08/22.
//

import SwiftUI

struct CustomTitleImageListRow: View {
    @State var teste: String = ""
        
    var body: some View {
        HStack {
            Text(teste)
                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                .font(Tokens.FontStyle.title3.font(weigth: .bold, design: .default))
                .padding()
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                .font(Tokens.FontStyle.title3.font(weigth: .bold, design: .default))
                .padding()
        }
        .background(Tokens.Colors.Neutral.Low.dark.value)
        .cornerRadius(Tokens.Border.BorderRadius.small.value)
    }
}

struct CustomTitleListCell_Previews: PreviewProvider {
    static var previews: some View {
        CustomTitleImageListRow(teste: "Vôlei do Academy")
    }
}
