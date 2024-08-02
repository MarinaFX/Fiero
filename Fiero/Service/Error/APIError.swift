//
//  APIError.swift
//  Fiero
//
//  Created by Marina De Pazzi on 27/07/24.
//

import Foundation

protocol APIErrorConvertible: Error, CustomStringConvertible {
    init(message: String, timestamp: String)
}

struct APIError: APIErrorConvertible {
    
    var message: String
    var timestamp: String
    
    var description: String {
        return "API returned an Error " + ":---: " + self.message + " :---: " + self.timestamp
    }
    
    init(message: String, timestamp: String) {
        self.message = message
        self.timestamp = timestamp
    }
}
