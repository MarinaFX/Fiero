//
//  QuickChallengeResponse.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 04/08/22.
//

import Foundation

struct QuickChallengeResponse: Decodable, Equatable {
    
    var token: String
    var quickChallenges: [QuickChallenge]
}
