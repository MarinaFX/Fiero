//
//  SoundPlayer.swift
//  Fiero
//
//  Created by Lucas Dimer Justo on 07/10/22.
//

import Foundation
import AVFoundation

class SoundPlayer {
    private static var isActionSoundsActive: Bool?
    
    private static var isEnvironmentSoundsActive: Bool?
    
    
    public static func actionSoundsToggle(){
        if self.isActionSoundsActive != nil {
            self.isActionSoundsActive?.toggle()
            UserDefaults.standard.set(self.isActionSoundsActive, forKey: SoundType.action.description)
        }
    }
    
    public static func environmentSoundsToggle(){
        if self.isEnvironmentSoundsActive != nil {
            self.isEnvironmentSoundsActive?.toggle()
            UserDefaults.standard.set(self.isEnvironmentSoundsActive, forKey: SoundType.environment.description)
        }
    }
    
    public static func initVarsFromUserDefaults() {
        if let action = UserDefaults.standard.value(forKey: SoundType.action.description) as? Bool, let environment = UserDefaults.standard.value(forKey: SoundType.environment.description) as? Bool {
            self.isActionSoundsActive = action
            self.isEnvironmentSoundsActive = environment
        }
        else {
            self.isActionSoundsActive = true
            UserDefaults.standard.set(self.isActionSoundsActive, forKey: SoundType.action.description)
        
            self.isEnvironmentSoundsActive = true
            UserDefaults.standard.set(self.isEnvironmentSoundsActive, forKey: SoundType.environment.description)
        }
    }
    
    public static func playSound(soundName: String, soundType: SoundType) {
        if let isActionSoundsActive = isActionSoundsActive, let isEnvironmentSoundsActive = isEnvironmentSoundsActive {
            if (soundType == .action && isActionSoundsActive) || (soundType == .environment && isEnvironmentSoundsActive) {
                if let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") {
                    do {
                        let player: AVAudioPlayer = try AVAudioPlayer(contentsOf: url)

                        player.prepareToPlay()
                        player.play()
                    } catch let error as NSError {
                        print(error.description)
                    }
                }
            }
        }
    }
}

enum SoundType {
    case action, environment
    
    var description: String {
        switch self {
            case .action:
                return "actionSound"
            case .environment:
                return "environmentSound"
        }
    }
}
