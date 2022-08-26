//
//  ElementsStyles.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 09/08/22.
//

import SwiftUI

enum ElementsStyles {
    case one
    case two
    case three
    case four
    
    var image: String {
        switch self {
        case .one:
            return "🐹"
        case .two:
            return "🦊"
        case .three:
            return "🐼"
        case .four:
            return "🦁"
        }
    }
    
    var color: String {
        switch self {
        case .one:
            return "ParticipantColor1"
        case .two:
            return "ParticipantColor2"
        case .three:
            return "ParticipantColor3"
        case .four:
            return "ParticipantColor4"
        }
    }
}
