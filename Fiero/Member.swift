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
                return Tokens.Colors.Highlight.three.value
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
    
    static func getName(playerName: String) -> LocalizedStringKey {
        var teamName: LocalizedStringKey = ""
        if let first = playerName.components(separatedBy: " ").first {
            teamName = LocalizedStringKey(first)
        }
        
        switch playerName {
            case "player2":
                return LocalizedStringKey("player2")
            case "player3":
                return LocalizedStringKey("player3")
            case "player4":
                return LocalizedStringKey("player4")
            default:
                return teamName
        }
    }
}
