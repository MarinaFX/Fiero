//
//  QuickChallengeGETResponse.swift
//  Fiero
//
//  Created by Marina De Pazzi on 20/07/22.
//

import Foundation

struct APIPluralResponse<T>: Codable where T: Codable {
    var data: [T]
    var timestamp: String
}

struct APISingleResponse<T>: Codable where T: Codable {
    var data: T?
    var message: String?
    var member: Member?
    var timestamp: String
}
