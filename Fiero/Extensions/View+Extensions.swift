//
//  View+Extensions.swift
//  Fiero
//
//  Created by Marina De Pazzi on 05/07/22.
//

import Foundation
import SwiftUI

//MARK: - View Extentions
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
    
    func makeDarkModeFullScreen(color: Color = Tokens.Colors.Background.dark.value) -> some View {
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
            .background(color)
            .ignoresSafeArea()
    }
}

//MARK: - ViewController Wrapper Extensions 
struct RootPresentationModeKey: EnvironmentKey {
    static let defaultValue: Binding<RootPresentationMode> = .constant(RootPresentationMode())
}

extension EnvironmentValues {
    var rootPresentationMode: Binding<RootPresentationMode> {
        get { return self[RootPresentationModeKey.self] }
        set { self[RootPresentationModeKey.self] = newValue }
    }
}

typealias RootPresentationMode = Bool

extension RootPresentationMode {
    public mutating func popToRootViewController() {
        self.toggle()
    }
}
