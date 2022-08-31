import Foundation

enum RegistrationAlertCases {
    case emptyFields
    case invalidEmail
    case accountAlreadyExists
    case connectionError
    
    var title: String {
        switch self {
        case .emptyFields:
            return "Campos vazios"
        case .invalidEmail:
            return "E-mail inválido"
        case .accountAlreadyExists:
            return "Conta existente"
        case .connectionError:
            return "Erro de conexão"
        }
    }
    
    var message: String {
        switch self {
        case .emptyFields:
            return "Você precisa preencher todos os campos."
        case .invalidEmail:
            return "O e-mail informado não é válido."
        case .accountAlreadyExists:
            return "Já existe uma conta com o e-mail informado."
        case .connectionError:
            return "Não foi possível criar sua conta, tente novamente mais tarde."
        }
    }
}
