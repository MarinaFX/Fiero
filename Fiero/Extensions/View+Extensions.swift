//
//  View+Extensions.swift
//  Fiero
//
//  Created by Marina De Pazzi on 05/07/22.
//

import Foundation
import SwiftUI

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
    
    func makeDarkModeFullScreen() -> some View {
        return self
            .padding(.top, Tokens.Spacing.lg.value)
            .padding(.bottom, Tokens.Spacing.xxs.value)
            .frame(
                  minWidth: 0,
                  maxWidth: .infinity,
                  minHeight: 0,
                  maxHeight: .infinity,
                  alignment: .top
                )
            .background(Tokens.Colors.Background.dark.value)
            .ignoresSafeArea()
    }
}
