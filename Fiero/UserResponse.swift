//
//  UserResponse.swift
//  Fiero
//
//  Created by Marina De Pazzi on 08/07/22.
//

import Foundation

struct UserResponse: Decodable {
    
    var token: String
    var user: User
}
