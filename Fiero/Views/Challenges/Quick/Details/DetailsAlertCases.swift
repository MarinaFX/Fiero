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
    case failureWhileSavingPoints
    case failureDeletingChallenge
    
    var title: String {
        switch self {
            case .deleteChallenge:
                return "Apagar desafio"
            case .failureStartChallenge:
                return "Erro de conexão"
            case .failureWhileSavingPoints:
                return "Erro de salvamento"
            case .failureDeletingChallenge:
                return "Erro ao apagar desafio"
        }
    }
    
    var message: String {
        switch self {
            case .deleteChallenge:
                return "Essa ação não poderá ser desfeita."
            case .failureStartChallenge:
                return "Não foi possível iniciar o desafio, tente novamente mais tarde."
            case .failureWhileSavingPoints:
                return "Você ainda pode ver os pontos salvos localmente, mas a pontuação não pode ser salva na nuvem."
            case .failureDeletingChallenge:
                return "Não foi possível apagar o desafio, tente novamente mais tarde."
        }
    }
    
    var primaryButtonText: String {
        switch self {
            case .deleteChallenge:
                return "Cancelar"
            case .failureStartChallenge:
                return "OK"
            case .failureWhileSavingPoints:
                return "OK"
            case .failureDeletingChallenge:
                return "OK"
        }
    }
}
