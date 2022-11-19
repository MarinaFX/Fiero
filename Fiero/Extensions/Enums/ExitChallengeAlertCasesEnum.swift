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
    case errorWhenTryingToLeaveChallenge
    case none
    
    var title: LocalizedStringKey {
        switch self {
            case .exitChallenge:
                return "exitChallengeTitle"
            case .userOrChallengeNotFound:
                return "exitChallengeUserOrChallengeNotFoundTitle"
            case .userNotInChallenge:
                return "exitChallengeUserNotInChallengeTitle"
            case .internalServerError:
                return "exitChallengeInternalServerErrorTitle"
            case .errorWhenTryingToLeaveChallenge:
                return "exitChallengeErrorWhenTryingToLeaveChallengeTitle"
            case .none:
                return "not expected"
        }
    }
    
    var message: LocalizedStringKey {
        switch self {
            case .exitChallenge:
                return "exitChallengeMessage"
            case .userOrChallengeNotFound:
                return "exitChallengeUserOrChallengeNotFoundMessage"
            case .userNotInChallenge:
                return "exitChallengeUserNotInChallengeMessage"
            case .internalServerError:
                return "exitChallengeInternalServerErrorMessage"
            case .errorWhenTryingToLeaveChallenge:
                return "exitChallengeErrorWhenTryingToLeaveChallengeMessage"
            case .none:
                return "not expected"
        }
    }
    
    var primaryButton: LocalizedStringKey {
        switch self {
            case .exitChallenge:
                return "exitChallengePrimaryButton"
            case .userOrChallengeNotFound:
                return "exitChallengeUserOrChallengeNotFoundPrimaryButton"
            case .userNotInChallenge:
                return "exitChallengeUserNotInChallengePrimaryButton"
            case .internalServerError:
                return "exitChallengeInternalServerErrorPrimaryButton"
            case .errorWhenTryingToLeaveChallenge:
                return "exitChallengeErrorWhenTryingToLeaveChallengePrimaryButton"
            case .none:
                return "not expected"
        }
    }
    
    var secondaryButton: LocalizedStringKey {
        switch self {
            case .exitChallenge:
                return "exitChallengeSecondaryButton"
            case .userOrChallengeNotFound:
                return ""
            case .userNotInChallenge:
                return ""
            case .internalServerError:
                return ""
            case .errorWhenTryingToLeaveChallenge:
                return ""
            case .none:
                return "not expected"
        }
    }
}

