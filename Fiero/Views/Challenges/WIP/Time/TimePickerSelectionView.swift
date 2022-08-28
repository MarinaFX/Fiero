//
//  TimePickerSelectionView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 20/07/22.
//

import SwiftUI

struct TimePickerSelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private(set) var valueSelection: Int = 0
    @State private(set) var measureSelection: String = ""
    @State private(set) var pushNextView: Bool = false
    
    private let seconds: [Int] = Array(0..<61)
    private let minutes: [Int] = Array(0..<61)
    
    private(set) var primaryColor: Color
    private(set) var secondaryColor: Color
    private(set) var challengeType: QCType
    private(set) var challengeName: String
    private(set) var challengeParticipants: Int
    
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
            
            Spacer()

            CustomPickerView(valueSelection: self.$valueSelection, measureSelection: self.$measureSelection,numberOfComponents: 2, seconds: self.seconds, minutes: self.minutes, goalMeasure: ["Segundos", "Minutos"])
                .datePickerStyle(.wheel)
                .environment(\.colorScheme, .dark)

            Spacer()
            
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Voltar")
                    .bold()
                    .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
            })
                        
            ButtonComponent(style: .secondary(isEnabled: true), text: "Começar!", action: {
                self.pushNextView.toggle()
            })
            .padding(.bottom)
            .padding(.horizontal, Tokens.Spacing.xxxs.value)
        }
        .makeDarkModeFullScreen()
        .navigationBarHidden(true)
    }
}

struct TimePickerSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        TimePickerSelectionView(primaryColor: .red, secondaryColor: .red, challengeType: .amount, challengeName: "", challengeParticipants: 2)
    }
}
