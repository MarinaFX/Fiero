//
//  UIDeviceOrientation+Extensions.swift
//  Fiero
//
//  Created by Marina De Pazzi on 15/11/22.
//

import Foundation
import UIKit
import AVFoundation

// MARK: UIDeviceOrientation and AVCaptureVideoOrientation Equivalent
extension UIDeviceOrientation {
    var forVideoOrientation: AVCaptureVideoOrientation {
        switch self {
        case .landscapeLeft:
            return .landscapeRight
        case .landscapeRight:
            return .landscapeLeft
        case .faceUp, .portrait:
            return .portrait
        case .faceDown, .portraitUpsideDown:
            return .portraitUpsideDown
        case .unknown:
            return .portrait
        @unknown default:
            return .portrait
        }
    }
}
