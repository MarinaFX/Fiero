//
//  TimePickerSelectionView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 20/07/22.
//

import SwiftUI

struct TimePickerSelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private(set) var hourSelection: Int
    @State private(set) var minuteSelection: Int
    @State private(set) var secondSelection: Int
    
    private(set) var primaryColor: Color = Color(red: 1, green: 0.349, blue: 0.408, opacity: 1)
    
    private(set) var secondaryColor: Color = Color(red: 0.251, green: 0.612, blue: 0.522, opacity: 1)
    
    var body: some View {
        VStack {
            CustomProgressBar(currentPage: .third, primaryColor: self.primaryColor, secondaryColor: self.secondaryColor)
                .padding()
            
            Text("Timer")
                .font(Tokens.FontStyle.largeTitle.font(weigth: .semibold, design: .rounded))
                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                .padding(.bottom, Tokens.Spacing.nano.value)
            
            Text("O desafio encerrará após o tempo determinado")
                .font(Tokens.FontStyle.callout.font(weigth: .regular, design: .default))
                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                .padding(.horizontal, Tokens.Spacing.xxxs.value)
            
            CustomMultiWheelPicker(hourSelection: self.$hourSelection, minuteSelection: self.$minuteSelection, secondSelection: self.$secondSelection)
            
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Voltar")
                    .bold()
                    .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
            })
                        
            ButtonComponent(style: .secondary(isEnabled: true), text: "Começar!", action: {
                
            })
            .padding(.bottom)
            .padding(.horizontal, Tokens.Spacing.xxxs.value)
        }
        .makeDarkModeFullScreen()
    }
}

struct TimePickerSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        TimePickerSelectionView(hourSelection: 0, minuteSelection: 0, secondSelection: 0)
    }
}
