//
//  QuickChallenge.swift
//  Fiero
//
//  Created by Marina De Pazzi on 20/07/22.
//

import Foundation

struct QuickChallenge: Decodable, Encodable, Equatable, Identifiable, Hashable {
    
    var id: String
    var name: String
    var invitationCode: String
    var type: String
    var goal: Int
    var goalMeasure: String
    var finished: Bool
    var ownerId: String
    var online: Bool
    var alreadyBegin: Bool
    var maxTeams: Int
    var createdAt: String
    var updatedAt: String
    var teams: [Team]
    var owner: User
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(ownerId)
    }
    
    static func == (lhs: QuickChallenge, rhs: QuickChallenge) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.ownerId == rhs.ownerId
    }
}
