//
//  RecoveryAccountErrorCases.swift
//  Fiero
//
//  Created by Marina De Pazzi on 10/10/22.
//

import Foundation

enum RecoveryAccountErrorCases: CustomStringConvertible {
    case none
    case emptyFields
    case invalidEmail
    case noEmailFound
    case internalServerError
    
    var description: String {
        switch self {
            case .none:
                return ""
            case .emptyFields:
                return ""
            case .invalidEmail:
                return ""
            case .noEmailFound:
                return ""
            case .internalServerError:
                return ""
        }
    }
}
