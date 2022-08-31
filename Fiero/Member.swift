//
//  Member.swift
//  Fiero
//
//  Created by Marina De Pazzi on 08/08/22.
//

import Foundation
import SwiftUI

struct Member: Decodable, Encodable, Equatable, Identifiable {
    
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
                return Tokens.Colors.Highlight.one.value
            case "player3":
                return Tokens.Colors.Highlight.two.value
            case "player4":
                return Tokens.Colors.Highlight.six.value
            default:
                return Tokens.Colors.Highlight.four.value
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
    
    static func getName(playerName: String) -> String {
        var teamName: String = ""
        if let first = playerName.components(separatedBy: " ").first {
            teamName = first
        }
        
        switch playerName {
            case "player2":
                return "Raposa"
            case "player3":
                return "Panda"
            case "player4":
                return "Leão"
            default:
                return teamName
        }
    }
}
