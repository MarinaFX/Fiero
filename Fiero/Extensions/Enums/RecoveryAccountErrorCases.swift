//
//  RecoveryAccountErrorCases.swift
//  Fiero
//
//  Created by Marina De Pazzi on 10/10/22.
//

import Foundation
import SwiftUI

enum RecoveryAccountErrorCases {
    case none
    case emptyFields
    case invalidEmail
    case noEmailFound
    case wrongCode
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
            case .wrongCode:
                return ""
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
            case .wrongCode:
                return ""
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
            case .wrongCode:
                return "wrongCodePrimaryButton"
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
            case .wrongCode:
                return "wrongCodeSecondaryButton"
            case .internalServerError:
                return ""
        }
    }
}
