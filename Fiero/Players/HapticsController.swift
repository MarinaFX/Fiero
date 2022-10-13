//
//  HapticsController.swift
//  Fiero
//
//  Created by João Gabriel Biazus de Quevedo on 13/10/22.
//

import UIKit

class HapticsController {
    
    static let shared = HapticsController()
    private(set) var hapticStatus = UserDefaults.standard.bool(forKey: "HapticsFeedback")
    
    func activateHaptics(hapticsfeedback: HapticFeedbackCase) {
        if hapticStatus {
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
        hapticStatus = UserDefaults.standard.bool(forKey: "HapticsFeedback")
    }
}

enum HapticFeedbackCase {
    case light, heavy;
}
