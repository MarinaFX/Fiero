//
//  UserLoginResponse.swift
//  Fiero
//
//  Created by Marina De Pazzi on 08/07/22.
//

import Foundation

struct UserLoginResponse: Decodable {
    
    var token: String
    var user: User
}

struct UserSignupResponse: Decodable {
    
    var user: User
}

struct UserDELETEResponse: Decodable {
    
    var message: String?
}
