//
//  JoinChallengeAlertCasesEnum.swift
//  Fiero
//
//  Created by Marina De Pazzi on 24/10/22.
//

import Foundation

enum JoinChallengeAlertCases {
    case challengeNotFound
    case alreadyJoinedChallenge
    case internalServerError
    
    var title: String {
        switch self {
            case .challengeNotFound:
                return "implement string title"
            case .alreadyJoinedChallenge:
                return "implement string title"
            case .internalServerError:
                return "implement string title"
        }
    }
    
    var message: String {
        switch self {
            case .challengeNotFound:
                return "implement string message"
            case .alreadyJoinedChallenge:
                return "implement string message"
            case .internalServerError:
                return "implement string message"
        }
    }
    
    var primaryButton: String {
        switch self {
            case .challengeNotFound:
                return "implement primary button"
            case .alreadyJoinedChallenge:
                return "implement primary button"
            case .internalServerError:
                return "implement primary button"
        }
    }
    
    var secondaryButton: String {
        switch self {
            case .challengeNotFound:
                return "implement secondary Button"
            case .alreadyJoinedChallenge:
                return "implement secondary Button"
            case .internalServerError:
                return "implement secondary Button"
        }
    }
}
