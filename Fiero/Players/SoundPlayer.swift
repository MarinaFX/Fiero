//
//  SoundPlayer.swift
//  Fiero
//
//  Created by Lucas Dimer Justo on 07/10/22.
//

import Foundation
import AVFoundation
import UIKit
import SwiftUI

class SoundPlayer {
    private static var isActionSoundsActive: Bool?
    
    public static var isActionSoundsActiveBinding: Binding<Bool> = .init {
        print("getting")
        return (UserDefaults.standard.value(forKey: SoundTypes.action.description) as! Bool)
    } set: { newValue in
        print("setting: \(newValue)")
        UserDefaults.standard.set(newValue, forKey: SoundTypes.action.description)
    }

    private static var isEnvironmentSoundsActive: Bool?
    
    private static var player: AVAudioPlayer?
    
    public static func actionSoundsToggle(){
//        if self.isActionSoundsActive != nil {
//            self.isActionSoundsActive?.toggle()
//            UserDefaults.standard.set(self.isActionSoundsActive, forKey: SoundTypes.action.description)
//        }
    }
    
    public static func environmentSoundsToggle(){
//        if self.isEnvironmentSoundsActive != nil {
//            self.isEnvironmentSoundsActive?.toggle()
//            UserDefaults.standard.set(self.isEnvironmentSoundsActive, forKey: SoundTypes.environment.description)
//        }
    }
    
    public static func storeBoolsAtUserDefaults(actionBool: Bool, environmentBool: Bool) {
        self.isActionSoundsActive = actionBool
        UserDefaults.standard.set(self.isActionSoundsActive, forKey: SoundTypes.action.description)
        
        self.isEnvironmentSoundsActive = environmentBool
        UserDefaults.standard.set(self.isEnvironmentSoundsActive, forKey: SoundTypes.environment.description)
    }
    
    public static func initVarsFromUserDefaults() {
        if let action = UserDefaults.standard.value(forKey: SoundTypes.action.description) as? Bool, let environment = UserDefaults.standard.value(forKey: SoundTypes.environment.description) as? Bool {
            self.isActionSoundsActive = action
            self.isEnvironmentSoundsActive = environment
        }
        else {
            self.isActionSoundsActive = true
            UserDefaults.standard.set(self.isActionSoundsActive, forKey: SoundTypes.action.description)
        
            self.isEnvironmentSoundsActive = true
            UserDefaults.standard.set(self.isEnvironmentSoundsActive, forKey: SoundTypes.environment.description)
        }
    }
    
    public static func playSound(soundName: Sounds, soundExtension: SoundExtensions, soundType: SoundTypes) {
        if let isActionSoundsActive = isActionSoundsActive, let isEnvironmentSoundsActive = isEnvironmentSoundsActive {
            if (soundType == .action && isActionSoundsActive) || (soundType == .environment && isEnvironmentSoundsActive) {
                if let asset = NSDataAsset(name: soundName.description) {
                    do {
                        self.player = try AVAudioPlayer(data: asset.data, fileTypeHint: soundExtension.description)

                        self.player?.prepareToPlay()
                        self.player?.play()
                    } catch let error as NSError {
                        print(error.description)
                    }
                }
            }
        }
    }
}

enum SoundTypes {
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

enum SoundExtensions {
    case mp3, mpeg, wav
    
    var description: String {
        switch self {
            case .mp3:
                return "mp3"
            case .mpeg:
                return "mpeg"
            case .wav:
                return "wav"
        }
    }
}

enum Sounds {
    case cavalo, negativePoint, positivePoint, metal
    
    var description: String {
        switch self {
            case .cavalo:
                return "cavalo"
            case .negativePoint:
                return "negativePoint"
            case .positivePoint:
                return "positivePoint"
            case .metal:
                return "metal"
        }
    }
    
    var soundExtension: SoundExtensions {
        switch self {
            case .cavalo:
                return .mp3
            case .negativePoint:
                return .wav
            case .positivePoint:
                return .wav
            case .metal:
                return .mp3
        }
    }
}
