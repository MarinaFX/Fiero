//
//  Team.swift
//  Fiero
//
//  Created by Marina De Pazzi on 20/07/22.
//

import Foundation

struct Team: Encodable, Decodable, Equatable {
    
    var id: String
    var quickChallengeId: String
    var name: String
    var owner: User
    var members: [User]?
}
