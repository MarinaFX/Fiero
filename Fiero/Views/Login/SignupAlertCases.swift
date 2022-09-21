import Foundation

enum SignupAlertCases {
    case emptyFields
    case invalidEmail
    case accountAlreadyExists
    case connectionError
    case termsOfUse
    
    var title: String {
        switch self {
            case .emptyFields:
                return "Campos vazios"
            case .invalidEmail:
                return "E-mail inválido"
            case .accountAlreadyExists:
                return "Conta existente"
            case .connectionError:
                return "Oops, muito desafiador"
            case .termsOfUse:
                return "Termos de Uso"
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
                return "Tivemos um erro de conexão, tente mais tarde."
            case .termsOfUse:
                return "Você deve ler e aceitar os termos de uso para poder criar uma conta."
        }
    }
}
