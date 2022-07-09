//
//  User.swift
//  Fiero
//
//  Created by Marina De Pazzi on 08/07/22.
//

import Foundation

struct User: Decodable, Encodable {
    
    var id: String?
    var email: String
    var name: String
    var password: String
    
    var dateOfCreation: Date?
    var lastEdited: Date?
    
}
