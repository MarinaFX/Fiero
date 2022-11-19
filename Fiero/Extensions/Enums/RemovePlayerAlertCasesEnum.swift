//
//  RemovePlayerAlertCasesEnum.swift
//  Fiero
//
//  Created by Marina De Pazzi on 18/11/22.
//

import Foundation
import SwiftUI

enum RemovePlayerAlertCasesEnum {
    case userOrChallengeNotFound
    case removeItSelf
    case unauthorizedToRemove
    case userNotInThisChallenge
    case internalServerError
    case userRemoved
    
    var title: LocalizedStringKey {
        switch self {
            case .userOrChallengeNotFound:
                return "removePlayerUserOrChallengeNotFoundTitle"
            case .removeItSelf:
                return "removePlayerRemoveItSelfTitle"
            case .unauthorizedToRemove:
                return "removePlayerUnauthorizedToRemoveTitle"
            case .userNotInThisChallenge:
                return "removePlayerUserNotInThisChallengeTitle"
            case .internalServerError:
                return "removePlayerInternalServerErrorTitle"
            case .userRemoved:
                return "removePlayerErrorWhenRemovingPlayerFromChallengeTitle"
        }
    }
    
    var message: LocalizedStringKey {
        switch self {
            case .userOrChallengeNotFound:
                return "removePlayerUserOrChallengeNotFoundMessage"
            case .removeItSelf:
                return "removePlayerRemoveItSelfMessage"
            case .unauthorizedToRemove:
                return "removePlayerUnauthorizedToRemoveMessage"
            case .userNotInThisChallenge:
                return "removePlayerUserNotInThisChallengeMessage"
            case .internalServerError:
                return "removePlayerInternalServerErrorMessage"
            case .userRemoved:
                return "removePlayerErrorWhenRemovingPlayerFromChallengeMessage"
        }
    }
    
    var primaryButton: LocalizedStringKey {
        switch self {
            case .userOrChallengeNotFound:
                return "removePlayerUserOrChallengeNotFoundPrimaryButton"
            case .removeItSelf:
                return "removePlayerRemoveItSelfPrimaryButton"
            case .unauthorizedToRemove:
                return "removePlayerUnauthorizedToRemovePrimaryButton"
            case .userNotInThisChallenge:
                return "removePlayerUserNotInThisChallengePrimaryButton"
            case .internalServerError:
                return "removePlayerInternalServerErrorPrimaryButton"
            case .userRemoved:
                return "removePlayerErrorWhenRemovingPlayerFromChallengePrimaryButton"
        }
    }
}
