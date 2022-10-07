//
//  SoundPlayer.swift
//  Fiero
//
//  Created by Lucas Dimer Justo on 07/10/22.
//

import Foundation

class SoundPlayer {
    private static var isEnvironmentSoundsActive: Bool?
    private static let isEnvironmentSoundsActiveUserDefaultsKey: String = "isEnvironmentSoundsActive"
    
    private static var isActionSoundsActive: Bool?
    private static let isActionSoundsActiveUserDefaultsKey: String = "isActionSoundsActive"
    
    
    public static func environmentSoundsToggle(){
        if self.isEnvironmentSoundsActive != nil {
            self.isEnvironmentSoundsActive?.toggle()
            UserDefaults.standard.set(self.isEnvironmentSoundsActive, forKey: isEnvironmentSoundsActiveUserDefaultsKey)
        }
    }
    
    public static func actionSoundsToggle(){
        if self.isActionSoundsActive != nil {
            self.isActionSoundsActive?.toggle()
            UserDefaults.standard.set(self.isActionSoundsActive, forKey: isActionSoundsActiveUserDefaultsKey)
        }
    }
    
    public static func initVarsFromUserDefaults() {
        if let environment = UserDefaults.standard.value(forKey: isEnvironmentSoundsActiveUserDefaultsKey) as? Bool, let action = UserDefaults.standard.value(forKey: isActionSoundsActiveUserDefaultsKey) as? Bool {
            self.isEnvironmentSoundsActive = environment
            self.isActionSoundsActive = action
        }
        else {
            self.isEnvironmentSoundsActive = true
            UserDefaults.standard.set(self.isEnvironmentSoundsActive, forKey: isEnvironmentSoundsActiveUserDefaultsKey)
            
            self.isActionSoundsActive = true
            UserDefaults.standard.set(self.isActionSoundsActive, forKey: isActionSoundsActiveUserDefaultsKey)
        }
    }
}
