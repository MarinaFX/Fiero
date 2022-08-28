//
//  DetailsAlertCases.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 26/08/22.
//

import Foundation

enum DetailsAlertCases {
    case deleteChallenge
    case failureStartChallenge
    
    var title: String {
        switch self {
        case .deleteChallenge:
            return "Apagar desafio"
        case .failureStartChallenge:
            return "Erro de conexão"
        }
    }
    
    var message: String {
        switch self {
        case .deleteChallenge:
            return "Essa ação não poderá ser desfeita."
        case .failureStartChallenge:
            return "Não foi possível iniciar o desafio, tente novamente mais tarde."
        }
    }
    
    var primaryButtonText: String {
        switch self {
        case .deleteChallenge:
            return "Cancelar"
        case .failureStartChallenge:
            return "OK"
        }
    }
}
