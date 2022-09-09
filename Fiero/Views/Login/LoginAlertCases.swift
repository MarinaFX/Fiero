import Foundation

enum LoginAlertCases {
    case emptyFields
    case invalidEmail
    case wrongCredentials
    case connectionError
    case emailNotRegistrated
    
    var title: String {
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
        }
    }
    
    var message: String {
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
        }
    }
}
