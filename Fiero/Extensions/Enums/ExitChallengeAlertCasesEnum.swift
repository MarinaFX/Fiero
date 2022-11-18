//
//  ExitChallengeAlertCasesEnum.swift
//  Fiero
//
//  Created by Marina De Pazzi on 03/11/22.
//

import Foundation
import SwiftUI

enum ExitChallengeAlertCasesEnum {
    case exitChallenge
    case userOrChallengeNotFound
    case userNotInChallenge
    case internalServerError
    case none
    
    var title: LocalizedStringKey {
        switch self {
            case .exitChallenge:
                return "exit challenge title"
            case .userOrChallengeNotFound:
                return "user or challenge not found title"
            case .userNotInChallenge:
                return "user not in challenge title"
            case .internalServerError:
                return "internal server error title"
            case .none:
                return "not expected"
        }
    }
    
    var message: LocalizedStringKey {
        switch self {
            case .exitChallenge:
                return "exit challenge message"
            case .userOrChallengeNotFound:
                return "user or challenge not found message"
            case .userNotInChallenge:
                return "user not in challenge message"
            case .internalServerError:
                return "internal server error message"
            case .none:
                return "not expected"
        }
    }
    
    var primaryButton: LocalizedStringKey {
        switch self {
            case .exitChallenge:
                return "exit challenge primaryButton"
            case .userOrChallengeNotFound:
                return "user or challenge not found primaryButton"
            case .userNotInChallenge:
                return "user not in challenge primaryButton"
            case .internalServerError:
                return "internal server error primaryButton"
            case .none:
                return "not expected"
        }
    }
}
