//
//  RecoveryAccountErrorCases.swift
//  Fiero
//
//  Created by Marina De Pazzi on 10/10/22.
//

import Foundation
import SwiftUI

//MARK: - RecoveryAccountErrorCases
enum RecoveryAccountErrorCases {
    case none
    case emptyFields
    case invalidEmail
    case noEmailFound
    case internalServerError
    
    var title: LocalizedStringKey {
        switch self {
            case .none:
                return "successfullySentEmailTitle"
            case .emptyFields:
                return "emptyFieldsTitle"
            case .invalidEmail:
                return "invalidEmailTitle"
            case .noEmailFound:
                return "accountNotFoundTitle"
            case .internalServerError:
                return "internalServerErrorTitle"
        }
    }
    
    var message: LocalizedStringKey {
        switch self {
            case .none:
                return "successfullySentEmailMessage"
            case .emptyFields:
                return "emptyFieldsMessage"
            case .invalidEmail:
                return "invalidEmailMessage"
            case .noEmailFound:
                return "accountNotFoundMessage"
            case .internalServerError:
                return "internalServerErrorMessage"
        }
    }
    
    var primaryButton: LocalizedStringKey {
        switch self {
            case .none:
                return "successfullySentEmailPrimaryButton"
            case .emptyFields:
                return "emptyFieldsPrimaryButton"
            case .invalidEmail:
                return "invalidEmailPrimaryButton"
            case .noEmailFound:
                return "accountNotFoundPrimaryButton"
            case .internalServerError:
                return "internalServerErrorPrimaryButton"
        }
    }
    
    var secondaryButton: LocalizedStringKey {
        switch self {
            case .none:
                return ""
            case .emptyFields:
                return ""
            case .invalidEmail:
                return ""
            case .noEmailFound:
                return "Cancelar"
            case .internalServerError:
                return ""
        }
    }
}

//MARK: - RecoveryAccountSecondStepErrorCases
enum RecoveryAccountSecondStepErrorCases {
    case none
    case emptyFields
    case wrongCode
    case unmatchedPasswords
    case internalServerError
    
    var title: LocalizedStringKey {
        switch self {
            case .none:
                return "passwordResetTitle"
            case .emptyFields:
                return "emptyFieldsSecondTitle"
            case .wrongCode:
                return "wrongCodeTitle"
            case .unmatchedPasswords:
                return "unmatchedPasswordsTitle"
            case .internalServerError:
                return "internalServerErrorTitle"
        }
    }
    
    var message: LocalizedStringKey {
        switch self {
            case .none:
                return "passwordResetMessage"
            case .emptyFields:
                return "emptyFieldsSecondMessage"
            case .wrongCode:
                return "wrongCodeMessage"
            case .unmatchedPasswords:
                return "unmatchedPasswordsMessage"
            case .internalServerError:
                return "internalServerErrorMessage"
        }
    }
    
    var primaryButton: LocalizedStringKey {
        switch self {
            case .none:
                return "passwordResetPrimaryButton"
            case .emptyFields:
                return "emptyFieldsPrimaryButton"
            case .wrongCode:
                return "wrongCodePrimaryButton"
            case .unmatchedPasswords:
                return "OK"
            case .internalServerError:
                return "internalServerErrorPrimaryButton"
        }
    }
    
    var secondaryButton: LocalizedStringKey {
        switch self {
            case .none:
                return ""
            case .emptyFields:
                return ""
            case .wrongCode:
                return "wrongCodeSecondaryButton"
            case .unmatchedPasswords:
                return "Cancelar"
            case .internalServerError:
                return ""
        }
    }
}
