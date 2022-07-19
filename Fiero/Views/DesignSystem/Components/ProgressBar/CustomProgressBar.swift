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
    
    @State var currentProgress: CGFloat = 0.0
    @State var currentPage: CurrentPage = .zero
    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.yellow)
                    .frame(width: 300, height: 10)
                
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.blue)
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
