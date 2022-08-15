//
//  Member.swift
//  Fiero
//
//  Created by Marina De Pazzi on 08/08/22.
//

import Foundation
import SwiftUI

struct Member: Decodable, Encodable, Equatable {
    
    var id: String
    var score: Double
    var userId: String?
    var teamId: String
    var beginDate: String?
    var botPicture: String?
    var createdAt: String
    var updatedAt: String
    
    static func getColor(playerName: String) -> Color {
        switch(playerName) {
            case "player2":
                return Color("ParticipantColor2")
            case "player3":
                return Color("ParticipantColor3")
            case "player4":
                return Color("ParticipantColor4")
            default:
                return Color("ParticipantColor1")
        }
    }
    
    static func getImage(playerName: String) -> String {
        switch playerName {
            case "player2":
                return "🦊"
            case "player3":
                return "🐼"
            case "player4":
                return "🦁"
            default:
                return "🐹"
        }
    }
}
