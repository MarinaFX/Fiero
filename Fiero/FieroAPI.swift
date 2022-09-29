//
//  FieroAPI.swift
//  Fiero
//
//  Created by Marina De Pazzi on 27/09/22.
//

import Foundation

enum FieroAPIEnum: CustomStringConvertible {
    case BASE_URL
    case localhost
    case localIP
    
    var description: String {
        switch self {
            case .BASE_URL:
                return "localhost"//"ec2-18-231-120-184.sa-east-1.compute.amazonaws.com"
            case .localhost:
                return "localhost"
            case .localIP:
                return "10.41.48.196"
        }
    }
}

enum QuickChallengeEndpointEnum: CustomStringConvertible {
    case CREATE_CHALLENGE
    case GET_CHALLENGES
    case DELETE_CHALLENGES
    case PATCH_CHALLENGES_BEGIN
    case PATCH_CHALLENGES_FINISHED
    case PATCH_CHALLENGES_SCORE
    
    var description: String {
        switch self {
            case .CREATE_CHALLENGE:
                return "/quickChallenge/create"
            case .GET_CHALLENGES:
                return "/quickChallenge/createdByMe"
            case .DELETE_CHALLENGES:
                return "/quickChallenge"
            case .PATCH_CHALLENGES_BEGIN:
                return "/quickChallenge"
            case .PATCH_CHALLENGES_FINISHED:
                return "/quickChallenge"
            case .PATCH_CHALLENGES_SCORE:
                return "/quickChallenge"
        }
    }
}

enum UserEndpointEnum: CustomStringConvertible {
    case SIGNUP
    case LOGIN
    case DELETE_USER
    case TOKEN
    
    var description: String {
        switch self {
            case .SIGNUP:
                return "/user/register"
            case .LOGIN:
                return "/user/login"
            case .DELETE_USER:
                return "/user"
            case .TOKEN:
                return "/user/token"
        }
    }
}
