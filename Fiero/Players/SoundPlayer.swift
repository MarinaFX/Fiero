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
    
    public static var isActionSoundsActiveBinding: Binding<Bool> = .init {
        print("getting")
        return (UserDefaults.standard.value(forKey: SoundTypes.action.description) as? Bool) ?? true
    } set: { newValue in
        print("setting: \(newValue)")
        UserDefaults.standard.set(newValue, forKey: SoundTypes.action.description)
    }
    
    private static var player: AVAudioPlayer?
    
    public static func playSound(soundName: Sounds, soundExtension: SoundExtensions, soundType: SoundTypes) {
        if ((UserDefaults.standard.value(forKey: SoundTypes.action.description) as? Bool) ?? true) {
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
