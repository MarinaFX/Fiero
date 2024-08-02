//
//  APIOrigin.swift
//  Fiero
//
//  Created by Marina De Pazzi on 27/07/24.
//

import Foundation

enum DeleteOrigin {
    case deleteChallenge(String)
    case removeChallenger(String)
    case exitChallenge(String)
    
    var value: String {
        switch self {
            case .deleteChallenge(let id):
                return QuickChallengeEndpointEnum.DELETE_CHALLENGES.description + id
            case .removeChallenger(let id):
                return QuickChallengeEndpointEnum.REMOVE_PARTICIPANT.description + id
            case .exitChallenge(let id):
                return QuickChallengeEndpointEnum.EXIT_CHALLENGE.description + id
        }
    }
}

enum UpdateOrigin {
    case beginChallenge(String)
    case endChallenge(String)
    case updateScore
    
    var value: String {
        switch self {
            case .beginChallenge(let id):
                return QuickChallengeEndpointEnum.PATCH_CHALLENGES_BEGIN.description + id + "/alreadyBegin"
            case .updateScore:
                return QuickChallengeEndpointEnum.PATCH_CHALLENGES_SCORE.description
            case .endChallenge(let id):
                return QuickChallengeEndpointEnum.PATCH_CHALLENGES_FINISHED.description + id + "/finished"
        }
    }
}

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