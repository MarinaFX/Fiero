//
//  APIOrigin.swift
//  Fiero
//
//  Created by Marina De Pazzi on 27/07/24.
//

import Foundation

enum SaveOrigin {
    case challenge
    
    var value: String {
        switch self {
            case .challenge:
                return QuickChallengeEndpointEnum.CREATE_CHALLENGE.description
        }
    }
}

enum FetchOrigin {
    case challenges
    case challenge(String)
    
    var value: String {
        switch self {
            case .challenges:
                return QuickChallengeEndpointEnum.GET_CHALLENGES.description
            case .challenge(let id):
                return QuickChallengeEndpointEnum.GET_CHALLENGE.description + id
        }
    }
}

enum CreateOrigin {
    case challenge
    
    var value: String {
        switch self {
            case .challenge:
                return QuickChallengeEndpointEnum.CREATE_CHALLENGE.description
        }
    }
}
