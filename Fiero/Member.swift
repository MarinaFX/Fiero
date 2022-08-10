//
//  Member.swift
//  Fiero
//
//  Created by Marina De Pazzi on 08/08/22.
//

import Foundation

struct Member: Decodable, Encodable, Equatable {
    
    var id: String
    var score: Double
    var userId: String?
    var teamId: String
    var beginDate: String?
    var botPicture: String?
    var createdAt: String
    var updatedAt: String
}
