//
//  Team.swift
//  Fiero
//
//  Created by Marina De Pazzi on 20/07/22.
//

import Foundation

struct Team: Encodable, Decodable, Equatable, Identifiable, Hashable {
    
    var id: String
    var name: String
    var quickChallengeId: String
    var ownerId: String?
    var createdAt: String
    var updatedAt: String
    var members: [Member]?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(ownerId)
    }
    
    static func == (lhs: Team, rhs: Team) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.ownerId == rhs.ownerId
    }
    
    func isUserAtTeam(by userId: String) -> Bool {
        guard let members = self.members else { return false }
        return members.contains(where: { member in
            member.userId == userId
        })
    }
    
    func getTotalScore() -> Double {
        var score: Double = 0.0
        
        guard let members = self.members else { return -1.0 }
        
        for member in members {
            score += member.score
        }
        
        return score
    }
}
