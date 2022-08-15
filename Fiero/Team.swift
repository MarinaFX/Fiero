//
//  Team.swift
//  Fiero
//
//  Created by Marina De Pazzi on 20/07/22.
//

import Foundation

struct Team: Encodable, Decodable, Equatable, Identifiable {
    
    var id: String
    var name: String
    var quickChallengeId: String
    var ownerId: String?
    var createdAt: String
    var updatedAt: String
    var members: [Member]?
}
