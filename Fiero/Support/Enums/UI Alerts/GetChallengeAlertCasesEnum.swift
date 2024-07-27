//
//  GetChallengeAlertCasesEnum.swift
//  Fiero
//
//  Created by Marina De Pazzi on 31/10/22.
//

import Foundation
import SwiftUI

enum GetChallengeAlertCasesEnum {
    case challengeNotFound
    case internalServerError
    case userNotInChallenge
    
    var title: LocalizedStringKey {
        switch self {
            case .challengeNotFound:
                return "getChallengeNotFoundErrorTitle"
            case .internalServerError:
                return "getChallengeInternalServerErrorTitle"
            case .userNotInChallenge:
                return "getChallengeUserRemovedErrorTitle"
        }
    }
    
    var message: LocalizedStringKey {
        switch self {
            case .challengeNotFound:
                return "getChallengeNotFoundErrorMessage"
            case .internalServerError:
                return "getChallengeInternalServerErrorMessage"
            case .userNotInChallenge:
                return "getChallengeUserRemovedErrorMessage"
        }
    }
    
    var primaryButton: LocalizedStringKey {
        switch self {
            case .challengeNotFound:
                return "getChallengeAlertCasesPrimaryButton"
            case .internalServerError:
                return "getChallengeAlertCasesPrimaryButton"
            case .userNotInChallenge:
                return "getChallengeAlertCasesPrimaryButton"
        }
    }
}
