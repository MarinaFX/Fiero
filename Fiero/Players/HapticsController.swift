//
//  HapticsController.swift
//  Fiero
//
//  Created by João Gabriel Biazus de Quevedo on 13/10/22.
//

import UIKit
import SwiftUI

class HapticsController {
    
    static let shared = HapticsController()
    public static var isHapticsActiveBinding: Binding<Bool> = .init {
        return (UserDefaults.standard.value(forKey: "HapticsFeedback") as? Bool) ?? true
    } set: { newValue in
        UserDefaults.standard.set(newValue, forKey: "HapticsFeedback")
    }
    
    func activateHaptics(hapticsfeedback: HapticFeedbackCase) {
        if (UserDefaults.standard.value(forKey: "HapticsFeedback") as? Bool) ?? true {
            switch hapticsfeedback {
            case .light:
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
            case .heavy:
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()
            }
        }
    }
    
    func saveHapticsSettings(status: Bool) {
        UserDefaults.standard.setValue(status, forKey: "HapticsFeedback")
    }
}

enum HapticFeedbackCase {
    case light, heavy;
}
