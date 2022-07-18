//
//  ServerResponse.swift
//  Fiero
//
//  Created by Marina De Pazzi on 14/07/22.
//

import Foundation

/**
    Fiero's API error mapping. These are the current possible error outcomes from our servers
    **Login and Registration**
 
    - Success    (200) = Operation done successfully.
    - BadRequest (400) = email and/or password incorrect.
    
    **Login**
 
    - Forbidden (403) = Incorrect password.
    - NotFound  (404) = Valid email, but no registered accounts with.
    
    **Register**
    
    - Conflict  (409) = tries to create an account with an existing account linked with this email.
    
    **Any operation**
    - InternalServerError (500) = Generic Error.
    - Unauthorized        (401) = Currently not in use.
 */
enum ServerResponse: CustomStringConvertible {
    case success
    case badRequest
    case forbidden
    case notFound
    case conflict
    case internalError
    case unauthorized
    case unknown
    
    var statusCode: Int {
        get {
            switch self {
                case .success:
                    return 200
                case .badRequest:
                    return 400
                case .unauthorized:
                    return 401
                case .forbidden:
                    return 403
                case .notFound:
                    return 404
                case .conflict:
                    return 409
                case .internalError:
                    return 500
                case .unknown:
                    return 0
            }
        }
        set(newStatusCode) {
            switch newStatusCode {
                case 200:
                    self = .success
                case 400:
                    self = .badRequest
                case 401:
                    self = .unauthorized
                case 403:
                    self = .forbidden
                case 404:
                    self = .notFound
                case 409:
                    self = .conflict
                case 500:
                    self = .internalError
                default:
                    self = .unknown
            }
        }
    }
    
    var description: String {
        switch self {
            case .success:
                return "Operação realizada com sucesso"
            case .badRequest:
                return "Parece que o email que você tentou inserir é muito desafiador para ser um email"
            case .unauthorized:
                return "Você não possui permissão para realizar tal operação"
            case .forbidden:
                return "Essa combinação de senha e email foi tão desafiadora que está incorreta"
            case .notFound:
                return "Fala fella, bora fazer um projetinho no Fiero? Porque não ha contas regitradas com esse email"
            case .conflict:
                return "Parece que o email que você inseriu foi mais desafiador e ja esta em nossos cadastros"
            case .internalError:
                return "Aconteceu um erro com nossos servidores. Por favor, tente mais tarde"
            case .unknown:
                return "Erro desconhecido"
        }
    }
}
