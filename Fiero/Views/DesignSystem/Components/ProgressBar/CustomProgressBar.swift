//
//  CustomProgressBar.swift
//  Fiero
//
//  Created by Marina De Pazzi on 19/07/22.
//

import SwiftUI

struct CustomProgressBar: View {
    enum CurrentPage {
        case zero
        case first
        case second
        case third
    }
    
    @State private var currentProgress: CGFloat = 0.0
    @State var currentPage: CurrentPage = .zero
    
    var primaryColor: Color = Color(red: 0.345, green: 0.322, blue: 0.855, opacity: 1)
    var secondaryColor: Color = Color(red: 1, green: 0.722, blue: 0, opacity: 1)
    
    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Tokens.Colors.Neutral.Low.dark.value)
                    .frame(width: 300, height: 10)
                
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(primaryColor)
                    .frame(width: 300*currentProgress, height: 10)
            }
        }
        .onAppear {
            withAnimation {
                switch currentPage {
                    case .zero:
                        self.currentProgress = 0.0
                    case .first:
                        self.currentProgress = 0.25
                    case .second:
                        self.currentProgress = 0.5
                    case .third:
                        self.currentProgress = 0.75
                }
            }
        }
    }
}

struct CustomProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomProgressBar()
    }
}
