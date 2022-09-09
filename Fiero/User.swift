//
//  User.swift
//  Fiero
//
//  Created by Marina De Pazzi on 08/07/22.
//

import Foundation

struct User: Decodable, Encodable, Equatable {
    
    var id: String?
    var email: String
    var name: String
    var password: String?
    var token: String?
    
    var createdAt: String?
    var updatedAt: String?
    
}
