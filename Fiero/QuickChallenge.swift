//
//  QuickChallenge.swift
//  Fiero
//
//  Created by Marina De Pazzi on 20/07/22.
//

import Foundation

struct QuickChallenge: Decodable, Encodable, Equatable {
    
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
}
