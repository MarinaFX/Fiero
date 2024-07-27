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
    
    func makeDarkModeFullScreen(color: Color = Color("background")) -> some View {
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

struct RootViewController {
    static func popToRootViewController() {
        let rootController = UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController
        rootController?.dismiss(animated: true)
        findNavigationController(viewController: rootController)?.popToRootViewController(animated: true)
    }
    
    static func dismissSheetFlow() {
        let rootController = UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController
        rootController?.dismiss(animated: true)
    }
    
    static func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
        if viewController is UINavigationController {
            return viewController as? UINavigationController
        }
        
        if let tabBarController = viewController as? UITabBarController {
            return findNavigationController(viewController: tabBarController.selectedViewController)
        }
        
        for childController in viewController?.children ?? [] {
            if let navController = findNavigationController(viewController: childController) {
                return navController
            }
        }
        
        return nil
    }
}
