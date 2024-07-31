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
                return "localhost" //"ec2-3-138-121-168.us-east-2.compute.amazonaws.com"
            case .localhost:
                return "localhost"
            case .localIP:
                return "10.41.40.18"
        }
    }
}

enum QuickChallengeEndpointEnum: CustomStringConvertible {
    case CREATE_CHALLENGE
    case GET_CHALLENGES
    case GET_CHALLENGE
    case DELETE_CHALLENGES
    case ENTER_CHALLENGE
    case REMOVE_PARTICIPANT
    case EXIT_CHALLENGE
    case PATCH_CHALLENGES_BEGIN
    case PATCH_CHALLENGES_FINISHED
    case PATCH_CHALLENGES_SCORE
    
    var description: String {
        switch self {
            case .CREATE_CHALLENGE:
                return "/quickChallenge/create"
            case .GET_CHALLENGES:
                return "/quickChallenge/playing"
            case .GET_CHALLENGE:
                return "/quickChallenge/"
            case .DELETE_CHALLENGES:
                return "/quickChallenge"
            case .EXIT_CHALLENGE:
                return "/quickChallenge/exit"
            case .ENTER_CHALLENGE:
                return "/quickChallenge/join"
            case .REMOVE_PARTICIPANT:
                return "/quickChallenge/removeParticipant"
            
            case .PATCH_CHALLENGES_BEGIN:
                return "/quickChallenge/"
            case .PATCH_CHALLENGES_FINISHED:
                return "/quickChallenge/"
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
    case VERIFICATION_CODE
    case RESET_PASSWORD
    
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
            case .VERIFICATION_CODE:
                return "/user/verificationCode"
            case .RESET_PASSWORD:
                return "/user/password"
        }
    }
}
