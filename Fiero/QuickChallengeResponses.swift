//
//  QuickChallengeGETResponse.swift
//  Fiero
//
//  Created by Marina De Pazzi on 20/07/22.
//

import Foundation

struct QuickChallengeGETResponse: Decodable {
    
    var quickChallenges: [QuickChallenge]
}

struct QuickChallengePOSTResponse: Codable {
    
    var quickChallenge: [QuickChallenge]
}

struct QuickChallengeDELETEResponse: Decodable {
    
    var message: String?
}

struct QuickChallengePATCHResponse: Codable {
    
    var quickChallenge: QuickChallenge
}
