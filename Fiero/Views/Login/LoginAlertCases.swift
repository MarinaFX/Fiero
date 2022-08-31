import Foundation

enum LoginAlertCases {
    case emptyFields
    case invalidEmail
    case loginError
    case connectionError
    case emailNotRegistrated
    
    var title: String {
        switch self {
        case .emptyFields:
            return "Campos vazios"
        case .invalidEmail:
            return "E-mail inválido"
        case .loginError:
            return "Erro no login"
        case .connectionError:
            return "Erro de conexão"
        case .emailNotRegistrated:
            return "E-mail não cadastrado"
        }
    }
    
    var message: String {
        switch self {
        case .emptyFields:
            return "Você precisa preencher todos os campos."
        case .invalidEmail:
            return "O e-mail informado não é válido."
        case .loginError:
            return "Seu e-mail e/ou senha estão incorretos."
        case .connectionError:
            return "Não foi possível acessar sua conta, tente novamente mais tarde."
        case .emailNotRegistrated:
            return "O e-mail informado é válido, mas não está vinculado a nenhuma conta."
        }
    }
}
