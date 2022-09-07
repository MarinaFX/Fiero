//
//  UDKeys.swift
//  Fiero
//
//  Created by Marina De Pazzi on 06/09/22.
//

import Foundation

enum UDKeys: CustomStringConvertible {
    case userID
    case username
    case email
    case password
    case authToken
    
    var description: String {
        switch self {
            case .userID:
                return "userID"
            case .username:
                return "name"
            case .email:
                return "email"
            case .password:
                return "password"
            case .authToken:
                return "AuthToken"
        }
    }
}