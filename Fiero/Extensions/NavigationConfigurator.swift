//
//  NavigationConfigurator.swift
//  Fiero
//
//  Created by Marina De Pazzi on 10/07/22.
//

import Foundation
import SwiftUI

struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }
}
