//
//  JoinChallengeAlertCasesEnum.swift
//  Fiero
//
//  Created by Marina De Pazzi on 24/10/22.
//

import Foundation
import SwiftUI

enum JoinChallengeAlertCasesEnum {
    case none
    case challengeNotFound
    case alreadyJoinedChallenge
    case internalServerError
    case invalidCode
    
    var title: LocalizedStringKey {
        switch self {
            case .none:
                return ""
            case .challengeNotFound:
                return "joinChallengeNotFoundTitle"
            case .alreadyJoinedChallenge:
                return "joinAlreadyJoinedChallengeTitle"
            case .internalServerError:
                return "joinInternalServerErrorTitle"
            case .invalidCode:
                return "joinInvalidCodeTitle"
        }
    }
    
    var message: LocalizedStringKey {
        switch self {
            case .none:
                return ""
            case .challengeNotFound:
                return "joinChallengeNotFoundMessage"
            case .alreadyJoinedChallenge:
                return "joinAlreadyJoinedChallengeMessage"
            case .internalServerError:
                return "joinInternalServerErrorMessage"
            case .invalidCode:
                return "joinInvalidCodeMessage"
        }
    }
    
    var primaryButton: LocalizedStringKey {
        switch self {
            case .none:
                return ""
            case .challengeNotFound:
                return "joinChallengeNotFoundPrimaryButton"
            case .alreadyJoinedChallenge:
                return "joinAlreadyJoinedChallengePrimaryButton"
            case .internalServerError:
                return "joinInternalServerErrorPrimaryButton"
            case .invalidCode:
                return "joinInvalidCodePrimaryButton"
        }
    }
}
