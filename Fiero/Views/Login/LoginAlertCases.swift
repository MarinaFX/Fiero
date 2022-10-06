import Foundation
import SwiftUI

enum LoginAlertCases {
    case emptyFields
    case invalidEmail
    case wrongCredentials
    case connectionError
    case emailNotRegistrated
    case accountAlreadyExists
    case termsOfUse
    
    var title: LocalizedStringKey {
        switch self {
        case .emptyFields:
            return "Campos vazios"
        case .invalidEmail:
            return "Oops, e-mail inválido"
        case .wrongCredentials:
            return "Oops, erro no login"
        case .connectionError:
            return "Oops, muito desafiador"
        case .emailNotRegistrated:
            return "Oops, não achamos esse perfil aqui"
        case .accountAlreadyExists:
            return "Conta existente"
        case .termsOfUse:
            return "Termos de Uso"
        }
    }
    
    var message: LocalizedStringKey {
        switch self {
        case .emptyFields:
            return "Você precisa preencher todos os campos."
        case .invalidEmail:
            return "O e-mail informado não é válido."
        case .wrongCredentials:
            return "Seu e-mail ou senha estão incorretos."
        case .connectionError:
            return "Tivemos um erro de conexão, tente mais tarde."
        case .emailNotRegistrated:
            return "Não encontramos uma conta vinculada ao seu e-mail."
        case .accountAlreadyExists:
            return "Já existe uma conta com o e-mail informado."
        case .termsOfUse:
            return "Você deve ler e aceitar os termos de uso para poder criar uma conta."
        }
    }
}
